import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gpa_calculator/core/failure.dart';
import 'package:gpa_calculator/core/firebase_providers.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:gpa_calculator/features/semesters/repository/gradetonumber_repository.dart';
import 'package:gpa_calculator/models/grade_scale_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gradetoscale_controller.g.dart';

@riverpod
Stream<List<GradeToScale>> gradeToScaleStream(Ref ref) async* {
  yield* ref
      .read(firestoreProvider)
      .collection('users')
      .doc(ref.watch(userIDProvider))
      .collection('data')
      .doc('gradeToNumber')
      .snapshots()
      .asyncMap(
    (event) {
      if (event.data() == null) return [];
      return List<GradeToScale>.from(
        event.data()!['gradeToNumber'].map(
              (e) => GradeToScale.fromMap(e),
            ),
      );
    },
  );
}

@riverpod
Future<Map<String, dynamic>> gradeScaleMap(Ref ref) async {
  final listOfGradeScales =
      await ref.watch(gradeToScaleControllerProvider.future);

  Map<String, dynamic> map = {};

  listOfGradeScales.where((element) => element.isEnabled).forEach(
        (element) => map.addAll(element.map),
      );

  return map;
}

@riverpod
class GradeToScaleController extends _$GradeToScaleController {
  @override
  FutureOr<List<GradeToScale>> build() async {
    return await ref.watch(gradeToScaleStreamProvider.future);
  }

  late final GradeToScaleRepository _gradeToNumberRepository =
      ref.watch(gradeToNumberRepositoryProvider);

  Future<void> setDefaultMap(String uid) async {
    await _gradeToNumberRepository.setDefaultValue(uid);
  }

  Future<Either<Failure, Unit>> updateRemoteMap() async {
    try {
      if (!state.hasValue) return left(Failure('No value'));
      fixLocalMap();
      await _gradeToNumberRepository.updateValue(state.value!);
      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  void updateLocalMap(int index, GradeToScale gradeToScale) {
    final newList = List<GradeToScale>.from(state.value!);
    newList[index] = gradeToScale;
    state = AsyncValue.data(newList);
  }

  void fixLocalMap() {
    final newList = List<GradeToScale>.from(state.value!);
    for (var gradeToScale in newList) {
      gradeToScale.map.forEach((key, value) {
        if (value == '') {
          gradeToScale.map[key] = 0.0;
        }
      });
    }
    state = AsyncValue.data(newList);
  }

  Future<void> resetLocalMap(List<GradeToScale> list) async {
    state = AsyncValue.data(list);
    // await _gradeToNumberRepository.reset(list);
  }
}

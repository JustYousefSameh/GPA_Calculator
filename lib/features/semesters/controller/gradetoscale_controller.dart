import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:gpa_calculator/features/semesters/repository/gradetonumber_repository.dart';
import 'package:gpa_calculator/logic/firebase_providers.dart';
import 'package:gpa_calculator/models/grade_scale_model.dart';

final gradeToScaleStreamProvider = StreamProvider<List<GradeToScale>>(
  (ref) async* {
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
  },
);

final gradeScaleMapProvider = FutureProvider<Map<String, dynamic>>(
  (ref) async {
    final listOfGradeScales = await ref.watch(gradeToScaleProvider.future);

    Map<String, dynamic> map = {};

    listOfGradeScales.where((element) => element.isEnabled).forEach(
          (element) => map.addAll(element.map),
        );

    return map;
  },
);

final gradeToScaleProvider =
    AsyncNotifierProvider<GradeToScaleController, List<GradeToScale>>(
        GradeToScaleController.new);

class GradeToScaleController extends AsyncNotifier<List<GradeToScale>> {
  @override
  FutureOr<List<GradeToScale>> build() async {
    return await ref.watch(gradeToScaleStreamProvider.future);
  }

  late final GradeToScaleRepository _gradeToNumberRepository =
      ref.watch(gradeToNumberRepositoryProvider);

  Future<void> setDefaultMap(String uid) async {
    await _gradeToNumberRepository.setDefaultValue(uid);
  }

  Future<void> updateRemoteMap() async {
    if (!state.hasValue) return;
    await _gradeToNumberRepository.updateValue(state.value!);
  }

  Future<void> updateLocalMap(int index, GradeToScale gradeToScale) async {
    state = state..value![index] = gradeToScale;
  }
}

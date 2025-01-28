import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/core/firebase_providers.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:gpa_calculator/features/semesters/repository/semesters_repositroy.dart';
import 'package:gpa_calculator/models/course_model.dart';
import 'package:gpa_calculator/models/semester_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'semester_controller.g.dart';

// @riverpod
// class SemesterCounter extends _$SemesterCounter {
//   @override
//   FutureOr<int> build() async {
//     final semesterlist = await ref.watch(semesterStreamProvider.future);
//     return semesterlist.length;
//   }
// }

@riverpod
Stream<List<SemsesterModel>> semesterStream(Ref ref) async* {
  final id = ref.watch(userIDProvider);
  yield* ref
      .read(firestoreProvider)
      .collection('users')
      .doc(id)
      .collection('data')
      .doc('semesters')
      .snapshots()
      .where((event) => event.data() != null)
      .asyncMap(
    (event) async {
      return List<SemsesterModel>.from(
        event.data()!['semesters'].map((e) => SemsesterModel.fromMap(e)),
      );
    },
  );
}

@riverpod
class SemesterController extends _$SemesterController {
  @override
  FutureOr<List<SemsesterModel>> build() async {
    final value = await ref.read(semesterStreamProvider.future);
    return value;
  }

  late final SemesterRepository _semesterRepository =
      ref.watch(semestersRepositoryProvider);

  void updateSemesterFromRemote(List<SemsesterModel> semesters) {
    state = AsyncData(semesters);
  }

  void addSemester() {
    final List<SemsesterModel> newList =
        List.from(state.asData!.value..add(SemsesterModel.empty()));
    state = AsyncData(newList);
  }

  void deleteSemester(String id) async {
    state = AsyncData(List.from(state.value!
      ..remove(
          state.asData!.value.singleWhere((element) => element.id == id))));
  }

  void updateCourse(
      int semesterIndex, int courseIndex, CourseModel courseModel) {
    state = AsyncData(List.from(state.value!
      ..elementAt(semesterIndex).courses[courseIndex] = courseModel));
  }

  void onDisableGrade(String grade) {
    List<SemsesterModel> semesterList = List.from(state.requireValue);
    for (int i = 0; i < semesterList.length; i++) {
      for (int k = 0; k < semesterList[i].courses.length; k++) {
        final course = semesterList[i].courses[k];
        if (course.grade == grade) {
          semesterList[i].courses[k] = course.copyWith(grade: '');
        }
      }
    }

    state = AsyncValue.data(semesterList);
  }

  void addCourse(int semesterIndex) {
    state = AsyncData(List.from(state.value!
      ..elementAt(semesterIndex).courses.add(CourseModel.empty())));
  }

  void deleteCourse(int semesterIndex, int courseIndex) {
    state = AsyncData(List.from(
        state.value!..elementAt(semesterIndex).courses.removeAt(courseIndex)));
  }

  Future<void> updateRemoteDatabase() async {
    if (!state.hasValue) return;
    final successOrFailure =
        await _semesterRepository.updateAllDatabase(state.requireValue);
    successOrFailure.fold(
      (l) => throw l.message,
      (r) => null,
    );
  }
}

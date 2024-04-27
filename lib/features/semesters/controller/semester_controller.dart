import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:gpa_calculator/features/semesters/repository/semesters_repositroy.dart';
import 'package:gpa_calculator/logic/firebase_providers.dart';
import 'package:gpa_calculator/models/course_model.dart';
import 'package:gpa_calculator/models/semester_model.dart';

class SemesterCounterNotifier extends AsyncNotifier<int> {
  @override
  FutureOr<int> build() async {
    final semesterlist = await ref.watch(semesterStreamProvider.future);
    return semesterlist.length;
  }
}

final semesterCounterProvider =
    AsyncNotifierProvider<SemesterCounterNotifier, int>(
        SemesterCounterNotifier.new);

final semesterStreamProvider = StreamProvider<List<SemsesterModel>>(
  (ref) async* {
    yield* ref
        .read(firestoreProvider)
        .collection('users')
        .doc(ref.watch(userIDProvider))
        .collection('data')
        .doc('semesters')
        .snapshots()
        .asyncMap(
      (event) {
        if (event.data() == null) return [];
        return List<SemsesterModel>.from(
          event.data()!['semesters'].map((e) => SemsesterModel.fromMap(e)),
        );
      },
    );
  },
);

class SemesterController extends AsyncNotifier<List<SemsesterModel>> {
  @override
  FutureOr<List<SemsesterModel>> build() async {
    return await ref.watch(semesterStreamProvider.future);
  }

  late final SemesterRepository _semesterRepository =
      ref.watch(semestersRepositoryProvider);

  void addSemester() {
    final List<SemsesterModel> newList =
        List.from(state.asData!.value..add(SemsesterModel.empty()));
    ref.read(semesterCounterProvider.notifier).update((p0) => p0 + 1);
    state = AsyncData(newList);
  }

  void deleteSemester(String id) async {
    ref.read(semesterCounterProvider.notifier).update((p0) => p0 - 1);
    state = AsyncData(List.from(state.value!
      ..remove(
          state.asData!.value.singleWhere((element) => element.id == id))));
  }

  void updateCourse(
      int semesterIndex, int courseIndex, CourseModel courseModel) {
    state = AsyncData(List.from(state.value!
      ..elementAt(semesterIndex).courses[courseIndex] = courseModel));
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
        await _semesterRepository.updateAllDatabase(state.asData!.value);
    successOrFailure.fold(
      (l) => throw Error,
      (r) => null,
    );
  }
}

final semesterControllerProvider =
    AsyncNotifierProvider<SemesterController, List<SemsesterModel>>(
  SemesterController.new,
);

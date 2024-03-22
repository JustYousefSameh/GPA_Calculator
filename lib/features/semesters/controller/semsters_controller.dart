import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/features/semesters/controller/gradetonumber_controller.dart';
import 'package:gpa_calculator/features/semesters/controller/user_doc_controller.dart';
import 'package:gpa_calculator/features/semesters/repository/semesters_repositroy.dart';
import 'package:gpa_calculator/models/course_model.dart';
import 'package:gpa_calculator/models/semester_model.dart';

// final semesterStreamProvider =
//     StreamProvider<List<SemsesterModel>>((ref) async* {
//   final semestersSnapshot = ref
//       .read(firestoreProvider)
//       .collection('users')
//       .doc(ref.watch(userProvider)!.uid)
//       .collection('semesters')
//       .orderBy('timestamp', descending: false)
//       .snapshots();

//   yield* semestersSnapshot.map(
//     (event) => event.docs.map((e) => SemsesterModel.fromMap(e.data())).toList(),
//   );
// });

// final semesterRemoteFutureProvider =
//     FutureProvider<List<SemsesterModel>>((ref) async {
//   final semestersSnapshot = await ref
//       .read(firestoreProvider)
//       .collection('users')
//       .doc(ref.watch(userProvider)!.uid)
//       // .collection('semesters')
//       // .orderBy('timestamp', descending: false)
//       .get();

//   return data;
// });

class SemesterController extends AsyncNotifier<List<SemsesterModel>> {
  late final SemesterRepository _semesterRepository =
      ref.watch(semestersRepositoryProvider);

  late final gradeNumber = ref.watch(gradeScaleProvider.future);

  @override
  FutureOr<List<SemsesterModel>> build() async {
    final userDoc = await ref.watch(userDocProvider.future);

    final listOfModels = List<SemsesterModel>.from(
      userDoc.data()!['semesters'].map((e) => SemsesterModel.fromMap(e)),
    );
    return listOfModels;
  }

  void addSemester() {
    state = AsyncData(state.asData!.value..add(SemsesterModel.empty()));
  }

  void deleteSemester(String id) async {
    state = AsyncData(state.value!
      ..remove(state.asData!.value.singleWhere((element) => element.id == id)));
  }

  void updateCourse(
      int semesterIndex, int courseIndex, CourseModel courseModel) {
    state = state..value![semesterIndex].courses[courseIndex] = courseModel;
  }

  void addCourse(int semesterIndex) {
    state = AsyncData(state.value!
      ..elementAt(semesterIndex).courses.add(CourseModel.empty()));
  }

  void deleteCourse(int semesterIndex, int courseIndex) {
    state = AsyncData(
        state.value!..elementAt(semesterIndex).courses.removeAt(courseIndex));
  }

  Future<void> updateRemoteDatabase() async {
    await _semesterRepository.updateAllDatabase(state.asData!.value);
  }

  getSemesterGPA(List<CourseModel> courseModelList) {}
}

final semesterControllerProvider =
    AsyncNotifierProvider<SemesterController, List<SemsesterModel>>(
  SemesterController.new,
);

// final semesterControllerProvider = Provider(
//   (ref) => SemesterController(
//     semestersRepository: ref.read(semestersRepositoryProvider),
//   ),
// );

// class SemesterController {
//   SemesterController({required SemesterRepository semestersRepository})
//       : _semestersRepository = semestersRepository;
//   final SemesterRepository _semestersRepository;

//   Future<void> addSemester() async {
//     await _semestersRepository.addSemester(SemsesterModel.empty());
//   }

//   Future<void> deleteSemester(String id) async {
//     await _semestersRepository.deleteSemester(id);
//   }
// }

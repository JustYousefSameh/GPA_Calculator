// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
// import 'package:gpa_calculator/features/semesters/repository/courses_repository.dart';
// import 'package:gpa_calculator/logic/firebase_providers.dart';
// import 'package:gpa_calculator/models/course_model.dart';
// import 'package:gpa_calculator/models/semester_model.dart';

// final coursesStreamProvider =
//     StreamProvider.family<List<CourseModel>, String>((ref, args) async* {
//   final coursesSnapshots = ref
//       .read(firestoreProvider)
//       .collection('users')
//       .doc(ref.watch(userProvider)!.uid)
//       .collection('semesters')
//       .doc(args)
//       .collection('courses')
//       .orderBy('timestamp', descending: false)
//       .snapshots();

//   yield* coursesSnapshots.map(
//       (event) => event.docs.map((e) => CourseModel.fromMap(e.data())).toList());
// });

// final coursesFutureProvider = FutureProvider.family<List<CourseModel>, String>(
//   (ref, args) async {
//     final coursesSnapshots = await ref
//         .read(firestoreProvider)
//         .collection('users')
//         .doc(ref.read(userProvider)!.uid)
//         .collection('semesters')
//         .doc(args)
//         .collection('courses')
//         .orderBy('timestamp', descending: false)
//         .snapshots()
//         .first;

//     return coursesSnapshots.docs
//         .map((e) => CourseModel.fromMap(e.data()))
//         .toList();
//   },
// );

// final courseControllerProvider =
//     Provider.family<CourseController, String>((ref, args) => CourseController(
//           courseRepository: ref.read(courseRepositoryProvider),
//           ref: ref,
//           semesterId: args,
//         ));

// class CourseController {
//   final CourseRepository _courseRepository;
//   final String _semesterId;
//   final Ref _ref;

//   CourseController(
//       {required CourseRepository courseRepository,
//       required Ref ref,
//       required String semesterId})
//       : _courseRepository = courseRepository,
//         _ref = ref,
//         _semesterId = semesterId;

//   late final coursesStream =
//       _ref.watch(coursesStreamProvider(_semesterId)).value;

//   Future<void> addCourse(SemsesterModel semsesterModel) async {
//     CourseModel courseModel = CourseModel.empty();
//     await _courseRepository.addCourse(semsesterModel, courseModel);
//   }

//   Future<void> deleteCourse(SemsesterModel semsesterModel, int index) async {
//     await _courseRepository.deleteCourse(semsesterModel, index);
//   }

//   Future<void> updateCourse(
//       SemsesterModel semsesterModel, CourseModel model, int index) async {
//     await _courseRepository.updateCourse(semsesterModel, model, index);
//   }
// }

import 'package:flutter/material.dart';
import 'package:gpa_calculator/core/common/drop_down_menu.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:gpa_calculator/features/database/courses_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/logic/firebase_providers.dart';
import 'package:gpa_calculator/models/semester_model.dart';

class CourseWidgetData {
  TextEditingController courseName = TextEditingController(text: 'Hello');
  TextEditingController courseCredits = TextEditingController();
}

final courseTextEditingProvider =
    Provider.family<CourseWidgetData, String>((ref, id) {
  return CourseWidgetData();
});

final coursesStreamProvider =
    StreamProvider.family<List<CourseModel>, String>((ref, args) async* {
  final coursesSnapshots = ref
      .read(firestoreProvider)
      .collection('users')
      .doc(ref.read(userProvider)!.uid)
      .collection('semesters')
      .doc(args)
      .collection('courses')
      .orderBy('timestamp', descending: false)
      .snapshots();

  yield* coursesSnapshots.map(
      (event) => event.docs.map((e) => CourseModel.fromMap(e.data())).toList());
});

final coursesFutureProvider = FutureProvider.family<List<CourseModel>, String>(
  (ref, args) async {
    final coursesSnapshots = await ref
        .read(firestoreProvider)
        .collection('users')
        .doc(ref.read(userProvider)!.uid)
        .collection('semesters')
        .doc(args)
        .collection('courses')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .first;

    return coursesSnapshots.docs
        .map((e) => CourseModel.fromMap(e.data()))
        .toList();

    // return coursesSnapshots.docs
    //     .map((e) => CourseModel.fromMap(e.data()))
    //     .toList();
  },
);

final courseControllerProvider =
    Provider.family<CourseController, String>((ref, args) => CourseController(
          courseRepository: ref.read(courseRepositoryProvider),
          ref: ref,
          semesterId: args,
        ));

class CourseController {
  final CourseRepository _courseRepository;
  final String _semesterId;
  final Ref _ref;

  CourseController(
      {required CourseRepository courseRepository,
      required Ref ref,
      required String semesterId})
      : _courseRepository = courseRepository,
        _ref = ref,
        _semesterId = semesterId;

  late final coursesStream =
      _ref.watch(coursesStreamProvider(_semesterId)).value;

  void addCourse(String semesterId, CourseModel courseModel) {
    _courseRepository.addCourse(semesterId, courseModel);
  }

  void deleteCourse(String semesterId, String courseId) async {
    _courseRepository.deleteCourse(semesterId, courseId);
  }

  void updateCourse(String semesterId, CourseModel model) {
    _courseRepository.updateCourse(semesterId, model.id, model.toMap());
  }

  double getSemesterGPA() {
    double totalCredit = 0;
    double gradePoints = 0;
    coursesStream?.forEach(
      (element) {
        gradePoints += element.credits * (gradeNumber[element.grade] ?? 0);
      },
    );
    totalCredit = getTotalCredit();
    return (gradePoints / totalCredit).isNaN
        ? 0
        : double.parse((gradePoints / totalCredit).toStringAsPrecision(3));
  }

  double getTotalCredit() {
    double totalCredit = 0;
    coursesStream?.forEach(
      (element) {
        if (element.credits != 0) {
          totalCredit += element.credits;
        }
      },
    );
    return totalCredit;
  }
}

// class CourseNotifierData {
//   List<CourseWidgetData> listCourseWidgets = [];

//   CourseNotifierData({required this.listCourseWidgets});
// }

// class CourseWidgetData {
//   String grade = "A+";
//   TextEditingController courseName = TextEditingController();
//   TextEditingController courseCredits = TextEditingController();
// }

// class CourseNotifier extends FamilyNotifier<Future<List<CourseModel>>, String> {
//   late final _courseRepository = ref.read(courseRepositoryProvider);

//   @override
//   Future<List<CourseModel>> build(String arg) async {
//     final coursesSnapshots = await ref
//         .read(firestoreProvider)
//         .collection('users')
//         .doc(ref.read(userProvider)!.uid)
//         .collection('semesters')
//         .doc(arg)
//         .collection('courses')
//         .orderBy('timestamp', descending: false)
//         .snapshots()
//         .first;

//     // return coursesSnapshots(
//     //     (event) => event.docs.map((e) => CourseModel.fromMap(e.data())).toList());

//     return coursesSnapshots.docs
//         .map((e) => CourseModel.fromMap(e.data()))
//         .toList();
//   }

//   // update() {d
//   //   ref.watch(gpaProvider.notifier).getGPA();
//   //   state = Future.value(List.from(state)) ;
//   // }
//   void addCourse(String semesterId) async {
//     final courseToAdd = CourseModel.empty();
//     final currentState = await state;
//     ref.invalidate(courseProvider(semesterId));
//     state = Future.sync(() => List.from(currentState)..add(courseToAdd));
//     await _courseRepository.addCourse(semesterId, courseToAdd);
//   }

//   // removeCourse(int index) {
//   //   state = List.from(state)..removeAt(index);
//   // }

//   // changeGrade(String grade, int index) {
//   //   state = List.from(state)..elementAt(index).grade = grade;
//   //   ref.watch(gpaProvider.notifier).getGPA();
//   // }

//   // double getSemesterGPA() {
//   //   double totalCredit = 0;
//   //   double gradePoints = 0;

//   //   for (CourseWidgetData data in state) {
//   //     if (data.courseCredits.text == "") continue;
//   //     double credits = double.parse(data.courseCredits.text);
//   //     // gradePoints += credits * (gradeNumber[data.grade] ?? 0);
//   //   }
//   //   totalCredit = getTotalCredit();
//   //   return (gradePoints / totalCredit).isNaN
//   //       ? 0
//   //       : double.parse((gradePoints / totalCredit).toStringAsPrecision(3));
//   // }

//   // double getTotalCredit() {
//   //   double totalCredit = 0;
//   //   for (CourseWidgetData data in state) {
//   //     if (data.courseCredits.text == "") continue;
//   //     double credits = double.parse(data.courseCredits.text);
//   //     totalCredit += credits;
//   //   }
//   //   return totalCredit;
//   // }
// }

// final courseProvider =
//     NotifierProvider.family<CourseNotifier, Future<List<CourseModel>>, String>(
//   () => CourseNotifier(),
// );

import 'package:gpa_calculator/features/semesters/widgets/drop_down_menu.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:gpa_calculator/features/semesters/repository/courses_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/logic/firebase_providers.dart';
import 'package:gpa_calculator/models/semester_model.dart';

final coursesStreamProvider =
    StreamProvider.family<List<CourseModel>, String>((ref, args) async* {
  final coursesSnapshots = ref
      .read(firestoreProvider)
      .collection('users')
      .doc(ref.watch(userProvider)!.uid)
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

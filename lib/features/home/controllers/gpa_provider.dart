import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/features/semesters/controller/gradetoscale_controller.dart';
import 'package:gpa_calculator/features/semesters/controller/semester_controller.dart';
import 'package:gpa_calculator/models/course_model.dart';

final semesterGPAProvider =
    FutureProvider.family<double, int>((ref, semesterIndex) async {
  final courseList =
      ref.watch(semesterControllerProvider).value![semesterIndex].courses;
  ref.watch(semesterControllerProvider);
  final gradeNumber = await ref.watch(gradeScaleMapProvider.future);

  double getTotalCredit(List<CourseModel> courseModelList) {
    double totalCredit = 0;
    for (var element in courseModelList) {
      if (element.grade != '') {
        totalCredit += element.credits;
      }
    }
    return totalCredit;
  }

  double totalCredit = 0;
  double gradePoints = 0;
  for (var element in courseList) {
    gradePoints += element.credits * (gradeNumber[element.grade] ?? 0);
  }
  totalCredit = getTotalCredit(courseList);
  return (gradePoints / totalCredit).isNaN
      ? 0
      : double.parse((gradePoints / totalCredit).toStringAsPrecision(3));
});

final gpaStateProvider = FutureProvider(
  (ref) async {
    double totalGradePoints = 0;
    double totalCredits = 0;

    final semesterList = await ref.watch(semesterControllerProvider.future);
    final gradeNumber = await ref.watch(gradeScaleMapProvider.future);

    double getTotalCredit(List<CourseModel> courseModelList) {
      double totalCredit = 0;
      for (var element in courseModelList) {
        if (element.grade != '') {
          totalCredit += element.credits;
        }
      }
      return totalCredit;
    }

    double getgradePoints(List<CourseModel> courseModelList) {
      double gradePoints = 0;
      for (var element in courseModelList) {
        gradePoints += element.credits * (gradeNumber[element.grade] ?? 0);
      }
      return gradePoints;
    }

    for (var semesterModel in semesterList) {
      totalCredits += getTotalCredit(semesterModel.courses);
      totalGradePoints += getgradePoints(semesterModel.courses);
    }

    final result = <double>[
      ((totalGradePoints / totalCredits).isNaN)
          ? 0
          : double.parse(
              (totalGradePoints / totalCredits).toStringAsPrecision(3)),
      totalCredits
    ];

    return result;
  },
);

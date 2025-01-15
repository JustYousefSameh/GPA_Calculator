import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/features/semesters/controller/gradetoscale_controller.dart';
import 'package:gpa_calculator/features/semesters/controller/semester_controller.dart';
import 'package:gpa_calculator/models/course_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gpa_provider.g.dart';

@riverpod
Future<double> semesterGPA(Ref ref, int semesterIndex) async {
  final semesterList = ref.watch(semesterControllerProvider).value!;

  if (semesterIndex >= semesterList.length) return 0;
  final courseList = semesterList[semesterIndex].courses;

  ref.watch(semesterControllerProvider);
  final gradeNumber = await ref.watch(gradeScaleMapProvider.future);

  double getTotalCredit(List<CourseModel> courseModelList) {
    double totalCredit = 0;
    for (var element in courseModelList) {
      if (element.grade != '' && element.credits != null) {
        totalCredit += element.credits!;
      }
    }
    return totalCredit;
  }

  double totalCredit = 0;
  double gradePoints = 0;
  for (var element in courseList) {
    if (element.credits == null) continue;
    gradePoints += element.credits! * (gradeNumber[element.grade] ?? 0);
  }
  totalCredit = getTotalCredit(courseList);
  return (gradePoints / totalCredit).isNaN
      ? 0
      : double.parse((gradePoints / totalCredit).toStringAsPrecision(3));
}

@riverpod
Future<List<double>> gpaState(Ref ref) async {
  double totalGradePoints = 0;
  double totalCredits = 0;

  final semesterList = await ref.watch(semesterControllerProvider.future);
  final gradeNumber = await ref.watch(gradeScaleMapProvider.future);

  double getTotalCredit(List<CourseModel> courseModelList) {
    double totalCredit = 0;
    for (var element in courseModelList) {
      if (element.grade != '' && element.credits != null) {
        totalCredit += element.credits!;
      }
    }
    return totalCredit;
  }

  double getgradePoints(List<CourseModel> courseModelList) {
    double gradePoints = 0;
    for (var element in courseModelList) {
      if (element.credits == null) continue;
      gradePoints += element.credits! * (gradeNumber[element.grade] ?? 0);
    }
    return gradePoints;
  }

  for (var semesterModel in semesterList) {
    totalCredits += getTotalCredit(semesterModel.courses);
    totalGradePoints += getgradePoints(semesterModel.courses);
  }

  totalCredits = double.parse(totalCredits.toStringAsPrecision(3));

  final result = <double>[
    ((totalGradePoints / totalCredits).isNaN)
        ? 0
        : double.parse(
            (totalGradePoints / totalCredits).toStringAsPrecision(3)),
    totalCredits,
  ];

  return result;
}

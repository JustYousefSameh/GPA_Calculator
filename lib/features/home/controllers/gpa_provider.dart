import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/features/semesters/controller/gradetonumber_controller.dart';
import 'package:gpa_calculator/features/semesters/controller/semsters_controller.dart';
import 'package:gpa_calculator/models/course_model.dart';

final semesterGPAProvider = FutureProvider.autoDispose
    .family<double, List<CourseModel>>((ref, courseList) async {
  ref.watch(semesterControllerProvider);
  final gradeNumber = await ref.watch(gradeScaleProvider.future);

  double getTotalCredit(List<CourseModel> courseModelList) {
    double totalCredit0 = 0;
    for (var element in courseModelList) {
      totalCredit0 += element.credits;
    }
    return totalCredit0;
  }

  double totalCredit = 0;
  double gradePoints = 0;
  for (var element in courseList) {
    gradePoints += element.credits * (gradeNumber[element.grade] ?? 0);
  }
  totalCredit = getTotalCredit(courseList);
  print(gradePoints / totalCredit);
  return (gradePoints / totalCredit).isNaN
      ? 0
      : double.parse((gradePoints / totalCredit).toStringAsPrecision(3));
});

final gpaStateProvider = FutureProvider((ref) async {
  double totalGradePoints = 0;
  double totalCredits = 0;

  final semesterList = await ref.watch(semesterControllerProvider.future);
  final gradeNumber = await ref.watch(gradeScaleProvider.future);

  double getTotalCredit(List<CourseModel> courseModelList) {
    double totalCredit = 0;
    for (var element in courseModelList) {
      if (element.credits != 0) {
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
});

// class GPAStateProviderController extends AsyncNotifier<List<double>> {
//   @override
//   FutureOr<List<double>> build() async {
//     double totalGradePoints = 0;
//     double totalCredits = 0;

//     final semesterList = await ref.watch(semesterControllerProvider.future);
//     final gradeNumber = await ref.watch(gradeScaleProvider.future);

//     double getTotalCredit(List<CourseModel> courseModelList) {
//       double totalCredit = 0;
//       for (var element in courseModelList) {
//         if (element.credits != 0) {
//           totalCredit += element.credits;
//         }
//       }
//       return totalCredit;
//     }

//     double getgradePoints(List<CourseModel> courseModelList) {
//       double gradePoints = 0;
//       for (var element in courseModelList) {
//         gradePoints += element.credits * (gradeNumber[element.grade] ?? 0);
//       }
//       return gradePoints;
//     }

//     for (var semesterModel in semesterList) {
//       totalCredits += getTotalCredit(semesterModel.courses);
//       totalGradePoints += getgradePoints(semesterModel.courses);
//     }

//     final result = <double>[
//       if ((totalGradePoints / totalCredits).isNaN)
//         0
//       else
//         double.parse((totalGradePoints / totalCredits).toStringAsPrecision(3)),
//       totalCredits
//     ];

//     return result;
//   }
// }

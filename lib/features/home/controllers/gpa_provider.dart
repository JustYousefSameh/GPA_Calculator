import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/features/database/courses_controller.dart';
import 'package:gpa_calculator/features/database/semsters_controller.dart';

final gpaStateProvider = StateProvider<List<double>>((ref) {
  double gpa = 0;
  double totalCredits = 0;

  final semesterStream = ref.watch(semesterStreamProvider);

  semesterStream.whenData(
    (semesterModelList) {
      for (var semesterModel in semesterModelList) {
        final courseStream =
            ref.watch(courseControllerProvider(semesterModel.id));

        gpa += (courseStream.getSemesterGPA() * courseStream.getTotalCredit());
        totalCredits += courseStream.getTotalCredit();
      }
    },
  );

  final List<double> result = [
    (gpa / totalCredits).isNaN
        ? 0
        : double.parse((gpa / totalCredits).toStringAsPrecision(3)),
    totalCredits
  ];

  return result;
});

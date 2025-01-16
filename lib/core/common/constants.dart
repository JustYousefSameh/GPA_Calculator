import 'package:gpa_calculator/models/grade_scale_model.dart';

class Constants {
  static const googlePath = 'assets/images/google.png';

  static RegExp regex = RegExp(r'([.]*0)');

  static String errorText = 'An error has occured sorry for the inconvenience';

  static const gradeScale = [
    GradeToScale(isEnabled: true, map: {"A+": 4.3}),
    GradeToScale(isEnabled: true, map: {"A": 4.0}),
    GradeToScale(isEnabled: true, map: {"A-": 3.7}),
    GradeToScale(isEnabled: true, map: {"B+": 3.3}),
    GradeToScale(isEnabled: true, map: {"B": 3.0}),
    GradeToScale(isEnabled: true, map: {"B-": 2.7}),
    GradeToScale(isEnabled: true, map: {"C+": 2.3}),
    GradeToScale(isEnabled: true, map: {"C": 2.0}),
    GradeToScale(isEnabled: true, map: {"C-": 1.7}),
    GradeToScale(isEnabled: true, map: {"D+": 1.3}),
    GradeToScale(isEnabled: true, map: {"D": 1.0}),
    GradeToScale(isEnabled: true, map: {"D-": 0.7}),
    GradeToScale(isEnabled: true, map: {"F": 0.0}),
  ];
}

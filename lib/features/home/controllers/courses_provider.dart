import 'package:flutter/material.dart';
import 'package:gpa_calculator/features/home/controllers/gpa_provider.dart';
import 'package:gpa_calculator/core/common/drop_down_menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CourseNotifierData {
  List<CourseWidgetData> listCourseWidgets = [];

  CourseNotifierData({required this.listCourseWidgets});
}

class CourseWidgetData {
  String grade = "A+";
  TextEditingController courseName = TextEditingController();
  TextEditingController courseCredits = TextEditingController();
}

class CourseNotifier extends FamilyNotifier<List<CourseWidgetData>, int> {
  @override
  List<CourseWidgetData> build(int arg) {
    return [
      CourseWidgetData(),
      CourseWidgetData(),
      CourseWidgetData(),
      CourseWidgetData()
    ];
  }

  update() {
    ref.watch(gpaProvider.notifier).getGPA();
    state = List.from(state);
  }

  changeGrade(String grade, int index) {
    state = List.from(state)..elementAt(index).grade = grade;
    ref.watch(gpaProvider.notifier).getGPA();
  }

  double getSemesterGPA() {
    double totalCredit = 0;
    double gradePoints = 0;

    for (CourseWidgetData data in state) {
      if (data.courseCredits.text == "") continue;
      double credits = double.parse(data.courseCredits.text);
      gradePoints += credits * (gradeNumber[data.grade] ?? 0);
    }
    totalCredit = getTotalCredit();
    return (gradePoints / totalCredit).isNaN
        ? 0
        : double.parse((gradePoints / totalCredit).toStringAsPrecision(3));
  }

  double getTotalCredit() {
    double totalCredit = 0;
    for (CourseWidgetData data in state) {
      if (data.courseCredits.text == "") continue;
      double credits = double.parse(data.courseCredits.text);
      totalCredit += credits;
    }
    return totalCredit;
  }

  addCourse() {
    state = List.from(state)..add(CourseWidgetData());
  }

  removeCourse(int index) {
    state = List.from(state)..removeAt(index);
  }
}

final courseProvider =
    NotifierProvider.family<CourseNotifier, List<CourseWidgetData>, int>(
  () => CourseNotifier(),
);

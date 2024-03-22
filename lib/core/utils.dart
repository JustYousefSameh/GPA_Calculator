import 'package:flutter/material.dart';
import 'package:gpa_calculator/models/grade_scale_model.dart';

void showErrorSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 75,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xffc72c41),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: double.infinity,
            width: double.infinity,
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.white,
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    text,
                    maxLines: 3,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
}

void showSuccessSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 75,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 39, 139, 26),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: double.infinity,
            width: double.infinity,
            child: Row(
              children: [
                const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    text,
                    maxLines: 3,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
}

const gradeScale = [
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

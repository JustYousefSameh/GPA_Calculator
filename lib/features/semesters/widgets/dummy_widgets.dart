import 'package:flutter/material.dart';
import 'package:gpa_calculator/core/constants/constants.dart';
import 'package:gpa_calculator/features/semesters/widgets/course_list_widget.dart';
import 'package:gpa_calculator/features/semesters/widgets/semester_widget.dart';
import 'package:gpa_calculator/models/semester_model.dart';

class _TextWidget extends StatelessWidget {
  const _TextWidget({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}

class DummyCourseWidget extends StatelessWidget {
  const DummyCourseWidget({
    super.key,
    required this.courseName,
    required this.credits,
    required this.grade,
  });

  final String courseName;
  final double credits;
  final String grade;

  @override
  Widget build(BuildContext context) {
    final creditsString = credits.toString() == '0.0'
        ? ''
        : credits.toString().replaceAll(Constants.regex, '');
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                ),
                child: _TextWidget(text: courseName),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _TextWidget(text: grade),
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: Theme.of(context)
                            .dropdownMenuTheme
                            .inputDecorationTheme!
                            .iconColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                ),
                child: _TextWidget(text: creditsString),
              ),
            ),
          ),
          const Expanded(
            child: Icon(
              Icons.close,
              color: Color.fromARGB(255, 143, 143, 143),
            ),
          ),
        ],
      ),
    );
  }
}

class DummySemesterWidget extends StatelessWidget {
  const DummySemesterWidget({
    super.key,
    required this.semesterIndex,
    required this.semesterModel,
  });

  final int semesterIndex;
  final SemsesterModel semesterModel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: Theme.of(context).colorScheme.onInverseSurface,
            width: 1,
          ),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Semester ${semesterIndex + 1}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Icon(
                    Icons.delete,
                    size: 26,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Labels(),
              const SizedBox(height: 10),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: semesterModel.courses
                    .map(
                      (e) => DummyCourseWidget(
                          courseName: e.courseName,
                          credits: e.credits,
                          grade: e.grade),
                    )
                    .toList(),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 125,
                    height: 35,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      label: const Text('Add Course'),
                    ),
                  ),
                  SemesterGPA(
                    semesterIndex: semesterIndex,
                    passedCourseList: semesterModel.courses,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

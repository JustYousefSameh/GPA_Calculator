import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/core/theme.dart';
import 'package:gpa_calculator/features/semesters/controller/semsters_controller.dart';
import 'package:gpa_calculator/features/semesters/widgets/animated_courseslist.dart';
import 'package:gpa_calculator/models/semester_model.dart';

class SemesterWidget extends ConsumerWidget {
  const SemesterWidget({
    required this.semesterIndex,
    required this.semsesterModel,
    super.key,
  });

  final int semesterIndex;
  final SemsesterModel semsesterModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Semester ${semesterIndex + 1}',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                //delete semester button
                GestureDetector(
                  onTap: () => ref
                      .read(semesterControllerProvider.notifier)
                      .deleteSemester(semsesterModel.id),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: 28,
                    child: const Icon(
                      Icons.delete,
                      size: 26,
                      color: secondary300,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Labels(),
          const SizedBox(height: 10),
          CourseList(
            semsesterModel: semsesterModel,
            semesterIndex: semesterIndex,
          ),
        ],
      ),
    );
  }
}

class Labels extends StatelessWidget {
  const Labels({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Text(
                'Course Name',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child:
                  Text('Grade', style: Theme.of(context).textTheme.labelLarge),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                'Credits',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
          const Expanded(child: SizedBox())
        ],
      ),
    );
  }
}

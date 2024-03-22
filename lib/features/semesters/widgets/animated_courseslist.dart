import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpa_calculator/core/theme.dart';
import 'package:gpa_calculator/features/home/controllers/gpa_provider.dart';
import 'package:gpa_calculator/features/semesters/controller/semsters_controller.dart';
import 'package:gpa_calculator/models/semester_model.dart';

import 'course_widget.dart';

class CourseList extends ConsumerWidget {
  CourseList({
    super.key,
    required this.semsesterModel,
    required this.semesterIndex,
  }) : semesterId = semsesterModel.id;

  final SemsesterModel semsesterModel;
  final int semesterIndex;
  final String semesterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: semsesterModel.courses
              .mapWithIndex(
                (e, index) => CourseWidget(
                  semsesterModel: semsesterModel,
                  semesterIndex: semesterIndex,
                  courseIndex: index,
                ),
              )
              .toList(),
        ),
        // AnimatedList(
        //   initialList: semsesterModel.courses,
        //   scrollPhysics: const NeverScrollableScrollPhysics(),
        //   shrinkWrap: true,
        //   streamList: stream,
        //   itemBuilder: _buildItem,
        //   itemRemovedBuilder: _buildRemovedItem,
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SemesterGPA(
              semsesterModel: semsesterModel,
            ),
            AddCourseButton(
              semsesterModel: semsesterModel,
              semesterIndex: semesterIndex,
            ),
          ],
        ),
      ],
    );
  }

  // // Used to build list items that haven't been removed.
  // Widget _buildItem(
  //   CourseModel courseModel,
  //   int index,
  //   BuildContext context,
  //   Animation<double> animation,
  // ) {
  //   return CourseWidget(
  //     index: index,
  //     courseModel: courseModel,
  //     semesterId: semesterId,
  //     animation: animation,
  //   );
  // }

  // Widget _buildRemovedItem(
  //   CourseModel item,
  //   int index,
  //   BuildContext context,
  //   Animation<double> animation,
  // ) {
  //   return CourseWidget(
  //     courseModel: item,
  //     semesterId: semesterId,
  //     index: 0,
  //     animation: animation,
  //   );
  // }
}

class AddCourseButton extends ConsumerWidget {
  const AddCourseButton({
    super.key,
    required this.semsesterModel,
    required this.semesterIndex,
  });

  final SemsesterModel semsesterModel;
  final int semesterIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(semesterControllerProvider.notifier);
    return SizedBox(
      width: 150,
      height: 40,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(width: 0.7),
          shape: const StadiumBorder(),
          padding: EdgeInsets.zero,
        ),
        onPressed: () => controller.addCourse(semesterIndex),
        icon: const Icon(
          Icons.add,
          color: secondary300,
        ),
        label: Text(
          'Add Course',
          style: GoogleFonts.rubik(
            fontSize: 18,
            color: secondary300,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class SemesterGPA extends ConsumerWidget {
  const SemesterGPA({
    required this.semsesterModel,
    super.key,
  });

  final SemsesterModel semsesterModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(semesterGPAProvider(semsesterModel.courses));
    final double gpa = switch (controller) {
      AsyncData(:final value) => value,
      AsyncLoading(:final value) => value ?? 0,
      AsyncError() => 0,
      final v => throw StateError('what is $v'),
    };
    return SizedBox(
      width: 150,
      height: 40,
      child: Center(
        child: Text(
          'GPA : $gpa',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(fontSize: 20, color: secondary300),
        ),
      ),
    );
  }
}

typedef RemovedItemBuilder<T> = Widget Function(
  T item,
  BuildContext context,
  Animation<double> animation,
);

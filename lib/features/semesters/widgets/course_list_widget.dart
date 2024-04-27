import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/features/home/controllers/gpa_provider.dart';
import 'package:gpa_calculator/features/semesters/controller/semester_controller.dart';
import 'package:gpa_calculator/features/semesters/widgets/course_widget.dart';
import 'package:gpa_calculator/models/course_model.dart';
import 'package:gpa_calculator/models/semester_model.dart';

class CourseList extends ConsumerWidget {
  CourseList({
    super.key,
    required this.semesterIndex,
  });

  final int semesterIndex;

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final semesterModel =
        ref.watch(semesterControllerProvider).value![semesterIndex];
    return Column(
      children: [
        AnimatedList(
          key: listKey,
          initialItemCount: semesterModel.courses.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index, animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1, 0),
                end: const Offset(0, 0),
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.ease,
                ),
              ),
              child: CourseWidget(
                semesterIndex: semesterIndex,
                courseIndex: index,
              ),
            );
          },
        ),
        // DummyCourseWidget(courseName: 'Anatomy', credits: 2.4, grade: "A+"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AddCourseButton(
              listKey: listKey,
              semsesterModel: semesterModel,
              semesterIndex: semesterIndex,
            ),
            SemesterGPA(
              semesterIndex: semesterIndex,
            ),
          ],
        ),
      ],
    );
  }
}

class AddCourseButton extends ConsumerWidget {
  const AddCourseButton({
    super.key,
    required this.listKey,
    required this.semsesterModel,
    required this.semesterIndex,
  });

  final GlobalKey<AnimatedListState> listKey;
  final SemsesterModel semsesterModel;
  final int semesterIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(semesterControllerProvider.notifier);
    return FilledButton(
      style: FilledButton.styleFrom(
        // minimumSize: Size(100, 35),
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(horizontal: 12),
      ),
      onPressed: () {
        listKey.currentState!.insertItem(semsesterModel.courses.length,
            duration: const Duration(milliseconds: 600));
        controller.addCourse(semesterIndex);
      },
      child: Row(
        children: [
          Icon(Icons.add),
          Text('Add Course'),
        ],
      ),
    );
  }
}

class SemesterGPA extends ConsumerWidget {
  const SemesterGPA({
    required this.semesterIndex,
    this.passedCourseList,
    super.key,
  });

  final int semesterIndex;
  final List<CourseModel>? passedCourseList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseList = passedCourseList ??
        ref.watch(semesterControllerProvider).value![semesterIndex].courses;
    final gpaProvider = ref.watch(semesterGPAProvider(courseList));
    final double gpa = switch (gpaProvider) {
      AsyncData(:final value) => value,
      AsyncLoading(:final value) => value ?? 0,
      AsyncError() => 0,
      final v => throw StateError('what is $v'),
    };
    return SizedBox(
      width: 150,
      height: 40,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'GPA : ',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    // color: secondary,
                  ),
            ),
            Text(
              '$gpa',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

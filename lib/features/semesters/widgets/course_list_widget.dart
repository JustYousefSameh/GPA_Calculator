import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/core/utils.dart';
import 'package:gpa_calculator/features/home/controllers/gpa_provider.dart';
import 'package:gpa_calculator/features/semesters/controller/semester_controller.dart';
import 'package:gpa_calculator/features/semesters/widgets/course_widget.dart';
import 'package:gpa_calculator/models/course_model.dart';

class CourseList extends ConsumerWidget {
  CourseList({
    super.key,
    required this.semesterIndex,
  });

  final int semesterIndex;

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesCount = ref.watch(semesterControllerProvider.select((value) {
      // in case a semester is deleted the next rebuild would throw a range error
      if (semesterIndex >= value.value!.length) {
        return null;
      }
      return value.value![semesterIndex].courses.length;
    }));

    return Column(
      children: [
        AnimatedList(
          key: listKey,
          initialItemCount: coursesCount ?? 0,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index, animation) {
            return SmoothSlideSize(
              animation: animation,
              child: CourseWidget(
                key: UniqueKey(),
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
              couresesCount: coursesCount ?? 0,
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
    required this.couresesCount,
    required this.semesterIndex,
  });

  final GlobalKey<AnimatedListState> listKey;
  final int couresesCount;
  final int semesterIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(semesterControllerProvider.notifier);
    return FilledButton.icon(
      label: Text('Add Course'),
      icon: Icon(Icons.add),
      onPressed: () {
        listKey.currentState!.insertItem(couresesCount,
            duration: const Duration(milliseconds: 600));
        controller.addCourse(semesterIndex);
      },
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
    // final courseList = passedCourseList ??
    //     ref.watch(semesterControllerProvider).value![semesterIndex].courses;
    final gpaProvider = ref.watch(semesterGPAProvider(semesterIndex));
    final double gpa = switch (gpaProvider) {
      AsyncData(:final value) => value,
      AsyncLoading(:final value) => value ?? 0,
      AsyncError() => throw StateError("Can't calculate GPA"),
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

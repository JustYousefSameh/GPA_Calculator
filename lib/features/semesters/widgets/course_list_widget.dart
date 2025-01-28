import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/core/utils.dart';
import 'package:gpa_calculator/features/home/controllers/gpa_provider.dart';
import 'package:gpa_calculator/features/semesters/controller/semester_controller.dart';
import 'package:gpa_calculator/features/semesters/widgets/course_widget.dart';
import 'package:gpa_calculator/models/course_model.dart';

class CourseList extends ConsumerStatefulWidget {
  const CourseList({
    super.key,
    required this.semesterIndex,
  });

  final int semesterIndex;

  @override
  ConsumerState<CourseList> createState() => _CourseListState();
}

class _CourseListState extends ConsumerState<CourseList> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    final semesters = ref.read(semesterControllerProvider).requireValue;
    final courses = semesters[widget.semesterIndex].courses;

    return Column(
      children: [
        AnimatedList(
          key: listKey,
          initialItemCount: courses.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index, animation) {
            final id = ref
                .read(semesterControllerProvider)
                .requireValue[widget.semesterIndex]
                .courses[index]
                .id;
            return SmoothSlideSize(
              animation: animation,
              child: CourseWidget(
                key: ValueKey(id),
                semesterIndex: widget.semesterIndex,
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
              semesterIndex: widget.semesterIndex,
            ),
            SemesterGPA(
              semesterIndex: widget.semesterIndex,
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
    required this.semesterIndex,
  });

  final GlobalKey<AnimatedListState> listKey;
  final int semesterIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesCount = ref
        .watch(semesterControllerProvider)
        .requireValue[semesterIndex]
        .courses
        .length;

    final controller = ref.read(semesterControllerProvider.notifier);
    return FilledButton.icon(
      label: const Text('Add Course'),
      icon: const Icon(Icons.add),
      onPressed: () {
        listKey.currentState!.insertItem(coursesCount,
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
    final gpaProvider = ref.watch(semesterGPAProvider(semesterIndex));

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
              '$gpaProvider',
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

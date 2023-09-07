import 'package:animated_stream_list_nullsafety/animated_stream_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpa_calculator/core/theme.dart';
import 'package:gpa_calculator/features/semesters/widgets/semester_widgets.dart';
import 'package:gpa_calculator/features/semesters/controller/courses_controller.dart';
import 'package:gpa_calculator/models/semester_model.dart';

class CourseList extends ConsumerWidget {
  final List<CourseModel>? listOfCourses;
  final String semesterId;
  const CourseList({super.key, this.listOfCourses, required this.semesterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(courseControllerProvider(semesterId));
    // ignore: deprecated_member_use
    final stream = ref.read(coursesStreamProvider(semesterId).stream);

    return Column(
      children: [
        AnimatedStreamList(
          initialList: listOfCourses,
          scrollPhysics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          streamList: stream,
          itemBuilder: _buildItem,
          itemRemovedBuilder: _buildRemovedItem,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SemesterGPA(
              semesterId: semesterId,
            ),
            addCourseButton(controller),
          ],
        ),
      ],
    );
  }

  SizedBox addCourseButton(CourseController controller) {
    return SizedBox(
      width: 150,
      height: 40,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(width: 0.7),
          shape: const StadiumBorder(
            side: BorderSide.none,
          ),
          padding: const EdgeInsets.all(0),
        ),
        onPressed: () {
          final couseModel = CourseModel.empty();
          controller.addCourse(semesterId, couseModel);
        },
        icon: const Icon(
          Icons.add,
          color: secondary300,
        ),
        label: Text(
          "Add Course",
          style: GoogleFonts.rubik(
              fontSize: 18, color: secondary300, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Used to build list items that haven't been removed.
  Widget _buildItem(CourseModel courseModel, int index, BuildContext context,
      Animation<double> animation) {
    return CourseWidget(
      index: index,
      courseModel: courseModel,
      semesterId: semesterId,
      animation: animation,
    );
  }

  Widget _buildRemovedItem(CourseModel item, int index, BuildContext context,
      Animation<double> animation) {
    return CourseWidget(
      courseModel: item,
      semesterId: semesterId,
      index: 0,
      animation: animation,
    );
  }
}

class SemesterGPA extends ConsumerWidget {
  const SemesterGPA({
    super.key,
    required this.semesterId,
  });

  final String semesterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(courseControllerProvider(semesterId));

    return SizedBox(
      width: 150,
      height: 40,
      child: Center(
        child: Text(
          "GPA : ${controller.getSemesterGPA()}",
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
    T item, BuildContext context, Animation<double> animation);

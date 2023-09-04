import 'package:animated_stream_list_nullsafety/animated_stream_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpa_calculator/Themes/theme.dart';
import 'package:gpa_calculator/core/common/semester_widgets.dart';
import 'package:gpa_calculator/features/database/courses_controller.dart';
import 'package:gpa_calculator/models/semester_model.dart';

class CourseList extends ConsumerStatefulWidget {
  final List<CourseModel>? listOfCourses;
  final String semesterId;
  const CourseList({super.key, this.listOfCourses, required this.semesterId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CourseListState();
}

class _CourseListState extends ConsumerState<CourseList> {
// The next item inserted when the user presses the '+' button.

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(courseControllerProvider(widget.semesterId));
    final stream = ref.read(coursesStreamProvider(widget.semesterId).stream);

    return Column(
      children: [
        AnimatedStreamList(
          scrollPhysics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          streamList: stream,
          itemBuilder: _buildItem,
          itemRemovedBuilder: _buildRemovedItem,
        ),
        // AnimatedList(
        //   shrinkWrap: true,
        //   initialItemCount: widget.listOfCourses.length,
        //   key: _listKey,
        //   itemBuilder: _buildItem,
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SemesterGPA(
              semesterId: widget.semesterId,
            ),
            SizedBox(
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
                  controller.addCourse(widget.semesterId, couseModel);
                },
                icon: const Icon(
                  Icons.add,
                  color: secondary300,
                ),
                label: Text(
                  "Add Course",
                  style: GoogleFonts.rubik(
                      fontSize: 18,
                      color: secondary300,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Used to build list items that haven't been removed.
  Widget _buildItem(CourseModel courseModel, int index, BuildContext context,
      Animation<double> animation) {
    return CourseWidget(
      index: index,
      courseModel: courseModel,
      semesterId: widget.semesterId,
      animation: animation,
    );
  }

  Widget _buildRemovedItem(CourseModel item, int index, BuildContext context,
      Animation<double> animation) {
    return CourseWidget(
      courseModel: item,
      semesterId: widget.semesterId,
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gpa_calculator/core/theme.dart';
import 'package:gpa_calculator/features/semesters/controller/semsters_controller.dart';
import 'package:gpa_calculator/features/semesters/widgets/drop_down_menu.dart';
import 'package:gpa_calculator/models/course_model.dart';
import 'package:gpa_calculator/models/semester_model.dart';

class CourseWidget extends ConsumerWidget {
  CourseWidget({
    required this.semsesterModel,
    required this.semesterIndex,
    required this.courseIndex,
    super.key,
    this.animation,
  })  : semesterId = semsesterModel.id,
        courseModel = semsesterModel.courses[courseIndex];

  final int semesterIndex;
  final int courseIndex;
  final SemsesterModel semsesterModel;
  final CourseModel courseModel;
  final String semesterId;
  final Animation<double>? animation;

  final nameController = TextEditingController();
  final creditController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(semesterControllerProvider.notifier);

    nameController
      ..text = courseModel.courseName
      ..selection = TextSelection(
        baseOffset: nameController.text.length,
        extentOffset: nameController.text.length,
      );
    creditController
      ..text = courseModel.credits.toString() == '0.0'
          ? ''
          : courseModel.credits.toString()
      ..selection = TextSelection(
        baseOffset: creditController.text.length,
        extentOffset: creditController.text.length,
      );

    Future<void> updateCourseModel({String? grade}) async {
      controller.updateCourse(
        semesterIndex,
        courseIndex,
        courseModel.copyWith(
          courseName: nameController.text,
          credits: creditController.text.isEmpty
              ? 0.0
              : double.parse(creditController.text),
          grade: grade,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.25,
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              padding: EdgeInsets.zero,
              onPressed: (_) =>
                  controller.deleteCourse(semesterIndex, courseIndex),
              foregroundColor: Colors.black,
              icon: Icons.delete,
              label: 'Delete',
            )
          ],
        ),
        child: Builder(
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: TextFormField(
                        controller: nameController,
                        onEditingComplete: () async =>
                            await updateCourseModel(),
                        onTapOutside: (_) async => await updateCourseModel(),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: GPADropdown(
                        updateGrade: (String grade) async =>
                            await updateCourseModel(grade: grade),
                        selectedValue: courseModel.grade,
                        id: courseModel.id,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.top,
                        controller: creditController,
                        keyboardType: TextInputType.number,
                        onEditingComplete: () async =>
                            await updateCourseModel(),
                        onTapOutside: (_) async => await updateCourseModel(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        final slidableController = Slidable.of(context)!;
                        slidableController.actionPaneType.value ==
                                ActionPaneType.none
                            ? slidableController.openEndActionPane()
                            : slidableController.close();
                      },
                      child: const Icon(
                        Icons.more_vert_outlined,
                        color: primary300,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

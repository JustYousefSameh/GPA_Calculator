import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/core/constants/constants.dart';
import 'package:gpa_calculator/core/utils.dart';
import 'package:gpa_calculator/features/semesters/controller/semester_controller.dart';
import 'package:gpa_calculator/features/semesters/widgets/drop_down_menu.dart';
import 'package:gpa_calculator/features/semesters/widgets/dummy_widgets.dart';

class CourseWidget extends ConsumerStatefulWidget {
  const CourseWidget({
    required this.semesterIndex,
    required this.courseIndex,
    super.key,
  });

  final int semesterIndex;
  final int courseIndex;

  @override
  ConsumerState<CourseWidget> createState() => _CourseWidgetState();
}

class _CourseWidgetState extends ConsumerState<CourseWidget> {
  final nameController = TextEditingController();
  final creditController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    creditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(semesterControllerProvider.notifier);

    final courseModel = ref
        .watch(semesterControllerProvider)
        .value![widget.semesterIndex]
        .courses[widget.courseIndex];

    nameController
      ..text = courseModel.courseName
      ..selection = TextSelection(
        baseOffset: nameController.text.length,
        extentOffset: nameController.text.length,
      );

    creditController
      ..text = courseModel.credits.toString() == '0.0'
          ? ''
          : courseModel.credits.toString().replaceAll(Constants.regex, '')
      ..selection = TextSelection(
        baseOffset: creditController.text.length,
        extentOffset: creditController.text.length,
      );

    Future<void> updateCourseModel({String? grade}) async {
      controller.updateCourse(
        widget.semesterIndex,
        widget.courseIndex,
        courseModel.copyWith(
          courseName: nameController.text,
          credits: creditController.text.isEmpty
              ? 0.0
              : double.parse(creditController.text),
          grade: grade,
        ),
      );
    }

    void deleteCourse() {
      controller.deleteCourse(widget.semesterIndex, widget.courseIndex);
      AnimatedList.of(context).removeItem(
        widget.courseIndex,
        (context, animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1.2, 0),
              end: const Offset(0, 0),
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: const Interval(0.5, 1, curve: Curves.ease),
              ),
            ),
            child: SizeTransition(
              sizeFactor: Tween<double>(
                begin: 0,
                end: 1,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: const Interval(0, 0.5, curve: Curves.ease),
                ),
              ),
              child: DummyCourseWidget(
                courseName: courseModel.courseName,
                grade: courseModel.grade,
                credits: courseModel.credits,
              ),
            ),
          );
        },
        duration: const Duration(milliseconds: 700),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: TextField(
                controller: nameController,
                onChanged: (_) => updateCourseModel(),
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: SizedBox(
                height: 48,
                child: GPADropdown(
                  updateGrade: (String grade) async =>
                      await updateCourseModel(grade: grade),
                  selectedValue: courseModel.grade,
                  id: courseModel.id,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: TextField(
                controller: creditController,
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(5),
                  FilteringTextInputFormatter.allow(RegExp(r'[\d\.]')),
                  SinglePeriodEnforcer()
                  // SinglePeriodEnforcer(),
                ],
                keyboardType: TextInputType.number,
                onChanged: (newValue) {
                  if (newValue.isEmpty) {
                    updateCourseModel();
                    return;
                  }
                  final newValueAfterregex = double.parse(newValue)
                      .toString()
                      .replaceAll(Constants.regex, '');

                  final value = courseModel.credits
                      .toString()
                      .replaceAll(Constants.regex, '');

                  if (newValueAfterregex != value &&
                      newValue.substring(newValue.length - 1) != '.') {
                    updateCourseModel();
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: GestureDetector(
                onTap: () => deleteCourse(),
                child: const Icon(
                  Icons.close,
                  color: Color.fromARGB(255, 143, 143, 143),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

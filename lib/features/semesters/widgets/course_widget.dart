import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/core/utils.dart';
import 'package:gpa_calculator/features/semesters/controller/semester_controller.dart';
import 'package:gpa_calculator/features/semesters/widgets/drop_down_menu.dart';
import 'package:gpa_calculator/features/semesters/widgets/dummy_widgets.dart';
import 'package:gpa_calculator/models/course_model.dart';

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

  late final controller = ref.read(semesterControllerProvider.notifier);

  late CourseModel courseModel;

  @override
  void dispose() {
    nameController.dispose();
    creditController.dispose();
    super.dispose();
  }

  int? creditCursorPosition;
  int? nameCursorPosition;

  String? lastCreditText;

  Future<void> updateCourseModel({String? grade}) async {
    lastCreditText = creditController.text;
    //Cache the cursor posotions
    nameCursorPosition = nameController.selection.baseOffset;
    creditCursorPosition = creditController.selection.baseOffset;

    controller.updateCourse(
      widget.semesterIndex,
      widget.courseIndex,
      courseModel.copyWith(
        courseName: nameController.text,
        credits: creditController.text.isEmpty
            ? Wrapped.value(null)
            : Wrapped.value(double.parse(creditController.text)),
        grade: grade,
      ),
    );
  }

  void deleteCourse() {
    AnimatedList.of(context).removeItem(
      widget.courseIndex,
      (context, animation) {
        return SmoothSlideSize(
            animation: animation,
            child: DummyCourseWidget(
              courseName: courseModel.courseName,
              grade: courseModel.grade,
              credits: courseModel.credits,
            ));

        // SlideTransition(
        //   position: Tween<Offset>(
        //     begin: const Offset(-1.2, 0),
        //     end: const Offset(0, 0),
        //   ).animate(
        //     CurvedAnimation(
        //       parent: animation,
        //       curve: const Interval(0.5, 1, curve: Curves.ease),
        //     ),
        //   ),
        //   child: SizeTransition(
        //     sizeFactor: Tween<double>(
        //       begin: 0,
        //       end: 1,
        //     ).animate(
        //       CurvedAnimation(
        //         parent: animation,
        //         curve: const Interval(0, 0.5, curve: Curves.ease),
        //       ),
        //     ),
        //     child:,
        //   ),
        // );
      },
      duration: const Duration(milliseconds: 700),
    );

    controller.deleteCourse(widget.semesterIndex, widget.courseIndex);
  }

  @override
  Widget build(BuildContext context) {
    courseModel = ref.watch(semesterControllerProvider.select((value) =>
        value.value![widget.semesterIndex].courses[widget.courseIndex]));

    nameController.text = courseModel.courseName;

    if (nameCursorPosition != null) {
      nameCursorPosition = nameCursorPosition! > nameController.text.length
          ? nameController.text.length
          : nameCursorPosition;
      nameController.selection = TextSelection.fromPosition(
        TextPosition(offset: nameCursorPosition ?? nameController.text.length),
      );
    }

    creditController.text = lastCreditText ??
        (courseModel.credits == null ? '' : courseModel.credits.toString());

    if (creditCursorPosition != null) {
      creditCursorPosition =
          creditCursorPosition! > creditController.text.length
              ? creditController.text.length
              : creditCursorPosition;

      creditController.selection = TextSelection.fromPosition(
        TextPosition(
            offset: creditCursorPosition ?? creditController.text.length),
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
                ],
                keyboardType: TextInputType.number,
                onChanged: (newValue) {
                  updateCourseModel();
                  return;
                  // if (newValue.isEmpty) {
                  //   updateCourseModel();
                  //   return;
                  // }
                  // final newValueAfterregex = double.parse(newValue)
                  //     .toString()
                  //     .replaceAll(Constants.regex, '');

                  // final value = courseModel.credits
                  //     .toString()
                  //     .replaceAll(Constants.regex, '');

                  // if (newValueAfterregex != value &&
                  //     newValue.substring(newValue.length - 1) != '.') {
                  //   updateCourseModel();
                  // }
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

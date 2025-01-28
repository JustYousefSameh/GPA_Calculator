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

  late CourseModel? courseModel;

  @override
  void didChangeDependencies() {
    courseModel = ref
        .read(semesterControllerProvider)
        .value![widget.semesterIndex]
        .courses[widget.courseIndex];
    nameController.text = courseModel!.courseName;
    creditController.text = lastCreditText ??
        (courseModel!.credits == null ? '' : courseModel!.credits.toString());
    super.didChangeDependencies();
  }

  @override
  void initState() {
    courseModel = ref
        .read(semesterControllerProvider)
        .value![widget.semesterIndex]
        .courses[widget.courseIndex];
    nameController.text = courseModel!.courseName;
    creditController.text = lastCreditText ??
        (courseModel!.credits == null ? '' : courseModel!.credits.toString());
    super.initState();
  }

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
    final newCourseModel = ref
        .read(semesterControllerProvider)
        .value![widget.semesterIndex]
        .courses[widget.courseIndex];

    controller.updateCourse(
      widget.semesterIndex,
      widget.courseIndex,
      newCourseModel.copyWith(
        courseName: nameController.text,
        credits: creditController.text.isEmpty
            ? const Wrapped.value(null)
            : Wrapped.value(double.parse(creditController.text)),
        grade: grade,
      ),
    );
  }

  void deleteCourse() {
    final newCourseModel = ref
        .read(semesterControllerProvider)
        .value![widget.semesterIndex]
        .courses[widget.courseIndex];

    AnimatedList.of(context).removeItem(
      widget.courseIndex,
      (context, animation) {
        return SmoothSlideSize(
          animation: animation,
          child: DummyCourseWidget(
            courseName: newCourseModel.courseName,
            grade: newCourseModel.grade,
            credits: newCourseModel.credits,
          ),
        );
      },
      duration: const Duration(milliseconds: 700),
    );
    controller.deleteCourse(widget.semesterIndex, widget.courseIndex);
  }

  @override
  Widget build(BuildContext context) {
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
                  updateGrade: (String grade) =>
                      updateCourseModel(grade: grade),
                  selectedValue: courseModel!.grade,
                  id: courseModel!.id,
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
                onChanged: (newValue) => updateCourseModel(),
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

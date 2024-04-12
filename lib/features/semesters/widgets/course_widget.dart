import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/core/constants/constants.dart';
import 'package:gpa_calculator/features/semesters/controller/semester_controller.dart';
import 'package:gpa_calculator/features/semesters/widgets/drop_down_menu.dart';

class CourseWidget extends ConsumerStatefulWidget {
  CourseWidget({
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
        (context, animation) => DummyCourseWidget(
          courseName: courseModel.courseName,
          grade: courseModel.grade,
          credits: courseModel.credits,
        ),
        duration: Duration(milliseconds: 700),
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
                decoration: InputDecoration(
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
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                inputFormatters: [LengthLimitingTextInputFormatter(5)],
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

class DummyCourseWidget extends StatefulWidget {
  const DummyCourseWidget({
    super.key,
    required this.courseName,
    required this.credits,
    required this.grade,
  });

  final String courseName;
  final double credits;
  final String grade;

  @override
  State<DummyCourseWidget> createState() => _DummyCourseWidgetState();
}

class _DummyCourseWidgetState extends State<DummyCourseWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  late AnimationController _sizeController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 200));

  @override
  void initState() {
    super.initState();
    _slideController.forward().whenComplete(() => _sizeController.forward());
  }

  @override
  Widget build(BuildContext context) {
    final creditsString = widget.credits.toString() == '0.0'
        ? ''
        : widget.credits.toString().replaceAll(Constants.regex, '');
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0),
        end: const Offset(-1.1, 0),
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: Curves.ease,
      )),
      child: SizeTransition(
        sizeFactor: Tween<double>(begin: 1, end: 0).animate(
          CurvedAnimation(
            parent: _sizeController,
            curve: Curves.ease,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).inputDecorationTheme.fillColor,
                    ),
                    child: _textWidget(text: widget.courseName),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).inputDecorationTheme.fillColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _textWidget(text: widget.grade),
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(
                            Icons.arrow_drop_down,
                            color: Theme.of(context)
                                .dropdownMenuTheme
                                .inputDecorationTheme!
                                .iconColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).inputDecorationTheme.fillColor,
                    ),
                    child: _textWidget(text: creditsString),
                  ),
                ),
              ),
              const Expanded(
                child: Icon(
                  Icons.close,
                  color: Color.fromARGB(255, 143, 143, 143),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _textWidget extends StatelessWidget {
  const _textWidget({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}

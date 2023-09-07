import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gpa_calculator/features/semesters/widgets/animated_courseslist.dart';
import 'package:gpa_calculator/features/semesters/widgets/drop_down_menu.dart';
import 'package:gpa_calculator/core/common/loader.dart';
import 'package:gpa_calculator/features/semesters/controller/courses_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/models/semester_model.dart';
import '../../../core/theme.dart';
import '../controller/semsters_controller.dart';

class SemesterWidget extends ConsumerWidget {
  const SemesterWidget({
    super.key,
    required this.index,
    required this.semsesterModel,
  });

  final int index;
  final SemsesterModel semsesterModel;

  void deleteSemester(WidgetRef ref, String id) {
    ref.read(semesterControllerProvider).deleteSemester(id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(coursesFutureProvider(semsesterModel.id)).when(
          loading: () => const Loader(),
          error: (error, stackTrace) => Text(error.toString()),
          data: (data) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Semester ${index + 1}",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        //delete semester button
                        GestureDetector(
                          onTap: () => deleteSemester(ref, semsesterModel.id),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            width: 28,
                            child: const Icon(
                              Icons.delete,
                              size: 26,
                              color: secondary300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Labels(),
                  const SizedBox(height: 10),
                  //courses builder
                  CourseList(
                    listOfCourses: data,
                    semesterId: semsesterModel.id,
                  ),
                ],
              ),
            );
          },
        );
  }
}

class CourseWidget extends ConsumerWidget {
  CourseWidget(
      {super.key,
      required this.courseModel,
      required this.semesterId,
      required this.index,
      this.animation});

  final int index;
  final CourseModel courseModel;
  final String semesterId;
  final Animation<double>? animation;
  final nameController = TextEditingController();
  final creditController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(courseControllerProvider(semesterId));

    nameController.text = courseModel.courseName;
    nameController.selection = TextSelection(
        baseOffset: nameController.text.length,
        extentOffset: nameController.text.length);
    creditController.text = courseModel.credits.toString() == '0'
        ? ''
        : courseModel.credits.toString();
    creditController.selection = TextSelection(
        baseOffset: creditController.text.length,
        extentOffset: creditController.text.length);

    updateCourseModel({String? name, String? grade, int? credits}) {
      controller.updateCourse(
        semesterId,
        courseModel.copyWith(
          courseName: name,
          grade: grade,
          credits: credits,
          id: courseModel.id,
        ),
      );
    }

    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(1.5, 0), end: Offset.zero)
          .animate(animation!),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Slidable(
          endActionPane: ActionPane(
            extentRatio: 0.25,
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (_) =>
                    controller.deleteCourse(semesterId, courseModel.id),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                icon: Icons.delete,
                label: 'Delete',
              )
            ],
          ),
          child: Builder(builder: (context) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: TextFormField(
                        textAlign: TextAlign.start,
                        controller: nameController,
                        onTapOutside: (_) => updateCourseModel(
                            name: nameController.text,
                            credits: int.tryParse(creditController.text) ?? 0),
                        decoration: const InputDecoration(),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: GPADropdown(
                        updateGrade: (String grade) =>
                            updateCourseModel(grade: grade),
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
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onTapOutside: (_) {
                          updateCourseModel(
                              name: nameController.text,
                              credits:
                                  int.tryParse(creditController.text) ?? 0);
                        },
                        decoration: const InputDecoration(),
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
          }),
        ),
      ),
    );
  }
}

class Labels extends StatelessWidget {
  const Labels({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Text("Course Name",
                  style: Theme.of(context).textTheme.labelLarge),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child:
                  Text("Grade", style: Theme.of(context).textTheme.labelLarge),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text("Credits",
                  style: Theme.of(context).textTheme.labelLarge),
            ),
          ),
          const Expanded(flex: 1, child: SizedBox())
        ],
      ),
    );
  }
}

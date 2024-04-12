import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/features/semesters/controller/semester_controller.dart';
import 'package:gpa_calculator/features/semesters/widgets/animated_courseslist.dart';
import 'package:gpa_calculator/features/semesters/widgets/course_widget.dart';
import 'package:gpa_calculator/models/semester_model.dart';

class SemesterWidget extends ConsumerWidget {
  const SemesterWidget({
    super.key,
    required this.semesterIndex,
  });

  final int semesterIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Using ref.read() instead of ref.watch() because for some reason it ruins the animations of aniamted list
    final semesterModel =
        ref.read(semesterControllerProvider).value![semesterIndex];

    void deleteSemester() {
      final semesterModelBeforeDelete =
          ref.read(semesterControllerProvider).value![semesterIndex];

      AnimatedList.of(context).removeItem(
        semesterIndex,
        (context, animation) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: const Offset(0, 0),
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.ease,
          )),
          child: DummySemesterWidget(
            semesterIndex: semesterIndex,
            semesterModel: semesterModelBeforeDelete,
          ),
        ),
      );

      ref
          .read(semesterControllerProvider.notifier)
          .deleteSemester(semesterModel.id);
    }

    ;

    //Reading the data again because the old semesterModel is probably outdated

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: Theme.of(context).colorScheme.onInverseSurface,
          ),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Semester ${semesterIndex + 1}',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Delete Semester"),
                          content: Text(
                            "Are you sure you want to delete this semester?",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context, "Cancel");
                                },
                                child: Text("Cancel")),
                            TextButton(
                                onPressed: () {
                                  deleteSemester();
                                  Navigator.pop(context, "Cancel");
                                },
                                child: Text("Delete")),
                          ],
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.delete,
                      size: 26,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Labels(),
              const SizedBox(height: 10),
              CourseList(semesterIndex: semesterIndex),
            ],
          ),
        ),
      ),
    );
  }
}

class DummySemesterWidget extends StatelessWidget {
  const DummySemesterWidget({
    super.key,
    required this.semesterIndex,
    required this.semesterModel,
  });

  final int semesterIndex;
  final SemsesterModel semesterModel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: Theme.of(context).colorScheme.onInverseSurface,
            width: 1,
          ),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Semester ${semesterIndex + 1}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Icon(
                    Icons.delete,
                    size: 26,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Labels(),
              const SizedBox(height: 10),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: semesterModel.courses
                    .map(
                      (e) => DummyCourseWidget(
                          courseName: e.courseName,
                          credits: e.credits,
                          grade: e.grade),
                    )
                    .toList(),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 125,
                      height: 35,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                        onPressed: () {},
                        icon: Icon(Icons.add),
                        label: Text('Add Course'),
                      )),
                  SemesterGPA(
                    semesterIndex: semesterIndex,
                    passedCourseList: semesterModel.courses,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Labels extends StatelessWidget {
  const Labels({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Text(
              'Course Name',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Text(
              'Grade',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              'Credits',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ),
        const Expanded(child: SizedBox())
      ],
    );
  }
}

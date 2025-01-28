import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/core/utils.dart';
import 'package:gpa_calculator/features/home/controllers/gpa_provider.dart';
import 'package:gpa_calculator/features/semesters/controller/semester_controller.dart';
import 'package:gpa_calculator/features/semesters/widgets/course_list_widget.dart';
import 'package:gpa_calculator/features/semesters/widgets/dummy_widgets.dart';

class SemesterWidget extends ConsumerWidget {
  const SemesterWidget({
    super.key,
    required this.semesterIndex,
  });

  final int semesterIndex;
  void deleteSemester(WidgetRef ref, BuildContext context) {
    final semesterModelBeforeDelete =
        ref.read(semesterControllerProvider).requireValue[semesterIndex];

    final gpa = ref.read(semesterGPAProvider(semesterIndex));

    // ignore: use_build_context_synchronously
    AnimatedList.of(context).removeItem(
      semesterIndex,
      (context, animation) => SmoothSlideSize(
        animation: animation,
        child: DummySemesterWidget(
          semesterIndex: semesterIndex,
          semesterModel: semesterModelBeforeDelete,
          gpa: gpa,
        ),
      ),
      duration: const Duration(milliseconds: 700),
    );

    ref
        .read(semesterControllerProvider.notifier)
        .deleteSemester(semesterModelBeforeDelete.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Material(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: Theme.of(context).dividerColor,
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
                      showGeneralDialog(
                        context: context,
                        transitionBuilder: (ctx, a1, a2, child) {
                          return FadeTransition(
                            opacity:
                                CurvedAnimation(parent: a1, curve: Curves.ease),
                            child: ScaleTransition(
                              scale: CurvedAnimation(
                                  parent: a1, curve: Curves.ease),
                              child: child,
                            ),
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 350),
                        pageBuilder: (newContext, a1, a2) => AlertDialog(
                          title: const Text("Delete Semester"),
                          content: Text(
                            "Are you sure you want to delete this semester?",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context, "Cancel");
                                },
                                child: const Text("Cancel")),
                            TextButton(
                              onPressed: () {
                                WidgetsBinding.instance.addPostFrameCallback(
                                  (_) {
                                    deleteSemester(ref, context);
                                  },
                                );

                                Navigator.pop(context, "Cancel");
                              },
                              child: Text(
                                "Delete",
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.error),
                              ),
                            ),
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

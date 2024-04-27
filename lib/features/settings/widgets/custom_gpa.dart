import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gpa_calculator/features/semesters/controller/gradetoscale_controller.dart';
import 'package:gpa_calculator/features/settings/widgets/grade_scale.dart';

class CustomGPA extends ConsumerWidget {
  const CustomGPA({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gradeToNumberProvider = ref.watch(gradeToScaleProvider);

    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.school_rounded),
            SizedBox(width: 5),
            Text(
              "Custom GPA",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      "Grade",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontSize: 19),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      "Credits",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontSize: 19),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      "Visibility",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontSize: 19),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              gradeToNumberProvider.when(
                loading: () => const CircularProgressIndicator(),
                error: (error, stackTrace) => const Text("got error"),
                data: (data) {
                  return ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: data
                        .mapWithIndex(
                          (e, index) => GradeScaleWidget(
                            gradeToScale: e,
                            index: index,
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

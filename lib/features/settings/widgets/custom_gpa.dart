import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gpa_calculator/core/constants/constants.dart';
import 'package:gpa_calculator/features/semesters/controller/gradetoscale_controller.dart';
import 'package:gpa_calculator/features/settings/widgets/grade_scale.dart';
import 'package:gpa_calculator/models/grade_scale_model.dart';

class CustomGPA extends ConsumerWidget {
  const CustomGPA({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Custom GPA"),
      ),
      body: PopScope(
        onPopInvokedWithResult: (_, __) {
          ref.read(gradeToScaleControllerProvider.notifier).fixLocalMap();
          ref.read(gradeToScaleControllerProvider.notifier).updateRemoteMap();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
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
                const SizedBox(height: 8),
                const GradeToScaleListView(),
                const SizedBox(height: 8),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Theme.of(context).colorScheme.onError,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Reset"),
                        content: Text(
                          "Are you sure you want to reset?",
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
                                ref
                                    .read(
                                        gradeToScaleControllerProvider.notifier)
                                    .resetLocalMap(Constants.gradeScale);
                                Navigator.pop(context, "Reset");
                              },
                              child: const Text("Reset")),
                        ],
                      ),
                    );
                  },
                  label: Text("Reset"),
                  icon: Icon(
                    Icons.refresh,
                    color: Theme.of(context).colorScheme.onError,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GradeToScaleListView extends ConsumerWidget {
  const GradeToScaleListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gradeToNumberProvider = ref.read(gradeToScaleControllerProvider);

    final List<GradeToScale>? value = switch (gradeToNumberProvider) {
      AsyncData(:final value) => value,
      // AsyncError(:final error) => throw StateError(error.toString()),
      AsyncLoading(:final value) => value,
      final v => throw StateError('what is $v'),
    };

    if (value == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (gradeToNumberProvider.hasError) {
      return Center(
        child: Text("Sorry there was an error."),
      );
    }

    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: value
          .mapWithIndex(
            (e, index) => GradeScaleWidget(
              index: index,
            ),
          )
          .toList(),
    );

    // return switch (gradeToNumberProvider) {
    //   AsyncLoading(:final value) => value != null
    //       ? ListView(
    //           physics: const NeverScrollableScrollPhysics(),
    //           shrinkWrap: true,
    //           children: value
    //               .mapWithIndex(
    //                 (e, index) => GradeScaleWidget(
    //                   gradeToScale: e,
    //                   index: index,
    //                 ),
    //               )
    //               .toList(),
    //         )
    //       : const Center(child: CircularProgressIndicator()),
    //   AsyncError() => const Text("got error"),
    //   AsyncValue(:final value) => ListView(
    //       physics: const NeverScrollableScrollPhysics(),
    //       shrinkWrap: true,
    //       children: value!
    //           .mapWithIndex(
    //             (e, index) => GradeScaleWidget(
    //               gradeToScale: e,
    //               index: index,
    //             ),
    //           )
    //           .toList(),
    //     ),
    // };
  }
}

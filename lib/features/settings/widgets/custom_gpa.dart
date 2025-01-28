import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/core/common/constants.dart';
import 'package:gpa_calculator/core/common/error_text.dart';
import 'package:gpa_calculator/core/common/loader.dart';
import 'package:gpa_calculator/core/utils.dart';
import 'package:gpa_calculator/features/semesters/controller/gradetoscale_controller.dart';
import 'package:gpa_calculator/features/settings/widgets/grade_scale.dart';

class CustomGPA extends ConsumerWidget {
  const CustomGPA({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gradeToNumberProvider = ref.watch(
        gradeToScaleControllerProvider.selectAsync((value) => value.length));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Custom GPA"),
      ),
      body: PopScope(
        onPopInvokedWithResult: (_, __) {
          ref
              .read(gradeToScaleControllerProvider.notifier)
              .updateRemoteMap()
              .then(
                (value) => value.fold(
                  (l) => showErrorSnackBar(context, l.message),
                  (r) => null,
                ),
              );
        },
        child: FutureBuilder(
            future: gradeToNumberProvider,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              }

              if (snapshot.hasError) {
                return ErrorText(error: snapshot.error.toString());
              }

              return SingleChildScrollView(
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
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data,
                        itemBuilder: (context, index) {
                          return GradeScaleWidget(
                            index: index,
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: Theme.of(context).colorScheme.error,
                          foregroundColor:
                              Theme.of(context).colorScheme.onError,
                        ),
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          showGeneralDialog(
                            context: context,
                            transitionBuilder: (ctx, a1, a2, child) {
                              return ScaleTransition(
                                scale: CurvedAnimation(
                                    parent: a1, curve: Curves.ease),
                                child: child,
                              );
                            },
                            transitionDuration:
                                const Duration(milliseconds: 350),
                            pageBuilder: (newContext, a1, a2) => AlertDialog(
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
                                          .read(gradeToScaleControllerProvider
                                              .notifier)
                                          .resetLocalMap(Constants.gradeScale);
                                      Navigator.pop(context, "Reset");
                                    },
                                    child: const Text("Reset")),
                              ],
                            ),
                          );
                        },
                        label: const Text("Reset"),
                        icon: Icon(
                          Icons.refresh,
                          color: Theme.of(context).colorScheme.onError,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}

// class GradeToScaleListView extends ConsumerWidget {
//   const GradeToScaleListView({super.key});
//
//
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final gradeToNumberProvider = ref.watch(
//         gradeToScaleControllerProvider.selectAsync((value) => value.length));
//
//         return       },
//     );
//   }
// }

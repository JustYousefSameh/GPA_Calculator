import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/core/common/constants.dart';
import 'package:gpa_calculator/core/common/error_text.dart';
import 'package:gpa_calculator/core/common/loader.dart';
import 'package:gpa_calculator/features/home/controllers/gpa_provider.dart';

class CumlativeGPA extends ConsumerWidget {
  const CumlativeGPA({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(gpaStateProvider);

    return switch (controller) {
      AsyncData(:final value) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Credits",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 18,
                        ),
                  ),
                  Text(
                    "Your GPA",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 18,
                        ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${value[1]}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 23,
                          // color: secondary,
                        ),
                  ),
                  Text(
                    '${value[0]}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 33,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      AsyncLoading(:final value) => Builder(builder: (context) {
          if (value == null) return Loader();

          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Credits",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 18,
                          ),
                    ),
                    Text(
                      "Your GPA",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 18,
                          ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${value[1]}',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 23,
                            // color: secondary,
                          ),
                    ),
                    Text(
                      '${value[0]}',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 33,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      AsyncError() => ErrorText(error: Constants.errorText),
      final v => throw StateError('what is $v'),
    };
  }
}

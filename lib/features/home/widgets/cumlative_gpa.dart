import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/features/home/controllers/gpa_provider.dart';

class CumlativeGPA extends ConsumerStatefulWidget {
  const CumlativeGPA({super.key});

  @override
  ConsumerState<CumlativeGPA> createState() => _CumlativeGPAState();
}

class _CumlativeGPAState extends ConsumerState<CumlativeGPA>
    with SingleTickerProviderStateMixin {
  late final animation = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 700));

  @override
  void initState() {
    animation.forward();
    super.initState();
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(gpaStateProvider).requireValue;

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 2),
        end: const Offset(0, 0),
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.ease,
        ),
      ),
      child: Column(
        children: [
          const Divider(height: 1),
          Padding(
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
                      '${controller[1]}',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 23,
                            // color: secondary,
                          ),
                    ),
                    Text(
                      '${controller[0]}',
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
        ],
      ),
    );

    // return switch (controller) {
    //   AsyncData(:final value) => Padding(
    //       padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    //       child: Column(
    //         children: [
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               Text(
    //                 "Total Credits",
    //                 style: Theme.of(context).textTheme.titleMedium!.copyWith(
    //                       fontSize: 18,
    //                     ),
    //               ),
    //               Text(
    //                 "Your GPA",
    //                 style: Theme.of(context).textTheme.titleMedium!.copyWith(
    //                       fontSize: 18,
    //                     ),
    //               ),
    //             ],
    //           ),
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               Text(
    //                 '${value[1]}',
    //                 style: Theme.of(context).textTheme.bodyMedium!.copyWith(
    //                       fontSize: 23,
    //                       // color: secondary,
    //                     ),
    //               ),
    //               Text(
    //                 '${value[0]}',
    //                 style: Theme.of(context).textTheme.bodyMedium!.copyWith(
    //                       fontSize: 33,
    //                       fontWeight: FontWeight.bold,
    //                       color: Theme.of(context).colorScheme.primary,
    //                     ),
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //     ),
    //   AsyncLoading(:final value) => Builder(builder: (context) {
    //       if (value == null) return SizedBox();

    //       return Padding(
    //         padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    //         child: Column(
    //           children: [
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 Text(
    //                   "Total Credits",
    //                   style: Theme.of(context).textTheme.titleMedium!.copyWith(
    //                         fontSize: 18,
    //                       ),
    //                 ),
    //                 Text(
    //                   "Your GPA",
    //                   style: Theme.of(context).textTheme.titleMedium!.copyWith(
    //                         fontSize: 18,
    //                       ),
    //                 ),
    //               ],
    //             ),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 Text(
    //                   '${value[1]}',
    //                   style: Theme.of(context).textTheme.bodyMedium!.copyWith(
    //                         fontSize: 23,
    //                         // color: secondary,
    //                       ),
    //                 ),
    //                 Text(
    //                   '${value[0]}',
    //                   style: Theme.of(context).textTheme.bodyMedium!.copyWith(
    //                         fontSize: 33,
    //                         fontWeight: FontWeight.bold,
    //                         color: Theme.of(context).colorScheme.primary,
    //                       ),
    //                 ),
    //               ],
    //             ),
    //           ],
    //         ),
    //       );
    //     }),
    //   AsyncError() => ErrorText(error: Constants.errorText),
    //   final v => throw StateError('what is $v'),
    // };
  }
}

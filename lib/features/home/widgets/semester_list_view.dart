import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gpa_calculator/features/semesters/controller/semester_controller.dart';
import 'package:gpa_calculator/features/semesters/widgets/semester_widget.dart';

class SemesterListView extends ConsumerWidget {
  const SemesterListView({
    super.key,
    required this.listKey,
    required this.scrollController,
  });

  final GlobalKey<AnimatedListState> listKey;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final semestersCount = ref.watch(semesterCounterProvider);

    Either<int?, Object> value = switch (semestersCount) {
      AsyncData(:final value) => left(value),
      AsyncLoading(:final value) => left(value),
      AsyncError(:final error) => right(error),
      final v => throw StateError('what is $v'),
    };

    print(value);

    return value.fold(
      (count) {
        if (count == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return AnimatedList(
          controller: scrollController,
          key: listKey,
          initialItemCount: count,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, index, animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1.2, 0),
                end: const Offset(0, 0),
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.ease,
                ),
              ),
              child: SemesterWidget(semesterIndex: index),
            );
          },
        );
      },
      (error) => Text(error.toString()),
    );
    // if (value == null)
    //   return Center(
    //     child: CircularProgressIndicator(),
    //   );
    // return ref.watch(semesterCounterProvider).when(
    //       data: (data) {
    //         return AnimatedList(
    //           controller: scrollController,
    //           key: listKey,
    //           initialItemCount: data,
    //           shrinkWrap: true,
    //           physics: const ClampingScrollPhysics(),
    //           itemBuilder: (context, index, animation) {
    //             return SlideTransition(
    //               position: Tween<Offset>(
    //                 begin: const Offset(-1.2, 0),
    //                 end: const Offset(0, 0),
    //               ).animate(
    //                 CurvedAnimation(
    //                   parent: animation,
    //                   curve: Curves.ease,
    //                 ),
    //               ),
    //               child: SemesterWidget(semesterIndex: index),
    //             );
    //           },
    //         );
    //       },
    //       error: (error, stack) => Text(error.toString()),
    //       loading: (data) => const Center(child: CircularProgressIndicator()),
    //     );
  }
}

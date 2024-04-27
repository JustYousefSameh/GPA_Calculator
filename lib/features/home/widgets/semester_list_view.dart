import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    return ref.watch(semesterCounterProvider).when(
          data: (data) {
            return AnimatedList(
              controller: scrollController,
              key: listKey,
              initialItemCount: data,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index, animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-1, 0),
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
          error: (error, stack) => Text(error.toString()),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
  }
}

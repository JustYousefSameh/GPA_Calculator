import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/features/home/widgets/semester_with_button.dart';
import 'package:gpa_calculator/features/semesters/controller/semester_controller.dart';

class AddSemesterButton extends ConsumerWidget {
  const AddSemesterButton({
    super.key,
    // required this.listKey,
    required this.scrollController,
  });

  // final GlobalKey<AnimatedListState> listKey;
  final ScrollController scrollController;

  void addSemester(WidgetRef ref) async {
    semesterListKey.currentState!
        .insertItem(ref.read(semesterControllerProvider).requireValue.length);

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.fastOutSlowIn,
        );
      },
    );
    ref.read(semesterControllerProvider.notifier).addSemester();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8),
      child: FloatingActionButton(
          child: const Icon(
            Icons.add,
            size: 37,
          ),
          onPressed: () => addSemester(ref)),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/features/home/widgets/semester_with_button.dart';
import 'package:gpa_calculator/features/semesters/controller/semester_controller.dart';
import 'package:gpa_calculator/features/semesters/widgets/semester_widget.dart';

class SemesterListView extends ConsumerStatefulWidget {
  const SemesterListView({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  ConsumerState<SemesterListView> createState() => _SemesterListViewState();
}

class _SemesterListViewState extends ConsumerState<SemesterListView>
    with SingleTickerProviderStateMixin {
  late var semesters = ref.read(semesterStreamProvider).requireValue;

  late final animationController = AnimationController(
    vsync: this,
    value: 1,
    duration: const Duration(milliseconds: 700),
  );

  @override
  Widget build(BuildContext context) {
    ref.listen(
      semesterStreamProvider,
      (oldValue, newValue) {
        if (oldValue == null) return;
        if (newValue.isLoading) return;
        if (!newValue.hasValue) return;

        // if the value coming from firebase is the same as the value in the local state, return
        if (listEquals(newValue.requireValue,
            ref.read(semesterControllerProvider).requireValue)) {
          return;
        }

        print("Interent dataa");
        showGeneralDialog(
          context: context,
          transitionBuilder: (ctx, a1, a2, child) {
            return ScaleTransition(
              scale: CurvedAnimation(parent: a1, curve: Curves.ease),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 350),
          pageBuilder: (newContext, a1, a2) => AlertDialog(
            title: const Text("New Data"),
            content: Text(
              "The data has been updated from another device. Overwrite the local data?",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Keep local data")),
              TextButton(
                onPressed: () {
                  ref
                      .read(semesterControllerProvider.notifier)
                      .updateSemesterFromRemote(newValue.requireValue);

                  semesters = newValue.requireValue;

                  //upading the semesterKey to cause full rebuild of the AnimatedList
                  semesterListKey = GlobalKey<AnimatedListState>();
                  setState(() {});
                  Navigator.pop(context);
                  animationController.forward(from: 0);
                },
                child: Text(
                  "Overwrite",
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ),
        );
      },
    );

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1.2, 0),
        end: const Offset(0, 0),
      ).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.ease,
        ),
      ),
      child: AnimatedList(
        controller: widget.scrollController,
        key: semesterListKey,
        initialItemCount: semesters.length,
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
            child: SemesterWidget(
              semesterIndex: index,
            ),
          );
        },
      ),
    );
  }
}

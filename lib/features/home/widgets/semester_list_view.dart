import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gpa_calculator/core/common/constants.dart';
import 'package:gpa_calculator/core/common/error_text.dart';
import 'package:gpa_calculator/core/common/loader.dart';
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

class _SemesterListViewState extends ConsumerState<SemesterListView> {
  //Loading semesters for the first time
  late final semesters = ref.read(semesterControllerProvider.future);

  @override
  Widget build(BuildContext context) {
    final semestersCount = ref.watch(semesterCounterProvider);

    // Updating the key to cause the AnimatedList to rebulid
    semesterListKey = GlobalKey<AnimatedListState>();

    Either<int?, String> value = switch (semestersCount) {
      AsyncData(:final value) => left(value),
      AsyncLoading(:final value) => left(value),
      AsyncError() => right(Constants.errorText),
      final v => throw StateError('what is $v'),
    };

    return FutureBuilder(
      future: semesters,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return value.fold(
            (count) {
              if (count == null) {
                return Loader();
              }
              return AnimatedList(
                controller: widget.scrollController,
                key: semesterListKey,
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
            (error) => ErrorText(error: error),
          );
        } else if (snapshot.hasError) {
          return ErrorText(error: Constants.errorText);
        } else {
          return Loader();
        }
      },
    );
  }
}

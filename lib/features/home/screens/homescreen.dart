import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpa_calculator/features/semesters/controller/semester_controller.dart';
import 'package:gpa_calculator/features/semesters/controller/user_doc_controller.dart';
import 'package:gpa_calculator/features/semesters/widgets/semester_widget.dart';

import '../controllers/gpa_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(userDocProvider);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/icons/GPA_NoText.png', width: 60),
            Text(
              "GPA Calculator",
              style: GoogleFonts.rubik(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => context.push("/settings"),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Column(
          children: [
            Expanded(child: SemesterWithButton()),
            const Divider(
              height: 1,
            ),
            const CumlativeGPA()
          ],
        ),
      ),
    );
  }
}

class SemesterWithButton extends StatelessWidget {
  SemesterWithButton({
    super.key,
  });

  final GlobalKey<AnimatedListState> _semesterListKey =
      GlobalKey<AnimatedListState>();

  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SemesterListView(
          listKey: _semesterListKey,
          scrollController: _controller,
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: AddSemesterButton(
            listKey: _semesterListKey,
            scrollController: _controller,
          ),
        )
      ],
    );
  }
}

class CumlativeGPA extends ConsumerWidget {
  const CumlativeGPA({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(gpaStateProvider);

    final List<double> gpaValues = switch (controller) {
      AsyncData(:final value) => value,
      AsyncError() => [0, 0],
      AsyncLoading(:final value) => value ?? [0, 0],
      final v => throw StateError('what is $v'),
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Credits Total",
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
                '${gpaValues[1]}',
                style: GoogleFonts.rubik(
                  fontSize: 23,
                  // color: secondary,
                ),
              ),
              Text(
                '${gpaValues[0]}',
                style: GoogleFonts.rubik(
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
  }
}

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
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.ease,
                  )),
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

class AddSemesterButton extends ConsumerWidget {
  const AddSemesterButton({
    super.key,
    required this.listKey,
    required this.scrollController,
  });

  final GlobalKey<AnimatedListState> listKey;
  final ScrollController scrollController;

  void addSemester(WidgetRef ref) async {
    listKey.currentState!
        .insertItem(await ref.read(semesterCounterProvider.future));

    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 1000),
        curve: Curves.fastOutSlowIn,
      );
    });
    ref.read(semesterControllerProvider.notifier).addSemester();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8),
      child: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Icon(
            Icons.add,
            size: 36,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () => addSemester(ref)),
    );
  }
}

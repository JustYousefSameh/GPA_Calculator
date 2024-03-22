import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpa_calculator/core/utils.dart';
import 'package:gpa_calculator/features/semesters/controller/semsters_controller.dart';
import 'package:gpa_calculator/features/semesters/widgets/semester_widget.dart';

import '../../../core/theme.dart';
import '../controllers/gpa_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/icons/GPA_NoText.png', width: 50),
            Text(
              "GPA Calculator",
              style: GoogleFonts.rubik(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: secondary300,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await ref
                  .read(semesterControllerProvider.notifier)
                  .updateRemoteDatabase();
              showSuccessSnackBar(context, "Data Synced");
            },
            icon: const Icon(Icons.sync),
          ),
          IconButton(
            onPressed: () => context.push("/settings"),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: const Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  SemesterListView(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: AddSemesterButton(),
                  )
                ],
              ),
            ),
            Divider(),
            CumlativeGPA()
          ],
        ),
      ),
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
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Credits Total",
                style: GoogleFonts.rubik(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              Text(
                "Your GPA",
                style: GoogleFonts.rubik(
                  fontSize: 18,
                  color: Colors.black,
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
                  color: Colors.black,
                ),
              ),
              Text(
                '${gpaValues[0]}',
                style: GoogleFonts.rubik(
                  fontSize: 33,
                  fontWeight: FontWeight.bold,
                  color: secondary300,
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
  const SemesterListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final semesters = ref.watch(semesterControllerProvider);
    return semesters.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Text(error.toString()),
      data: (semesterData) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: semesterData.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                SemesterWidget(
                  semesterIndex: index,
                  semsesterModel: semesterData[index],
                ),
                if (index != semesterData.length - 1)
                  const Divider(
                    indent: 40,
                    endIndent: 40,
                    thickness: 2,
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class AddSemesterButton extends ConsumerWidget {
  const AddSemesterButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    color: Colors.grey, //New
                    blurRadius: 5,
                    offset: Offset(0, 3))
              ],
              borderRadius: BorderRadius.circular(50),
              color: secondary300,
            ),
            child: const Icon(
              Icons.add,
              size: 33,
              color: Colors.white,
            ),
          ),
        ),
        onTap: () =>
            ref.read(semesterControllerProvider.notifier).addSemester());
  }
}

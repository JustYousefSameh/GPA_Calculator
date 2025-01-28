import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gpa_calculator/core/common/constants.dart';
import 'package:gpa_calculator/core/common/error_text.dart';
import 'package:gpa_calculator/core/common/loader.dart';
import 'package:gpa_calculator/features/home/controllers/gpa_provider.dart';
import 'package:gpa_calculator/features/semesters/controller/gradetoscale_controller.dart';
import 'package:gpa_calculator/features/semesters/controller/semester_controller.dart';
import 'package:gpa_calculator/features/semesters/controller/user_doc_controller.dart';

import '../widgets/cumlative_gpa.dart';
import '../widgets/semester_with_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "GPA Calculator",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 31,
                fontWeight: FontWeight.w500,
              ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push("/settings"),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Initilization(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          behavior: HitTestBehavior.translucent,
          child: const Column(
            children: [Expanded(child: SemesterWithButton()), CumlativeGPA()],
          ),
        ),
      ),
    );
  }
}

class Initilization extends ConsumerStatefulWidget {
  const Initilization({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<Initilization> createState() => _InitilizationState();
}

class _InitilizationState extends ConsumerState<Initilization> {
  late final AppLifecycleListener listener;
  @override
  void initState() {
    listener = AppLifecycleListener(
      onPause: () {
        ref.watch(semesterControllerProvider.notifier).updateRemoteDatabase();
        ref.watch(gradeToScaleControllerProvider.notifier).updateRemoteMap();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userDocProvider);
    final gradeScaleMap = ref.watch(gradeScaleMapProvider);
    final gpa = ref.watch(gpaStateProvider);
    final semesterStream = ref.watch(semesterStreamProvider);
    final semesterController = ref.watch(semesterControllerProvider);

    if (semesterStream.hasValue &&
        gpa.hasValue &&
        semesterController.hasValue &&
        user.hasValue &&
        gradeScaleMap.hasValue) {
      print("Render child");
      return widget.child;
    } else if (semesterStream.hasError ||
        gpa.hasError ||
        semesterController.hasError ||
        user.hasError ||
        gradeScaleMap.hasError) {
      return ErrorText(error: Constants.errorText);
    } else {
      return const Loader();
    }
  }
}

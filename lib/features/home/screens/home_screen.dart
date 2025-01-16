import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gpa_calculator/features/semesters/controller/user_doc_controller.dart';

import '../widgets/cumlative_gpa.dart';
import '../widgets/semester_with_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Caching the userDocProvider so it loads quickly in the settings page. I am not sure if this is the correct place tho
    ref.watch(userDocProvider);
    return Scaffold(
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
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Column(
          children: [
            Expanded(child: SemesterWithButton()),
            const Divider(height: 1),
            const CumlativeGPA()
          ],
        ),
      ),
    );
  }
}

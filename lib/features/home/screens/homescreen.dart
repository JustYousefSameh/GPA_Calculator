import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gpa_calculator/core/theme_provider.dart';
import 'package:gpa_calculator/features/semesters/controller/user_doc_controller.dart';

import '../widgets/cumlative_gpa.dart';
import '../widgets/semester_with_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(userDocProvider);
    final theme = ref.watch(themeControllerProvider);

    var brightness = View.of(context).platformDispatcher.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              (theme == ThemeMode.system && isDarkMode) ||
                      theme == ThemeMode.dark
                  ? 'assets/icons/GPA_LIGHT.svg'
                  : 'assets/icons/GPA_DARK.svg',
              height: 24,
            ),
            Text(
              "PA Calculator",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 31,
                    fontWeight: FontWeight.w500,
                    color: (theme == ThemeMode.system && isDarkMode) ||
                            theme == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
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

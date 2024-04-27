import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/features/theme_provider.dart';

class DarkMode extends ConsumerWidget {
  const DarkMode({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(Icons.dark_mode_rounded),
            SizedBox(width: 5),
            Text(
              "Theme",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        SizedBox(
          width: 100,
          height: 45,
          child: DropdownButtonFormField<ThemeMode>(
            borderRadius: BorderRadius.circular(10),
            value: ref.watch(themeControllerProvider),
            items: [
              DropdownMenuItem(
                child: Text('Light'),
                value: ThemeMode.light,
              ),
              DropdownMenuItem(
                child: Text('Dark'),
                value: ThemeMode.dark,
              ),
              DropdownMenuItem(
                child: Text('System'),
                value: ThemeMode.system,
              ),
            ],
            onChanged: (value) =>
                ref.read(themeControllerProvider.notifier).setTheme(value!),
            decoration: InputDecoration(contentPadding: EdgeInsets.zero),
          ),
        ),
      ],
    );
  }
}

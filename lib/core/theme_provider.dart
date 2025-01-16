import 'package:flutter/material.dart';
import 'package:gpa_calculator/main.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeController extends _$ThemeController {
  @override
  ThemeMode build() {
    final String? theme = prefs.getString('Theme');
    if (theme == null) {
      prefs.setString('Theme', 'System');
      return ThemeMode.system;
    } else {
      return switch (theme) {
        'Light' => ThemeMode.light,
        'Dark' => ThemeMode.dark,
        'System' => ThemeMode.system,
        _ => throw StateError('Unknown ThemeMode'),
      };
    }
  }

  setTheme(ThemeMode themeMode) async {
    switch (themeMode) {
      case ThemeMode.light:
        prefs.setString('Theme', 'Light');
        break;

      case ThemeMode.dark:
        prefs.setString('Theme', 'Dark');
        break;

      case ThemeMode.system:
        prefs.setString('Theme', 'System');
        break;
    }

    state = themeMode;
  }
}

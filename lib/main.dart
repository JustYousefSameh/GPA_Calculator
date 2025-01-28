import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/core/theme_provider.dart';
import 'package:gpa_calculator/firebase_options.dart';
import 'package:gpa_calculator/router_provider.dart';
import 'package:gpa_calculator/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FlutterDisplayMode.setHighRefreshRate();
  prefs = await SharedPreferences.getInstance();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeControllerProvider);
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: theme,
      debugShowCheckedModeBanner: false,
      title: 'GPA Calculator',
      routerConfig: router,
    );
  }
}

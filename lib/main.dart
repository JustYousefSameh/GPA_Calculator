import 'package:flutter/material.dart';
import 'package:gpa_calculator/core/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gpa_calculator/core/common/error_text.dart';
import 'package:gpa_calculator/core/common/loader.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:gpa_calculator/router_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return ref.watch(authStateChangeProvider).when(
        data: (data) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'GPA Calculator',
            theme: customTheme,
            routerConfig: router,
          );
        },
        error: ((error, stackTrace) => ErrorText(error: error.toString())),
        loading: (() => const Loader()));
  }
}

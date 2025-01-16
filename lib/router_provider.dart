import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:gpa_calculator/features/auth/screens/forgot_screen.dart';
import 'package:gpa_calculator/features/auth/screens/signin_screen.dart';
import 'package:gpa_calculator/features/auth/screens/signup_screen.dart';
import 'package:gpa_calculator/features/home/screens/home_screen.dart';
import 'package:gpa_calculator/features/settings/screens/about_developer_screen.dart';
import 'package:gpa_calculator/features/settings/screens/settings_screen.dart';
import 'package:gpa_calculator/features/settings/widgets/custom_gpa.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router_provider.g.dart';

final navigatorKey = GlobalKey<NavigatorState>();

GoRouter? _previousRouter;

@riverpod
GoRouter router(Ref ref) {
  final userModel = ref.watch(authStateChangeProvider).valueOrNull;
  return _previousRouter = GoRouter(
    debugLogDiagnostics: true,
    // navigatorKey: navigatorKey,
    initialLocation: _previousRouter?.state?.fullPath,
    redirect: (context, state) {
      if (userModel == null &&
          state.uri.toString() != '/login' &&
          state.uri.toString() != '/signup' &&
          state.uri.toString() != '/forgotpassword') {
        return '/login';
      }

      if (userModel != null) {
        if (state.uri.toString() == '/login' ||
            state.uri.toString() == '/signup' ||
            state.uri.toString() == '/forgotpassword') {
          return '/';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/forgotpassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'customGPA',
            builder: (context, state) => const CustomGPA(),
          ),
          GoRoute(
              path: 'aboutdeveloper',
              builder: (context, state) => const AboutDevloperScreen()),
        ],
      ),
    ],
  );
}

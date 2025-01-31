import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:gpa_calculator/features/auth/screens/forgot_screen.dart';
import 'package:gpa_calculator/features/auth/screens/signin_screen.dart';
import 'package:gpa_calculator/features/auth/screens/signup_screen.dart';
import 'package:gpa_calculator/features/home/screens/home_screen.dart';
import 'package:gpa_calculator/features/settings/screens/about_developer_screen.dart';
import 'package:gpa_calculator/features/settings/screens/settings_screen.dart';
import 'package:gpa_calculator/features/settings/widgets/custom_gpa.dart';
import 'package:gpa_calculator/splash_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router_notifier.g.dart';

@riverpod
class RouterNotifier extends _$RouterNotifier implements Listenable {
  VoidCallback? routerListener;
  bool? isAuth;

  @override
  void build() {
    ref.listen(
      authStateChangeProvider.select((value) => value),
      (previous, next) {
        if (next.isLoading) return;

        isAuth = next.valueOrNull != null;

        routerListener?.call();
      },
    );
  }

  String? redirect(BuildContext context, GoRouterState state) {
    if (isAuth == false &&
        state.uri.toString() != '/login' &&
        state.uri.toString() != '/signup' &&
        state.uri.toString() != '/forgotpassword') {
      return '/login';
    }

    if (isAuth == true) {
      if (state.uri.toString() == '/login' ||
          state.uri.toString() == '/signup' ||
          state.uri.toString() == '/forgotpassword') {
        return '/';
      }
    }

    return null;
  }

  /// Our application routes. Obtained through code generation
  List<GoRoute> get routes => [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
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
      ];

  /// Adds [GoRouter]'s listener as specified by its [Listenable].
  /// [GoRouteInformationProvider] uses this method on creation to handle its
  /// internal [ChangeNotifier].
  /// Check out the internal implementation of [GoRouter] and
  /// [GoRouteInformationProvider] to see this in action.
  @override
  void addListener(VoidCallback listener) {
    routerListener = listener;
  }

  /// Removes [GoRouter]'s listener as specified by its [Listenable].
  /// [GoRouteInformationProvider] uses this method when disposing,
  /// so that it removes its callback when destroyed.
  /// Check out the internal implementation of [GoRouter] and
  /// [GoRouteInformationProvider] to see this in action.
  @override
  void removeListener(VoidCallback listener) {
    routerListener = null;
  }
}

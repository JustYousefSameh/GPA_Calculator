import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:gpa_calculator/features/auth/screens/loginscreen.dart';
import 'package:gpa_calculator/features/auth/screens/signupscreen.dart';
import 'package:gpa_calculator/features/home/screens/homescreen.dart';
import 'package:gpa_calculator/splash.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final routerNotifier = RouterNotifier(ref);
  return GoRouter(
    debugLogDiagnostics: true,
    refreshListenable: routerNotifier,
    initialLocation: '/',
    redirect: routerNotifier._redirect,
    routes: routerNotifier._routes,
  );
});

class RouterNotifier extends ChangeNotifier {
  RouterNotifier(this._ref) {
    _ref.listen(
      userProvider,
      (_, __) {
        notifyListeners();
      },
    );
  }
  final Ref _ref;

  FutureOr<String?> _redirect(BuildContext context, GoRouterState state) {
    final userModel = _ref.read(userProvider);

    if (userModel == null &&
        state.uri.toString() != '/login' &&
        state.uri.toString() != '/signup') {
      return '/login';
    }

    if (userModel != null) {
      if (state.uri.toString() == '/login' ||
          state.uri.toString() == '/signup' ||
          state.uri.toString() == '/splash') {
        return '/';
      }
    }

    return null;
  }

  List<GoRoute> get _routes => [
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
          path: '/splash',
          builder: (context, state) => const SplashPage(),
        ),
      ];
}

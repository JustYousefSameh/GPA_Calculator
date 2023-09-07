import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:gpa_calculator/features/auth/screens/loginscreen.dart';
import 'package:gpa_calculator/features/auth/screens/signupscreen.dart';
import 'package:gpa_calculator/features/home/screens/homescreen.dart';
import 'package:gpa_calculator/models/user_model.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final routerNotifier = RouterNotifier(ref);
  return GoRouter(
      debugLogDiagnostics: true,
      refreshListenable: routerNotifier,
      initialLocation: '/',
      redirect: (context, state) async {
        UserModel? userModel;
        User? user;

        Future<UserModel?>? getData(Ref ref, User data) async {
          userModel = await ref
              .watch(authControllerProvider.notifier)
              .getUserData(data.uid)
              .first;

          ref.read(userProvider.notifier).update((state) => userModel);
          return userModel;
        }

        ref.read(authStateChangeProvider).whenData((value) => user = value);

        if (user == null &&
            state.uri.toString() != '/login' &&
            state.uri.toString() != '/signup') {
          return '/login';
        }

        if (user != null) {
          if (getData(ref, user!) != null &&
              (state.uri.toString() == '/login' ||
                  state.uri.toString() == '/signup')) {
            return '/';
          }
        }

        return null;
      },
      routes: routerNotifier._routes);
});

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen(
      authStateChangeProvider,
      (_, __) {
        notifyListeners();
      },
    );
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
      ];
}

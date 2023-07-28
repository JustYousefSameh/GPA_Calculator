import 'package:flutter/material.dart';
import 'package:gpa_calculator/features/auth/screens/loginscreen.dart';
import 'package:gpa_calculator/features/auth/screens/signupscreen.dart';
import 'package:gpa_calculator/features/home/screens/mainscreen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(
  routes: {
    '/': (route) => const MaterialPage(child: LoginScreen()),
    '/signup-screen': (route) => const MaterialPage(child: SignUpScreen())
  },
);

final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: AppMainScreen()),
    '/signup-screen': (route) => MaterialPage(
            child: Container(
          color: Colors.red,
        ))
  },
);

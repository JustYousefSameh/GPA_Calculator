import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/core/utils.dart';
import 'package:gpa_calculator/features/auth/repository/auth_repository.dart';
import 'package:gpa_calculator/models/user_model.dart';

final userIDProvider = StateProvider<String?>((ref) {
  final user = ref.watch(authStateChangeProvider).unwrapPrevious().valueOrNull;
  print(user?.uid);
  return user?.uid;
});

final authControllerProvider = NotifierProvider<AuthController, bool>(
  () => AuthController(),
);

final authStateChangeProvider = StreamProvider((ref) {
  return ref.watch(authRepositoryProvider).authStateChange;
});

class AuthController extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  late final AuthRepository _authRepository = ref.watch(authRepositoryProvider);
  // Stream<User?> get authStateChange => _authRepository.authStateChange;

  Future<void> signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    user.fold(
      (l) => showErrorSnackBar(context, l.message),
      (r) => {},
    );
  }

  Future<void> signUpWithEmailAndPassword(
    BuildContext context,
    String userName,
    String emailAddress,
    String password,
  ) async {
    state = true;
    final user = await _authRepository.signUpWithEmailAndPassword(
      userName,
      emailAddress,
      password,
    );
    state = false;
    user.fold(
      (l) => showErrorSnackBar(context, l.message),
      (r) => {},
    );
  }

  Future<void> singInWithEmailAndPassowrd(
    BuildContext context,
    String emailAddress,
    String password,
  ) async {
    state = true;
    final user = await _authRepository.signInWithEmailAndPassword(
      emailAddress,
      password,
    );

    state = false;
    user.fold(
      (l) => showErrorSnackBar(context, l.message),
      (r) => {},
    );
  }

  Future<void> deleteAccount() async {
    await _authRepository.deleteAccount();
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  Future<void> logout() async {
    await _authRepository.logOut();
    // ref.invalidate(semesterStreamProvider);
    // ref.invalidate(gradeToScaleStreamProvider);
    /*  ref.invalidate(authStateChangeProvider);
    ref.invalidate(gpaStateProvider);
    ref.invalidate(userIDProvider);
    ref.invalidate(userDocProvider)  */
  }

  Future<void> forgotPassword(String emailAddress) async {
    await _authRepository.forgotPassword(emailAddress);
  }
}

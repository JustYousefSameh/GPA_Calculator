import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/core/utils.dart';
import 'package:gpa_calculator/features/auth/repository/auth_repository.dart';
import 'package:gpa_calculator/models/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) {
  final user = ref.watch(authStateChangeProvider).asData?.value;
  return user == null
      ? null
      : UserModel(
          name: user.displayName!,
          uid: user.uid,
          isAuthenticated: true,
          profilePic: user.photoURL ?? '',
        );
});

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

final authStateChangeProvider = StreamProvider((ref) {
  return ref.watch(authControllerProvider.notifier).authStateChange;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.read(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);
  final AuthRepository _authRepository;
  final Ref _ref;
  Stream<User?> get authStateChange => _authRepository.authStateChange;

  Future<void> signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    user.fold(
      (l) => showSnackBar(context, l.message),
      (userModel) =>
          _ref.read(userProvider.notifier).update((state) => userModel),
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
      (l) => showSnackBar(context, l.message),
      (r) => (UserModel userModel) =>
          _ref.read(userProvider.notifier).update((state) => userModel),
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
      (l) => showSnackBar(context, l.message),
      (r) => (UserModel userModel) =>
          _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  Future<void> logout() async {
    await _authRepository.logOut();
  }
}

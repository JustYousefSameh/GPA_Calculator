// ignore_for_file: avoid_build_context_in_providers
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gpa_calculator/core/failure.dart';
import 'package:gpa_calculator/core/utils.dart';
import 'package:gpa_calculator/features/auth/repository/auth_repository.dart';
import 'package:gpa_calculator/features/semesters/controller/gradetoscale_controller.dart';
import 'package:gpa_calculator/features/semesters/controller/semester_controller.dart';
import 'package:gpa_calculator/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

@riverpod
String? userID(Ref ref) {
  final user = ref.watch(authStateChangeProvider).unwrapPrevious().valueOrNull;
  return user?.uid;
}

@riverpod
Stream<User?> authStateChange(Ref ref) {
  return ref.watch(authRepositoryProvider).authStateChange;
}

@riverpod
class AuthController extends _$AuthController {
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

  Future<String> determineAccountType() async {
    final successOrFailure = await _authRepository.signInType();
    return successOrFailure.fold((l) => '', (r) => r);
  }

  Future<Either<Failure, Unit>> deleteGoogleAccount(
      BuildContext context) async {
    final successOrFailure = await _authRepository.deleteGoogleAccount();
    return successOrFailure;
  }

  Future<Either<Failure, Unit>> deletePasswordAccount(
      BuildContext context, String email, String password) async {
    final successOrFailure =
        await _authRepository.deletePasswordAccount(email, password);
    return successOrFailure;
  }

  // Future<void> deleteAccount(
  //     BuildContext context, String email, String password) async {
  //   final successOrFailure =
  //       await _authRepository.deleteAccount(email, password);
  //   successOrFailure.fold(
  //     (l) => showErrorSnackBar(context, l.message),
  //     (r) => {},
  //   );
  // }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  Future<void> logout() async {
    state = true;
    await ref.read(semesterControllerProvider.notifier).updateRemoteDatabase();
    await ref.read(gradeToScaleControllerProvider.notifier).updateRemoteMap();
    await _authRepository.logOut();
    state = false;
  }

  Future<void> forgotPassword(String emailAddress) async {
    await _authRepository.forgotPassword(emailAddress);
  }
}

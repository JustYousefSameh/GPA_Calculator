import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:gpa_calculator/features/semesters/controller/gradetoscale_controller.dart';
import 'package:gpa_calculator/features/semesters/controller/semester_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_cycle_listener.g.dart';

@riverpod
appLifeCycleListener(Ref ref) {
  final isSignedIn =
      ref.watch(authStateChangeProvider).unwrapPrevious().valueOrNull;

  final semesterControllerNotifier =
      ref.read(semesterControllerProvider.notifier);
  final gradeToScaleControllerNotifier =
      ref.read(gradeToScaleControllerProvider.notifier);

  Future<void> updateRemoteDatabase() async {
    await semesterControllerNotifier.updateRemoteDatabase();
    await gradeToScaleControllerNotifier.updateRemoteMap();
  }

  return AppLifecycleListener(
    onDetach: () async {
      if (isSignedIn == null) return;
      await updateRemoteDatabase();
    },
    onInactive: () async {
      if (isSignedIn == null) return;
      await updateRemoteDatabase();
    },
  );
}

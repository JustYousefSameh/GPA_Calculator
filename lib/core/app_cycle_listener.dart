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
  return AppLifecycleListener(
    onDetach: () async {
      if (isSignedIn == null) return;

      await ref
          .read(semesterControllerProvider.notifier)
          .updateRemoteDatabase();
      await ref.read(gradeToScaleControllerProvider.notifier).updateRemoteMap();
    },
    onInactive: () async {
      if (isSignedIn == null) return;

      await ref
          .read(semesterControllerProvider.notifier)
          .updateRemoteDatabase();
      await ref.read(gradeToScaleControllerProvider.notifier).updateRemoteMap();
    },
  );
}

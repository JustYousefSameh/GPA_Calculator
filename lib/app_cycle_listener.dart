import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:gpa_calculator/features/semesters/controller/gradetoscale_controller.dart';
import 'package:gpa_calculator/features/semesters/controller/semester_controller.dart';

final appLifeCycleListenerProvider = Provider<AppLifecycleListener>((ref) {
  final isSignedIn = ref.watch(userIDProvider);
  return AppLifecycleListener(
    onStateChange: (value) => debugPrint(value.toString()),
    onDetach: () async {
      if (isSignedIn == null) return;
      debugPrint('App Detached Updated Database');
      await ref
          .read(semesterControllerProvider.notifier)
          .updateRemoteDatabase();
      await ref.read(gradeToScaleProvider.notifier).updateRemoteMap();
    },
    onInactive: () async {
      if (isSignedIn == null) return;

      debugPrint('App Inactive Updated Database');
      await ref
          .read(semesterControllerProvider.notifier)
          .updateRemoteDatabase();
      await ref.read(gradeToScaleProvider.notifier).updateRemoteMap();
    },
  );
});

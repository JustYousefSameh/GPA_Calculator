import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/features/semesters/controller/semsters_controller.dart';
import 'package:gpa_calculator/features/semesters/controller/user_doc_controller.dart';
import 'package:gpa_calculator/features/semesters/repository/gradetonumber_repository.dart';
import 'package:gpa_calculator/models/course_model.dart';
import 'package:gpa_calculator/models/grade_scale_model.dart';

final gradeToNumberProvider = FutureProvider<List<GradeToScale>>((ref) async {
  final data = await ref.watch(userDocProvider.future);

  return List<GradeToScale>.from(data['gradeToNumber']);
});

final gradeScaleProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final listOfGradeScales = await ref.watch(gradeToNumberProvider.future);

  Map<String, dynamic> map = {};

  listOfGradeScales.where((element) => element.isEnabled).map(
        (element) => map.addAll(element.map),
      );

  return map;
});

final gradeToNumberControllerProvider =
    AsyncNotifierProvider<GradeToNumberController, List<GradeToScale>>(
        GradeToNumberController.new);

class GradeToNumberController extends AsyncNotifier<List<GradeToScale>> {
  late final GradeToNumberRepository _gradeToNumberRepository =
      ref.watch(gradeToNumberRepositoryProvider);

  @override
  FutureOr<List<GradeToScale>> build() async {
    final userDoc = await ref.watch(userDocProvider.future);

    return List<GradeToScale>.from(
        userDoc.data()!['gradeToNumber'].map((e) => GradeToScale.fromMap(e)));
  }

  Future<void> updateRemoteMap(List<GradeToScale> list) async {
    await _gradeToNumberRepository.updateValue(state.value!);
  }

  Future<void> updateLocalMap(int index, GradeToScale gradeToScale) async {
    if (state.value![index].isEnabled == true &&
        gradeToScale.isEnabled == false) {
      await ref.read(semesterControllerProvider.notifier).update((p0) {
        final newValue = p0.map((semesterModel) {
          List<CourseModel> newList = [];
          for (var course in semesterModel.courses) {
            if (course.grade == gradeToScale.map.entries.first.key) {
              course = course.copyWith(grade: '', credits: 5);
            }
            newList.add(course);
          }
          return semesterModel.copyWith(courses: newList);
        }).toList();
        return newValue;
      });
    }

    state = state..value![index] = gradeToScale;
  }
}

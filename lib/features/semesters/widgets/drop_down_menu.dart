import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/features/semesters/controller/gradetonumber_controller.dart';

final gradeNumber = <String, double>{
  // 'A+': 4,
  'A': 4,
  'A-': 3.67,
  'B+': 3.33,
  'B': 3,
  // 'B-': 2.7,
  'C+': 2.67,
  'C': 2.33,
  'C-': 2,
  // 'D+': 1.3,
  // 'D': 1,
  'F': 0,
};

class GPADropdown extends ConsumerWidget {
  const GPADropdown({
    required this.selectedValue,
    required this.id,
    required this.updateGrade,
    super.key,
  });
  final String? selectedValue;
  final Function(String grade) updateGrade;
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gradeScale = ref.watch(gradeScaleProvider);
    return DropdownButtonFormField<String>(
        decoration: const InputDecoration(),
        value: selectedValue!.isEmpty ? null : selectedValue,
        onChanged: (newValue) {
          updateGrade(newValue!);
        },
        items: gradeScale.map(
          data: (data) =>
              data.value.entries.map<DropdownMenuItem<String>>((var value) {
            return DropdownMenuItem<String>(
              value: value.key,
              child: Text(value.key),
            );
          }).toList(),
          error: (error) => null,
          loading: (loading) => null,
        ));
  }
}

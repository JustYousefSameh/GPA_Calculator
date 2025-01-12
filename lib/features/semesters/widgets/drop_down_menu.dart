import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/features/semesters/controller/gradetoscale_controller.dart';

class GPADropdown extends ConsumerWidget {
  const GPADropdown({
    required this.selectedValue,
    required this.id,
    required this.updateGrade,
    super.key,
  });
  final String selectedValue;
  final Function(String grade) updateGrade;
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gradeScale = switch (ref.watch(gradeScaleMapProvider)) {
      AsyncData(:final value) => value,
      AsyncLoading(:final value) => value,
      AsyncError() => null,
      final v => throw StateError('what is $v'),
    };
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 12),
      ),
      //This is important to make sure the selected grades are present in the provider
      value: selectedValue.isEmpty ||
              gradeScale == null ||
              !gradeScale.containsKey(selectedValue)
          ? null
          : selectedValue,
      onChanged: (newValue) {
        updateGrade(newValue!);
      },
      items: gradeScale?.entries.map<DropdownMenuItem<String>>(
        (var value) {
          return DropdownMenuItem<String>(
            value: value.key,
            child: Text(
              value.key,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        },
      ).toList(),
    );
  }
}

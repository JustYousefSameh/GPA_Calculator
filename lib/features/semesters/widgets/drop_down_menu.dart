import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/features/semesters/controller/gradetoscale_controller.dart';

class GPADropdown extends ConsumerStatefulWidget {
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
  ConsumerState<GPADropdown> createState() => _GPADropdownState();
}

class _GPADropdownState extends ConsumerState<GPADropdown> {
  String? currentValue;
  @override
  void initState() {
    currentValue = widget.selectedValue.isEmpty ? null : widget.selectedValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final gradeScale = switch (ref.watch(gradeScaleMapProvider)) {
    //   AsyncData(:final value) => value,
    //   AsyncLoading(:final value) => value,
    //   AsyncError() => null,
    //   final v => throw StateError('what is $v'),
    // };

    final gradeScale = ref.watch(gradeScaleMapProvider).requireValue;
    // if (!gradeScale.containsKey(currentValue)) {
    //   widget.updateGrade('');
    //   currentValue = null;
    // }
    currentValue = !gradeScale.containsKey(currentValue) ? null : currentValue;
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 12),
      ),
      //This is important to make sure the selected grades are present in the provider
      value: currentValue,
      onChanged: (newValue) {
        widget.updateGrade(newValue!);
        setState(() {
          currentValue = newValue;
        });
      },
      items: gradeScale.entries.map<DropdownMenuItem<String>>(
        (value) {
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

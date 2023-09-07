import 'package:flutter/material.dart';

final gradeNumber = <String, double>{
  "A+": 4,
  "A": 4,
  "A-": 3.7,
  "B+": 3.3,
  "B": 3,
  "B-": 2.7,
  "C+": 2.3,
  "C": 2,
  "C-": 1.7,
  "D+": 1.3,
  "D": 1,
  "F": 0,
};

class GPADropdown extends StatefulWidget {
  final String selectedValue;
  final Function(String grade) updateGrade;
  final String id;
  const GPADropdown(
      {required this.selectedValue,
      super.key,
      required this.id,
      required this.updateGrade});
  @override
  GPADropdownState createState() => GPADropdownState();
}

class GPADropdownState extends State<GPADropdown> {
  @override
  void initState() {
    super.initState();
    setState(() {
      selectedGPA = widget.selectedValue;
    });
  }

  late String? selectedGPA = "A+";

  List<String> gpaValues = [
    'A+',
    'A',
    'A-',
    'B+',
    'B',
    'B-',
    'C+',
    'C',
    'C-',
    'D+',
    'D',
    'F',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(),
      value: selectedGPA,
      onChanged: (newValue) {
        setState(() {
          selectedGPA = newValue;
          widget.updateGrade(newValue!);
        });
      },
      items: gpaValues.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

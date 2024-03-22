// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:uuid/uuid.dart';

class CourseModel {
  final String courseName;
  final String grade;
  final double credits;
  final String id;

  const CourseModel({
    required this.courseName,
    required this.grade,
    required this.credits,
    required this.id,
  });

  factory CourseModel.empty() => CourseModel(
        courseName: '',
        grade: '',
        credits: 0.0,
        id: const Uuid().v1(),
      );

  CourseModel copyWith({
    String? courseName,
    String? grade,
    double? credits,
    String? id,
  }) {
    return CourseModel(
      courseName: courseName ?? this.courseName,
      grade: grade ?? this.grade,
      credits: credits ?? this.credits,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'courseName': courseName,
      'grade': grade,
      'credits': credits,
      'id': id,
    };
  }

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      courseName: map['courseName'] as String,
      grade: map['grade'] as String,
      credits: map['credits'] as double,
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CourseModel.fromJson(String source) =>
      CourseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CourseModel(courseName: $courseName, grade: $grade, credits: $credits, id: $id)';
  }

  @override
  bool operator ==(covariant CourseModel other) {
    if (identical(this, other)) return true;

    return other.courseName == courseName &&
        other.grade == grade &&
        other.credits == credits &&
        other.id == id;
  }

  @override
  int get hashCode {
    return courseName.hashCode ^
        grade.hashCode ^
        credits.hashCode ^
        id.hashCode;
  }
}

import 'dart:convert';

import 'package:uuid/uuid.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class SemsesterModel {
  final String id;

  factory SemsesterModel.empty() => SemsesterModel(
        id: const Uuid().v1(),
      );

  SemsesterModel({
    required this.id,
  });

  SemsesterModel copyWith({
    String? id,
  }) {
    return SemsesterModel(
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
    };
  }

  factory SemsesterModel.fromMap(Map<String, dynamic> map) {
    return SemsesterModel(
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SemsesterModel.fromJson(String source) =>
      SemsesterModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  @override
  bool operator ==(covariant SemsesterModel other) {
    if (identical(this, other)) return true;

    return other.id == id;
  }

  @override
  @override
  String toString() => 'SemsesterModel(id: $id)';

  @override
  int get hashCode => id.hashCode;
}

class CourseModel {
  final String courseName;
  final String grade;
  final int credits;
  final String id;

  factory CourseModel.empty() => CourseModel(
        courseName: '',
        grade: 'A+',
        credits: 0,
        id: const Uuid().v1(),
      );

  CourseModel({
    required this.courseName,
    required this.grade,
    required this.credits,
    required this.id,
  });

  CourseModel copyWith({
    String? courseName,
    String? grade,
    int? credits,
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
      credits: map['credits'] as int,
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

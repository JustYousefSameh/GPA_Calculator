import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:gpa_calculator/models/course_model.dart';
import 'package:uuid/uuid.dart';

class SemsesterModel {
  final String id;
  final List<CourseModel> courses;

  const SemsesterModel({
    required this.id,
    required this.courses,
  });

  factory SemsesterModel.empty() => SemsesterModel(
        id: const Uuid().v1(),
        courses: [
          CourseModel.empty(),
          CourseModel.empty(),
          CourseModel.empty(),
        ],
      );

  SemsesterModel copyWith({
    String? id,
    List<CourseModel>? courses,
  }) {
    return SemsesterModel(
      id: id ?? this.id,
      courses: courses ?? this.courses,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'courses': courses.map((x) => x.toMap()).toList(),
    };
  }

  factory SemsesterModel.fromMap(Map<String, dynamic> map) {
    return SemsesterModel(
      id: map['id'] as String,
      courses: List<CourseModel>.from(map['courses'].map(
        (e) => CourseModel.fromMap(e),
      )),
    );
  }

  String toJson() => json.encode(toMap());

  factory SemsesterModel.fromJson(String source) =>
      SemsesterModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant SemsesterModel other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id && listEquals(other.courses, courses);
  }

  @override
  String toString() => 'SemsesterModel(id: $id, courses: $courses)';

  @override
  int get hashCode => id.hashCode ^ courses.hashCode;
}

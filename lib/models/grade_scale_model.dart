// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class GradeToScale {
  final bool isEnabled;
  final Map<String, dynamic> map;

  const GradeToScale({
    required this.isEnabled,
    required this.map,
  });

  GradeToScale copyWith({
    bool? isEnabled,
    Map<String, dynamic>? map,
  }) {
    return GradeToScale(
      isEnabled: isEnabled ?? this.isEnabled,
      map: map ?? this.map,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isEnabled': isEnabled,
      'map': map,
    };
  }

  factory GradeToScale.fromMap(Map<String, dynamic> map) {
    return GradeToScale(
        isEnabled: map['isEnabled'] as bool,
        map: Map<String, dynamic>.from(
          (map['map'] as Map<String, dynamic>),
        ));
  }

  @override
  String toString() => 'GradeToScale(isEnabled: $isEnabled, map: $map)';

  @override
  bool operator ==(covariant GradeToScale other) {
    if (identical(this, other)) return true;

    return other.isEnabled == isEnabled && mapEquals(other.map, map);
  }

  @override
  int get hashCode => isEnabled.hashCode ^ map.hashCode;

  String toJson() => json.encode(toMap());

  factory GradeToScale.fromJson(String source) =>
      GradeToScale.fromMap(json.decode(source) as Map<String, dynamic>);
}

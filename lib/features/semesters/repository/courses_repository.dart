import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:gpa_calculator/logic/firebase_providers.dart';
import 'package:gpa_calculator/models/semester_model.dart';

final courseRepositoryProvider = Provider((ref) =>
    CourseRepository(firestore: ref.read(firestoreProvider), ref: ref));

class CourseRepository {
  final FirebaseFirestore _firestore;
  final Ref _ref;

  CourseRepository({required FirebaseFirestore firestore, required Ref ref})
      : _firestore = firestore,
        _ref = ref;

  CollectionReference get _semesters => _firestore
      .collection('users')
      .doc(_ref.read(userProvider)!.uid)
      .collection('semesters');

  addCourse(String semesterId, CourseModel courseModel) async {
    final doc =
        _semesters.doc(semesterId).collection('courses').doc(courseModel.id);

    final creationDate = <String, dynamic>{
      "timestamp": FieldValue.serverTimestamp(),
    };
    final map = courseModel.toMap();
    map.addAll(creationDate);

    doc.set(map);
  }

  deleteCourse(String semesterId, String courseId) {
    return _semesters
        .doc(semesterId)
        .collection('courses')
        .doc(courseId)
        .delete();
  }

  void updateCourse(
      String semesterId, String courseId, Map<String, dynamic> map) {
    _semesters.doc(semesterId).collection('courses').doc(courseId).update(map);
  }
}

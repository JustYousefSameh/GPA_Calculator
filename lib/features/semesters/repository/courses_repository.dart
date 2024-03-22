import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:gpa_calculator/logic/firebase_providers.dart';
import 'package:gpa_calculator/models/course_model.dart';
import 'package:gpa_calculator/models/semester_model.dart';

final courseRepositoryProvider = Provider(
  (ref) => CourseRepository(firestore: ref.read(firestoreProvider), ref: ref),
);

class CourseRepository {
  CourseRepository({required FirebaseFirestore firestore, required Ref ref})
      : _firestore = firestore,
        _ref = ref;
  final FirebaseFirestore _firestore;
  final Ref _ref;

  CollectionReference get _semesters => _firestore
      .collection('users')
      .doc(_ref.read(userProvider)!.uid)
      .collection('semesters');

  Future<void> addCourse(
      SemsesterModel semsesterModel, CourseModel courseModel) async {
    final doc = _semesters.doc(semsesterModel.id);
    semsesterModel.courses.add(courseModel);

    await doc.update(semsesterModel.toMap());
  }

  Future<void> deleteCourse(SemsesterModel semsesterModel, int index) async {
    final doc = _semesters.doc(semsesterModel.id);

    await doc.update(semsesterModel
        .copyWith(courses: semsesterModel.courses..removeAt(index))
        .toMap());
  }

  Future<void> updateCourse(
      SemsesterModel semsesterModel, CourseModel courseModel, int index) async {
    final doc = _semesters.doc(semsesterModel.id);
    semsesterModel.courses[index] = courseModel;

    await doc.update(semsesterModel.toMap());
  }
}

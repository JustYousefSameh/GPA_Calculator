import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:gpa_calculator/features/semesters/controller/courses_controller.dart';
import 'package:gpa_calculator/logic/firebase_providers.dart';
import 'package:gpa_calculator/models/semester_model.dart';

final semestersRepositoryProvider = Provider<SemesterRepository>((ref) =>
    SemesterRepository(firestore: ref.read(firestoreProvider), ref: ref));

class SemesterRepository {
  final FirebaseFirestore _firestore;
  final Ref _ref;

  SemesterRepository({required FirebaseFirestore firestore, required Ref ref})
      : _firestore = firestore,
        _ref = ref;

  CollectionReference get _semesters => _firestore
      .collection('users')
      .doc(_ref.read(userProvider)!.uid)
      .collection('semesters');

  Future<void> addSemesterUsingID(String uid) async {
    final data = SemsesterModel.empty();

    final doc = _firestore
        .collection('users')
        .doc(uid)
        .collection('semesters')
        .doc(data.id);

    final dataToAdd = <String, dynamic>{
      "timestamp": FieldValue.serverTimestamp(),
      'id': data.id
    };

    await doc.set(dataToAdd);

    _ref
        .read(courseControllerProvider(data.id))
        .addCourse(data.id, CourseModel.empty());
    _ref
        .read(courseControllerProvider(data.id))
        .addCourse(data.id, CourseModel.empty());
    _ref
        .read(courseControllerProvider(data.id))
        .addCourse(data.id, CourseModel.empty());
  }

  addSemester(SemsesterModel data) {
    final doc = _semesters.doc(data.id);

    final dataToAdd = <String, dynamic>{
      "timestamp": FieldValue.serverTimestamp(),
      'id': data.id
    };

    doc.set(dataToAdd);

    _ref
        .read(courseControllerProvider(data.id))
        .addCourse(data.id, CourseModel.empty());
    _ref
        .read(courseControllerProvider(data.id))
        .addCourse(data.id, CourseModel.empty());
    _ref
        .read(courseControllerProvider(data.id))
        .addCourse(data.id, CourseModel.empty());
  }

  deleteSemester(String id) {
    _semesters.doc(id).delete();
  }
}

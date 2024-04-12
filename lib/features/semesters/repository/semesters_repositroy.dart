import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:gpa_calculator/logic/firebase_providers.dart';
import 'package:gpa_calculator/models/semester_model.dart';

final semestersRepositoryProvider = Provider<SemesterRepository>(
  (ref) => SemesterRepository(firestore: ref.read(firestoreProvider), ref: ref),
);

class SemesterRepository {
  SemesterRepository({required FirebaseFirestore firestore, required Ref ref})
      : _firestore = firestore,
        _ref = ref;
  final FirebaseFirestore _firestore;
  final Ref _ref;

  DocumentReference get _semestersDoc => _firestore
      .collection('users')
      .doc(_ref.watch(userIDProvider))
      .collection('data')
      .doc('semesters');

  Future<void> updateAllDatabase(List<SemsesterModel> listOfSemesters) async {
    await _semestersDoc
        .update({'semesters': listOfSemesters.map((e) => e.toMap()).toList()});
  }

  Future<void> addSemesterUsingID(String uid) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('data')
        .doc('semesters')
        .set({
      'semesters': [SemsesterModel.empty().toMap()]
    });
  }
}

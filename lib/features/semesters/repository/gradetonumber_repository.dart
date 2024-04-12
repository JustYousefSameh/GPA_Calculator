import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/core/constants/constants.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:gpa_calculator/logic/firebase_providers.dart';
import 'package:gpa_calculator/models/grade_scale_model.dart';

final gradeToNumberRepositoryProvider =
    Provider<GradeToScaleRepository>((ref) => GradeToScaleRepository(
          ref: ref,
          fireStore: ref.read(firestoreProvider),
        ));

class GradeToScaleRepository {
  GradeToScaleRepository(
      {required Ref ref, required FirebaseFirestore fireStore})
      : _ref = ref,
        _firestore = fireStore;

  final Ref _ref;
  final FirebaseFirestore _firestore;

  DocumentReference get _gradeToScaleDoc => _firestore
      .collection('users')
      .doc(_ref.watch(userIDProvider))
      .collection('data')
      .doc('gradeToNumber');

  Future<void> setDefaultValue(String uid) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('data')
        .doc('gradeToNumber')
        .set({'gradeToNumber': Constants.gradeScale.map((e) => e.toMap())});
  }

  Future<void> updateValue(List<GradeToScale> list) async {
    await _gradeToScaleDoc
        .update({'gradeToNumber': list.map((e) => e.toMap())});
  }
}

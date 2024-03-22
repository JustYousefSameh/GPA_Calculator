import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:gpa_calculator/logic/firebase_providers.dart';
import 'package:gpa_calculator/models/grade_scale_model.dart';

final gradeToNumberRepositoryProvider =
    Provider<GradeToNumberRepository>((ref) => GradeToNumberRepository(
          ref: ref,
          fireStore: ref.read(firestoreProvider),
        ));

class GradeToNumberRepository {
  GradeToNumberRepository(
      {required Ref ref, required FirebaseFirestore fireStore})
      : _ref = ref,
        _firestore = fireStore;

  final Ref _ref;
  final FirebaseFirestore _firestore;

  DocumentReference get _userDoc =>
      _firestore.collection('users').doc(_ref.read(userProvider)!.uid);

  Future<void> updateValue(List<GradeToScale> list) async {
    _userDoc.update({'gradeToNumber': list.map((e) => e.toMap())});
  }
}

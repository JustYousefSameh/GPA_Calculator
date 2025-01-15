import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gpa_calculator/core/failure.dart';
import 'package:gpa_calculator/core/firebase_providers.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:gpa_calculator/models/semester_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'semesters_repositroy.g.dart';

@riverpod
SemesterRepository semestersRepository(Ref ref) {
  return SemesterRepository(
    firestore: ref.watch(firestoreProvider),
    ref: ref,
  );
}

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

  Future<Either<Failure, Unit>> updateAllDatabase(
      List<SemsesterModel> listOfSemesters) async {
    try {
      await _semestersDoc.update(
        {
          'semesters': listOfSemesters.map((e) => e.toMap()).toList(),
        },
      );
      return right(unit);
    } on FirebaseException catch (e) {
      return left(Failure(e.code));
    }
  }

  Future<Either<Failure, Unit>> addSemesterUsingID(String uid) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('data')
          .doc('semesters')
          .set({
        'semesters': [SemsesterModel.empty().toMap()]
      });
      return right(unit);
    } on FirebaseException catch (e) {
      return left(Failure(e.code));
    }
  }
}

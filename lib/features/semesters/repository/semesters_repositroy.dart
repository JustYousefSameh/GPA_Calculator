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

  CollectionReference get _semesters => _firestore
      .collection('users')
      .doc(_ref.watch(userProvider)!.uid)
      .collection('semesters');

  Future<void> updateAllDatabase(List<SemsesterModel> listOfSemesters) async {
    await _firestore
        .collection('users')
        .doc(_ref.watch(userProvider)!.uid)
        .update({'semesters': listOfSemesters.map((e) => e.toMap()).toList()});

    // await _semesters.get().then((value) async {
    //   for (var model in remoteList) {
    //     var isDeleted = listOfSemesters.indexWhere(
    //       (element) => element.id == model.id,
    //     );
    //     if (isDeleted == -1) await doc.reference.delete();
    //   }
    // });

    // for (var semester in listOfSemesters) {
    //   await _semesters.doc(semester.id).set(semester.toMap());
    // }
  }

  Future<void> addSemesterUsingID(String uid) async {
    final data = SemsesterModel.empty();

    final doc = _firestore
        .collection('users')
        .doc(uid)
        .collection('semesters')
        .doc(data.id);

    final dataToAdd = <String, dynamic>{
      'timestamp': FieldValue.serverTimestamp(),
      'id': data.id
    };

    await doc.set(dataToAdd);
  }

  Future<void> addSemester(SemsesterModel data) async {
    final doc = _semesters.doc(data.id);
    final semesterData = data.toMap()
      ..addAll({'timestamp': FieldValue.serverTimestamp()});
    await doc.set(semesterData);
  }

  Future<void> deleteSemester(String id) async {
    await _semesters.doc(id).delete();
  }
}

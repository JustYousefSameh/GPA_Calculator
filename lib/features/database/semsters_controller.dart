import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:gpa_calculator/features/database/semesters_repositroy.dart';
import 'package:gpa_calculator/logic/firebase_providers.dart';
import 'package:gpa_calculator/models/semester_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final semesterStreamProvider =
    StreamProvider<List<SemsesterModel>>((ref) async* {
  final semestersSnapshot = ref
      .read(firestoreProvider)
      .collection('users')
      .doc(ref.read(userProvider)!.uid)
      .collection('semesters')
      .orderBy('timestamp', descending: false)
      .snapshots();

  yield* semestersSnapshot.map((event) =>
      (event.docs.map((e) => SemsesterModel(id: e.data()['id'])).toList()));
});

final semesterControllerProvider = Provider((ref) => SemesterController(
    semestersRepository: ref.read(semestersRepositoryProvider)));

class SemesterController {
  final SemesterRepository _semestersRepository;

  SemesterController({required SemesterRepository semestersRepository})
      : _semestersRepository = semestersRepository;

  void addSemester() {
    _semestersRepository.addSemester(SemsesterModel.empty());
  }

  void deleteSemester(String id) {
    _semestersRepository.deleteSemester(id);
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:gpa_calculator/features/semesters/repository/semesters_repositroy.dart';
import 'package:gpa_calculator/logic/firebase_providers.dart';
import 'package:gpa_calculator/models/semester_model.dart';

final semesterStreamProvider =
    StreamProvider<List<SemsesterModel>>((ref) async* {
  final semestersSnapshot = ref
      .read(firestoreProvider)
      .collection('users')
      .doc(ref.watch(userProvider)!.uid)
      .collection('semesters')
      .orderBy('timestamp', descending: false)
      .snapshots();

  yield* semestersSnapshot.map(
    (event) => event.docs
        .map((e) => SemsesterModel(id: e.data()['id'] as String))
        .toList(),
  );
});

final semesterControllerProvider = Provider(
  (ref) => SemesterController(
    semestersRepository: ref.read(semestersRepositoryProvider),
  ),
);

class SemesterController {
  SemesterController({required SemesterRepository semestersRepository})
      : _semestersRepository = semestersRepository;
  final SemesterRepository _semestersRepository;

  void addSemester() {
    _semestersRepository.addSemester(SemsesterModel.empty());
  }

  void deleteSemester(String id) {
    _semestersRepository.deleteSemester(id);
  }
}

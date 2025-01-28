import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:gpa_calculator/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/firebase_providers.dart';

part 'user_doc_controller.g.dart';

@riverpod
Stream<UserModel?> userDoc(Ref ref) async* {
  final id = ref.watch(userIDProvider);
  yield* ref
      .watch(firestoreProvider)
      .collection('users')
      .doc(id)
      .snapshots()
      .where((event) => event.data() != null)
      .asyncMap((event) {
    return UserModel.fromMap(event.data()!);
  });
}

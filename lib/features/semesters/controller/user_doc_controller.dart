import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:gpa_calculator/models/user_model.dart';

import '../../../core/firebase_providers.dart';

final userDocProvider = StreamProvider<UserModel?>((ref) async* {
  final id = ref.watch(userIDProvider);
  if (id == null) yield null;
  yield* ref
      .read(firestoreProvider)
      .collection('users')
      .doc(id)
      .snapshots()
      .asyncMap((event) {
    if (event.data() == null) return null;
    return UserModel.fromMap(event.data()!);
  });
});

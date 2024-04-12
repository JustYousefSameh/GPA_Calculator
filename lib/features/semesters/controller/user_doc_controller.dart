import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:gpa_calculator/models/user_model.dart';

import '../../../logic/firebase_providers.dart';

final userDocProvider = StreamProvider<UserModel?>((ref) async* {
  yield* ref
      .read(firestoreProvider)
      .collection('users')
      .doc(ref.watch(userIDProvider))
      .snapshots()
      .asyncMap((event) {
    if (event.data() == null) return null;
    return UserModel.fromMap(event.data()!);
  });
});

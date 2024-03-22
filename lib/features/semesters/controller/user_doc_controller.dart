import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';

import '../../../logic/firebase_providers.dart';

final userDocProvider = FutureProvider<DocumentSnapshot<Map<String, dynamic>>>(
    (ref) async => await ref
        .read(firestoreProvider)
        .collection('users')
        .doc(ref.watch(userProvider)!.uid)
        .get());

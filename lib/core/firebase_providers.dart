import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_providers.g.dart';

@riverpod
FirebaseFirestore firestore(Ref ref) => FirebaseFirestore.instance;

@riverpod
FirebaseAuth auth(Ref ref) => FirebaseAuth.instance;

@riverpod
FirebaseStorage storage(Ref ref) => FirebaseStorage.instance;

@riverpod
GoogleSignIn googleSignIn(Ref ref) => GoogleSignIn();

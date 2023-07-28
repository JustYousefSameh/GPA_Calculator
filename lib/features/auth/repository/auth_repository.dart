import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gpa_calculator/core/failure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gpa_calculator/logic/firebase_providers.dart';
import 'package:gpa_calculator/models/user_model.dart';
import '../../../core/type_defs.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  CollectionReference get _users => _firestore.collection('users');

  Stream<User?> get authStateChange => _auth.authStateChanges();

  FutureEither<UserModel> signUpWithEmailAndPassword(
      String? userName, String emailAddress, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: emailAddress, password: password);

      UserModel userModel;

      userModel = UserModel(
          name: userName ?? 'No Name',
          uid: userCredential.user!.uid,
          isAuthenticated: true,
          profilePic: userCredential.user!.photoURL ?? '');
      await _users.doc(userCredential.user!.uid).set(userModel.toMap());

      return right(userModel);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return left(Failure(e.message!));
    }
  }

  FutureEither<UserModel> signInWithEmailAndPassword(
      String emailAddress, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: emailAddress, password: password);

      UserModel userModel = await getUserData(userCredential.user!.uid).first;
      return right(userModel);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return left(Failure('User not found'));
      } else if (e.code == 'wrong-password') {
        print('Invalid passowrd');
        return left(Failure('Invalid passowrd'));
      }
      print(e.code);
      return left(Failure(e.message!));
    }
  }

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserModel userModel;

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
            name: userCredential.user!.displayName ?? 'No Name',
            uid: userCredential.user!.uid,
            isAuthenticated: true,
            profilePic: userCredential.user!.photoURL ?? '');
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  void logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}

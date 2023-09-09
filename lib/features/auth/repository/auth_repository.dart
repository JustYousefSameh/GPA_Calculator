import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gpa_calculator/core/failure.dart';
import 'package:gpa_calculator/core/type_defs.dart';
import 'package:gpa_calculator/features/semesters/repository/semesters_repositroy.dart';
import 'package:gpa_calculator/logic/firebase_providers.dart';
import 'package:gpa_calculator/models/user_model.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
    semesterRepository: ref.read(semestersRepositoryProvider),
  ),
);

class AuthRepository {
  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
    required SemesterRepository semesterRepository,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn,
        _semesterRepository = semesterRepository;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final SemesterRepository _semesterRepository;

  CollectionReference get _users => _firestore.collection('users');

  Stream<User?> get authStateChange => _auth.authStateChanges();

  FutureEither<UserModel> signUpWithEmailAndPassword(
    String? userName,
    String emailAddress,
    String password,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      UserModel userModel;

      userModel = UserModel(
        name: userName ?? 'No Name',
        uid: userCredential.user!.uid,
        isAuthenticated: true,
        profilePic: userCredential.user!.photoURL ?? '',
      );
      await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      await _semesterRepository.addSemesterUsingID(userCredential.user!.uid);

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
    String emailAddress,
    String password,
  ) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      final userModel = await getUserData(userCredential.user!.uid).first;
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
      final googleUser = await _googleSignIn.signIn();

      final googleAuth = await googleUser?.authentication;

      if (googleAuth == null) {
        return left(Failure('Canceled by user'));
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserModel userModel;

      final userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          name: userCredential.user!.displayName ?? 'No Name',
          uid: userCredential.user!.uid,
          isAuthenticated: true,
          profilePic: userCredential.user!.photoURL ?? '',
        );
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
        await _semesterRepository.addSemesterUsingID(userCredential.user!.uid);
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
          (event) => UserModel.fromMap(event.data()! as Map<String, dynamic>),
        );
  }

  Future<void> logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}

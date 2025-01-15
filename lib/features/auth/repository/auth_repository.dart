import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gpa_calculator/core/failure.dart';
import 'package:gpa_calculator/core/firebase_providers.dart';
import 'package:gpa_calculator/features/semesters/repository/gradetonumber_repository.dart';
import 'package:gpa_calculator/features/semesters/repository/semesters_repositroy.dart';
import 'package:gpa_calculator/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(
      firestore: ref.read(firestoreProvider),
      auth: ref.read(authProvider),
      googleSignIn: ref.read(googleSignInProvider),
      semesterRepository: ref.read(semestersRepositoryProvider),
      gradeToNumberRepository: ref.read(gradeToNumberRepositoryProvider));
}

class AuthRepository {
  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
    required SemesterRepository semesterRepository,
    required GradeToScaleRepository gradeToNumberRepository,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn,
        _semesterRepository = semesterRepository,
        _gradeToNumberRepository = gradeToNumberRepository;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final GradeToScaleRepository _gradeToNumberRepository;
  final SemesterRepository _semesterRepository;

  CollectionReference get _users => _firestore.collection('users');

  Stream<User?> get authStateChange => _auth.userChanges();

  Future<void> setDefaults(String uid) async {
    await _semesterRepository.addSemesterUsingID(uid);
    await _gradeToNumberRepository.setDefaultValue(uid);
  }

  Future<Either<Failure, Unit>> signUpWithEmailAndPassword(
    String userName,
    String emailAddress,
    String password,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      await userCredential.user?.updateDisplayName(userName);
      // await _auth.userChanges().first;

      final userModel = UserModel(
        name: userName,
        emailAddress: emailAddress,
        uid: userCredential.user!.uid,
        isAuthenticated: true,
        profilePic: userCredential.user!.photoURL ?? '',
      );

      await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      await setDefaults(userCredential.user!.uid);

      return right(unit);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return left(Failure(e.message!));
    }
  }

  UserModel firebaseUserToUserModel(User user) {
    return UserModel(
        name: user.displayName ?? 'Name not set',
        emailAddress: user.email!,
        uid: user.uid,
        isAuthenticated: true,
        profilePic: user.photoURL ?? '');
  }

  Future<Either<Failure, Unit>> signInWithEmailAndPassword(
    String emailAddress,
    String password,
  ) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      return right(unit);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return left(Failure('User not found'));
      } else if (e.code == 'wrong-password') {
        print('Invalid passowrd');
        return left(Failure('Invalid passowrd'));
      }
      return left(Failure(e.message!));
    }
  }

  Future<Either<Failure, Unit>> signInWithGoogle() async {
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
      final userDoc = await _users.doc(userCredential.user!.uid).get();
      if (userCredential.additionalUserInfo!.isNewUser || !userDoc.exists) {
        userModel = UserModel(
          emailAddress: userCredential.user!.email!,
          name: userCredential.user!.displayName!,
          uid: userCredential.user!.uid,
          isAuthenticated: true,
          profilePic: userCredential.user!.photoURL ?? '',
        );
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
        await setDefaults(userCredential.user!.uid);
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(unit);
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
          (event) => UserModel.fromMap(event.data()! as Map<String, dynamic>),
        );
  }

  Future<Either<Failure, Unit>> deleteAccount() async {
    try {
      if (await _googleSignIn.isSignedIn()) await _googleSignIn.signOut();
      await _auth.currentUser?.delete();
      await _firestore.collection('users').doc(_auth.currentUser!.uid).delete();
      return right(unit);
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.message!));
    }
  }

  Future<void> forgotPassword(String emailAddress) async {
    await _auth.sendPasswordResetEmail(email: emailAddress);
  }

  Future<void> logOut() async {
    await _auth.signOut();
    if (await _googleSignIn.isSignedIn()) await _googleSignIn.signOut();
  }
}

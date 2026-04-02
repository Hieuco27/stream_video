import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stream_video/features/auth/data/models/user_model.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  UserModel? get userEntity => getCurrentUser();
  Stream<UserModel?> get userStream =>
      _firebaseAuth.authStateChanges().map((user) {
        if (user == null) {
          return null;
        }
        return UserModel(
          uid: user.uid,
          email: user.email ?? '',
          displayName: user.displayName ?? '',
          photoUrl: user.photoURL,
        );
      });
  Future<UserModel> signIn(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) {
        throw Exception('User not found');
      }
      return UserModel(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? '',
        photoUrl: user.photoURL,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  UserModel? getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return null;
    }
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? '',
      photoUrl: user.photoURL,
    );
  }
}

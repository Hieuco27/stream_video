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

  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw Exception('Phiên đăng nhập hết hạn');

      await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(email: user.email!, password: oldPassword),
      );
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          throw 'Mật khẩu cũ không đúng';
        case 'weak-password':
          throw 'Mật khẩu mới quá yếu (tối thiểu 6 ký tự)';
        case 'requires-recent-login':
          throw 'Phiên đăng nhập hết hạn, vui lòng đăng nhập lại';
        case 'too-many-requests':
          throw 'Quá nhiều lần thử, vui lòng thử lại sau';
        case 'network-request-failed':
          throw 'Không có kết nối mạng';
        default:
          throw 'Đã xảy ra lỗi: ${e.message}';
      }
    } catch (e) {
      throw Exception('Đã xảy ra lỗi, vui lòng thử lại');
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

import 'package:stream_video/core/errors/result.dart';
import 'package:stream_video/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  // Sign in with email and password
  Future<Result<UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  );
  // Sign out
  Future<Result<void>> signOut();
  // Change password
  Future<Result<void>> changePassword(String oldPassword, String newPassword);
  // Get current user
  UserEntity? getCurrentUser();
  // Save remember me
  Future<Result<void>> saveRememberStatus(bool shouldRemember);
  // Remove remember me
  Future<Result<void>> removeRememberStatus();
  // Get remember me
  Future<Result<bool>> getRememberStatus();
}

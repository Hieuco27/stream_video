import 'package:stream_video/core/errors/failure.dart';
import 'package:stream_video/core/errors/result.dart';
import 'package:stream_video/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:stream_video/features/auth/domain/entities/user_entity.dart';
import 'package:stream_video/features/auth/domain/repositories/auth_repository.dart';
import 'package:stream_video/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource = AuthRemoteDataSource();
  final AuthLocalDataSource _authLocalDataSource = AuthLocalDataSource();

  @override
  Future<Result<UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final user = await _authRemoteDataSource.signIn(email, password);
      return Result.success(user);
    } catch (e) {
      return Result.error(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _authRemoteDataSource.signOut();
      return Result.success(null);
    } catch (e) {
      return Result.error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      await _authRemoteDataSource.changePassword(oldPassword, newPassword);
      return Result.success(null);
    } catch (e) {
      return Result.error(ServerFailure(message: e.toString()));
    }
  }

  @override
  UserEntity? getCurrentUser() {
    return _authRemoteDataSource.getCurrentUser();
  }

  @override
  Future<Result<void>> saveRememberStatus(bool value) async {
    try {
      await _authLocalDataSource.saveRememberMe(value);
      return Result.success(null);
    } catch (e) {
      return Result.error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> removeRememberStatus() async {
    try {
      await _authLocalDataSource.removeRemeberMe();
      return Result.success(null);
    } catch (e) {
      return Result.error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<bool>> getRememberStatus() async {
    try {
      final value = await _authLocalDataSource.getRemeberMe();
      return Result.success(value);
    } catch (e) {
      return Result.error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Stream<UserEntity?> get userStream => _authRemoteDataSource.userStream;
}

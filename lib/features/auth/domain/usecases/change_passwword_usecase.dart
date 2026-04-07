import 'package:stream_video/core/errors/result.dart';
import 'package:stream_video/core/errors/failure.dart';
import 'package:stream_video/features/auth/domain/repositories/auth_repository.dart';

class ChangePasswordParams {
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  ChangePasswordParams({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
  });
}

class ChangePasswordUseCase {
  final AuthRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<Result<void>> call(ChangePasswordParams params) {
    if (params.oldPassword.isEmpty) {
      return Future.value(
        Result.error(ValidationFailure(message: 'Mật khẩu cũ không được để trống')),
      );
    }
    if (params.newPassword.isEmpty) {
      return Future.value(
        Result.error(ValidationFailure(message: 'Mật khẩu mới không được để trống')),
      );
    }
    if (params.confirmPassword.isEmpty) {
      return Future.value(
        Result.error(ValidationFailure(message: 'Vui lòng nhập lại mật khẩu mới')),
      );
    }
    if (params.newPassword != params.confirmPassword) {
      return Future.value(
        Result.error(ValidationFailure(message: 'Mật khẩu nhập lại không khớp')),
      );
    }
    if (params.newPassword == params.oldPassword) {
      return Future.value(
        Result.error(ValidationFailure(message: 'Mật khẩu mới không được trùng mật khẩu cũ')),
      );
    }

    return repository.changePassword(params.oldPassword, params.newPassword);
  }
}

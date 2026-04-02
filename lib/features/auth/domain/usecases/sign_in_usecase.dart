import 'package:stream_video/core/errors/failure.dart';
import 'package:stream_video/core/errors/result.dart';
import 'package:stream_video/features/auth/domain/entities/user_entity.dart';
import 'package:stream_video/features/auth/domain/repositories/auth_repository.dart';

class SignInParams {
  final String email;
  final String password;

  SignInParams({required this.email, required this.password});
  String? validate() {
    if (email.isEmpty) {
      return 'Email không được để trống';
    }
    if (password.isEmpty) {
      return 'Mật khẩu không được để trống';
    }
    if (password.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    if (!email.contains('@')) {
      return 'Email không hợp lệ';
    }
    return null;
  }
}

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<Result<UserEntity>> call(SignInParams params) async {
    final validate = params.validate();
    if (validate != null) {
      return Result.error(ValidationFailure(message: validate));
    }
    final result = await repository.signInWithEmailAndPassword(params.email, params.password);
    return result.when(
      success: (user) => Result.success(user),
      error: (failure) {
        String msg = failure.message;
        if (msg.contains('wrong-password') || msg.contains('invalid-credential')) {
          msg = 'Tài khoản hoặc mật khẩu không chính xác.';
        } else if (msg.contains('user-not-found')) {
          msg = 'Tài khoản không tồn tại.';
        } else if (msg.contains('user-disabled')) {
          msg = 'Tài khoản này đã bị vô hiệu hoá.';
        } else if (msg.contains('too-many-requests')) {
          msg = 'Quá nhiều yêu cầu. Vui lòng thử lại sau.';
        } else if (msg.contains('network-request-failed')) {
          msg = 'Lỗi kết nối mạng, vui lòng kiểm tra lại.';
        } else if (msg.startsWith('Exception: ')) {
          msg = msg.substring(11);
        }
        return Result.error(AuthFailure(message: msg));
      },
    );
  }
}

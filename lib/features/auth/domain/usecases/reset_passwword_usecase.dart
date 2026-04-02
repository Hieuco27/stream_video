import 'package:stream_video/core/errors/result.dart';
import 'package:stream_video/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Result<void>> call(String email) {
    return repository.resetPassword(email);
  }
}

import 'package:stream_video/core/errors/result.dart';
import 'package:stream_video/features/auth/domain/repositories/auth_repository.dart';

class RememberMeUseCase {
  final AuthRepository _authRepository;
  RememberMeUseCase(this._authRepository);
  Future<Result<void>> saveRememberStatus(bool shouldRemember) async {
    return await _authRepository.saveRememberStatus(shouldRemember);
  }

  Future<Result<void>> removeRememberStatus() async {
    return await _authRepository.removeRememberStatus();
  }

  Future<Result<bool>> getRememberStatus() async {
    return await _authRepository.getRememberStatus();
  }
}

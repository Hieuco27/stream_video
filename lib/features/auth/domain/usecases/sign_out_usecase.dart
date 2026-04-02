import 'package:stream_video/core/errors/result.dart';
import 'package:stream_video/features/auth/domain/repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  Future<Result<void>> call() {
    return repository.signOut();
  }
}

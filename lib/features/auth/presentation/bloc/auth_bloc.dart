import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_video/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:stream_video/features/auth/domain/usecases/remember_me_ussecase.dart';
import 'package:stream_video/features/auth/domain/usecases/reset_passwword_usecase.dart';
import 'package:stream_video/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:stream_video/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:stream_video/features/auth/presentation/bloc/auth_event.dart';
import 'package:stream_video/features/auth/presentation/bloc/auth_state.dart';
import '../../../../core/errors/result.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase signInUseCase;
  final SignOutUseCase signOutUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final RememberMeUseCase rememberMeUseCase;

  AuthBloc({
    required this.signInUseCase,
    required this.signOutUseCase,
    required this.resetPasswordUseCase,
    required this.getCurrentUserUseCase,
    required this.rememberMeUseCase,
  }) : super(AuthInitial()) {
    on<AuthSignInRequested>(_onAuthSignInRequested);
    on<AuthSignOutRequested>(_onAuthSignOutRequested);
    on<AuthResetPasswordRequested>(_onAuthResetPasswordRequested);
    on<AuthCheckStatusRequested>(_onAuthCheckStatusRequested);
  }

  Future<void> _onAuthSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await signInUseCase(
      SignInParams(email: event.email, password: event.password),
    );
    result.when(
      success: (user) {
        rememberMeUseCase.saveRememberStatus(event.rememberMe);
        emit(AuthAuthenticated(user: user));
      },
      error: (failure) => emit(AuthError(message: failure.message)),
    );
  }

  Future<void> _onAuthSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await signOutUseCase();
    result.when(
      success: (_) => emit(AuthInitial()),
      error: (failure) => emit(AuthError(message: failure.message)),
    );
  }

  Future<void> _onAuthResetPasswordRequested(
    AuthResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await resetPasswordUseCase(event.email);
    result.when(
      success: (_) => emit(AuthInitial()),
      error: (failure) => emit(AuthError(message: failure.message)),
    );
  }

  Future<void> _onAuthCheckStatusRequested(
    AuthCheckStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final user = getCurrentUserUseCase();
    final rememberStatusResult = await rememberMeUseCase.getRememberStatus();
    final isRemembered = rememberStatusResult.dataOrNull ?? false;

    if (user != null && isRemembered) {
      emit(AuthAuthenticated(user: user));
    } else {
      if (user != null) {
        await signOutUseCase();
      }
      emit(AuthInitial());
    }
  }
}

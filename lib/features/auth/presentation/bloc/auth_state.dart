import 'package:equatable/equatable.dart';
import 'package:stream_video/features/auth/domain/entities/user_entity.dart';

sealed class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserEntity user;

  AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthResetPasswordSent extends AuthState {
  final String email;

  AuthResetPasswordSent({required this.email});

  @override
  List<Object?> get props => [email];
}

import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;
  final bool rememberMe;

  AuthSignInRequested({
    required this.email,
    required this.password,
    required this.rememberMe,
  });

  @override
  List<Object?> get props => [email, password, rememberMe];
}

class AuthSignOutRequested extends AuthEvent {}

class AuthResetPasswordRequested extends AuthEvent {
  final String email;

  AuthResetPasswordRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

class AuthCheckStatusRequested extends AuthEvent {}

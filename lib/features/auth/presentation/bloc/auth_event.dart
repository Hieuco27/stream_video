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

class AuthChangePasswordRequested extends AuthEvent {
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  AuthChangePasswordRequested({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [oldPassword, newPassword, confirmPassword];
}

class AuthCheckStatusRequested extends AuthEvent {}

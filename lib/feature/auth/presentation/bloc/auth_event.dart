import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class SignUpRequested extends AuthEvent {
  final String firstname;
  final String lastname;
  final String email;
  final String location;
  final String password;
  final String passwordConfirmation;
  final bool isAuthor;
  const SignUpRequested({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.location,
    required this.password,
    required this.passwordConfirmation,
    this.isAuthor = false,
  });
}

class SignInRequested extends AuthEvent {
  final String email, password;
  final bool rememberMe;
  final bool isAuthor;
  SignInRequested({required this.email, required this.password, this.rememberMe = false,this.isAuthor = false,});
}

class VerifyEmailRequested extends AuthEvent {
  final String email;
  final String code;
  const VerifyEmailRequested(this.email, this.code);
}

class ForgotPasswordRequested extends AuthEvent {
  final String email;
  const ForgotPasswordRequested(this.email);
}

class ResetPasswordRequested extends AuthEvent {
  final String email;
  final String token;
  final String password;
  final String passwordConfirmation;
  const ResetPasswordRequested({
    required this.email,
    required this.token,
    required this.password,
    required this.passwordConfirmation,
  });
}

class SignOutRequested extends AuthEvent {}

// States
import '../../models/auth_response.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final AuthResponse authResponse;

  AuthAuthenticated({required this.authResponse});
}

class Authenticated extends AuthState {
  final SignupResponse signupResponse;

  Authenticated({required this.signupResponse});
}

class AuthError extends AuthState {
  final String error;

  AuthError({required this.error});
}

class SignupError extends AuthState {
  final String error;

  SignupError({required this.error});
}

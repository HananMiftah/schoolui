// Events
abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});
}

class TokenRefreshed extends AuthEvent {
  final String refreshToken;

  TokenRefreshed({required this.refreshToken});
}
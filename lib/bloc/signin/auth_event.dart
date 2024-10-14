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

// New SignUpRequested event to handle sign-up
class SignUpRequested extends AuthEvent {
  final String name;
  final String email;
  final String address;
  final String phone;

  SignUpRequested({
    required this.name,
    required this.email,
    required this.address,
    required this.phone,
  });
}

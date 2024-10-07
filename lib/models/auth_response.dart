class AuthResponse {
  final String refreshToken;
  final String accessToken;
  final User? user;

  AuthResponse({
    required this.refreshToken,
    required this.accessToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      refreshToken: json['refresh'],
      accessToken: json['access'],
      user: User.fromJson(json['user']),
    );
  }
}


class User {
  final String username;
  final String email;
  final String role;

  User({required this.username, required this.email, required this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      role: json['role'],
    );
  }
}

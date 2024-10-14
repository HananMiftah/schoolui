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

class SignupResponse {
  final int school_id;
  final int request_id;
  final String message;
  SignupResponse({
    required this.school_id,
    required this.request_id,
    required this.message,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      school_id: json['school_id'],
      request_id: json['request_id'],
      message: json['message'],
    );
  }
}

class User {
  final int id;
  final String email;
  final String role;

  User({required this.id, required this.email, required this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      role: json['role'],
    );
  }
}

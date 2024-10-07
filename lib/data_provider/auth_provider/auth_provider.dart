import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/auth_response.dart';

class AuthProvider {
  final String baseUrl = "http://192.168.1.3:8000/api";

  Future<AuthResponse> login(String email, String password) async {
    
    final response = await http.post(
      Uri.parse('$baseUrl/login/'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return AuthResponse.fromJson(data);
    } else {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }

  Future<String> refreshToken(String refreshToken) async {
    final response = await http.post(
      Uri.parse('$baseUrl/token/refresh/'),
      body: {'refresh': refreshToken},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access'];
    } else {
      throw Exception('Failed to refresh token');
    }
  }
}

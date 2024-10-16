import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/auth_response.dart';

class AuthProvider {
  final String baseUrl = "http://192.168.8.11:8000/api";

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
      AuthResponse authResponse = AuthResponse.fromJson(data);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', authResponse.user!.email);
      await prefs.setString('role', authResponse.user!.role);
      await prefs.setString('accessToken', authResponse.accessToken);

      return authResponse;
    } else {
      throw Exception(jsonDecode(response.body)['non_field_errors'][0]);
    }
  }

  Future<SignupResponse> signup(
      String email, String name, String address, String phone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/schools/'),
      body: {
        'email': email,
        'name': name,
        'address': address,
        'phone': phone,
      },
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return SignupResponse.fromJson(data);
    }
    if (response.statusCode == 400) {
      throw Exception("Email already registered");
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

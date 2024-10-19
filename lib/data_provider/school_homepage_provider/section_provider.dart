import 'dart:convert';

import 'package:schoolui/models/section.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SectionDataProvider {
  final String baseUrl = "http://192.168.8.11:8000/api";

  Future<void> addSection(Section section) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final accessToken = prefs.getString('accessToken');

    // Fetch school data using the saved email

    final response = await http.post(
      Uri.parse('$baseUrl/sections/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${accessToken}'
      },
      body: jsonEncode(section.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add section');
    }
  }

  Future<void> editSection(Section section) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final accessToken = prefs.getString('accessToken');

    // Fetch school data using the saved email

    final response = await http.put(
      Uri.parse('$baseUrl/sections/${section.id}/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${accessToken}'
      },
      body: jsonEncode(section.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to edit section');
    }
  }

  Future<void> deleteSection(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final accessToken = prefs.getString('accessToken');

    // Fetch school data using the saved email

    final response = await http.delete(
      Uri.parse('$baseUrl/sections/${id}/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${accessToken}'
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete grade');
    }
  }
}

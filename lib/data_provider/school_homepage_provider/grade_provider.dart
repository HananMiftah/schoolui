import 'dart:convert';

import 'package:schoolui/models/grade.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'school_homepage_provider.dart';

class GradeDataProvider {
  final String baseUrl = "http://192.168.8.11:8000/api";

  Future<void> addGrade(Grade grade) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final accessToken = prefs.getString('accessToken');

    // Fetch school data using the saved email
    final school = await SchoolHomepageProvider().getSchoolData();

    final newGrade = Grade(
      grade_name: grade.grade_name,
      school: school.id,
    );

    final response = await http.post(
      Uri.parse('$baseUrl/grades/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${accessToken}'
      },
      body: jsonEncode(newGrade.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add grade');
    }
  }

  Future<void> editGrade(Grade grade) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final accessToken = prefs.getString('accessToken');

    // Fetch school data using the saved email
    final school = await SchoolHomepageProvider().getSchoolData();

    final newGrade = Grade(
      grade_name: grade.grade_name,
      school: school.id,
    );

    final response = await http.put(
      Uri.parse('$baseUrl/grades/${grade.id}/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${accessToken}'
      },
      body: jsonEncode(newGrade.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update grade');
    }
  }

  Future<void> deleteGrade(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final accessToken = prefs.getString('accessToken');

    // Fetch school data using the saved email

    final response = await http.delete(
      Uri.parse('$baseUrl/grades/${id}/'),
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

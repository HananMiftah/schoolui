import 'dart:convert';

import 'package:schoolui/models/grade.dart';
import 'package:schoolui/models/subject.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'school_homepage_provider.dart';

class SubjectDataProvider {
  final String baseUrl = "http://192.168.8.11:8000/api";

  Future<void> addSubject(Subject subject) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final accessToken = prefs.getString('accessToken');

    // Fetch school data using the saved email
    final school = await SchoolHomepageProvider().getSchoolData();

    final newSubject = Subject(
      subject: subject.subject,
      school: school.id,
    );

    final response = await http.post(
      Uri.parse('$baseUrl/subjects/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${accessToken}'
      },
      body: jsonEncode(newSubject.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add subject');
    }
  }

  Future<void> editSubject(Subject subject) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final accessToken = prefs.getString('accessToken');

    // Fetch school data using the saved email
    final school = await SchoolHomepageProvider().getSchoolData();

    final updatedSubject = Subject(
      subject: subject.subject,
      school: school.id,
    );

    final response = await http.put(
      Uri.parse('$baseUrl/subjects/${subject.id}/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${accessToken}'
      },
      body: jsonEncode(updatedSubject.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update subject');
    }
  }

  Future<void> deleteSubject(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final accessToken = prefs.getString('accessToken');

    // Fetch school data using the saved email

    final response = await http.delete(
      Uri.parse('$baseUrl/subjects/${id}/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${accessToken}'
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete subject');
    }
  }
}

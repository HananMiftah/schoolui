import 'dart:convert';

import 'package:schoolui/models/teacher.dart';
import 'package:schoolui/models/teacherSection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class TeacherPageDataProvider {

  Future<Teacher> getTeacher() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final role = prefs.getString('role');
    final accessToken = prefs.getString('accessToken');

    // Fetch school data using the saved email
    final response =
        await http.get(Uri.parse('$baseUrl/teachers/email=$email/'), headers: {
      'Accept': 'Application/json',
      'Authorization': 'Bearer ${accessToken}',
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Teacher.fromJson(data); // Map JSON to the School model
    } else {
      throw Exception('Failed to fetch teacher data');
    }
  }

  Future<List<TeacherSection>> getSections() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final role = prefs.getString('role');
    final accessToken = prefs.getString('accessToken');

    if (email == null) {
      throw Exception('Unauthorized access');
    }

    final teacher = await getTeacher();
    final teacher_id = teacher.id;

    final response = await http.get(
        Uri.parse('$baseUrl/teachers/$teacher_id/view_sections/'),
        headers: {
          'Accept': 'Application/json',
          'Authorization': 'Bearer ${accessToken}',
        });
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      List<TeacherSection> sections = List<TeacherSection>.from(
          parsed.map((e) => TeacherSection.fromJson(e)));
      return sections;
    } else {
      throw Exception('Failed to fetch sections data');
    }
  }
}

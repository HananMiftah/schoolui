import 'dart:convert';

import 'package:schoolui/models/parent.dart';
import 'package:schoolui/models/students.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../models/student_attendance.dart';
import '../constants.dart';

class ParentPageDataProvider {
  Future<Parent> getParent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final accessToken = prefs.getString('accessToken');

    // Fetch school data using the saved email
    final response =
        await http.get(Uri.parse('$baseUrl/parents/email=$email/'), headers: {
      'Accept': 'Application/json',
      'Authorization': 'Bearer ${accessToken}',
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Parent.fromJson(data); // Map JSON to the School model
    } else {
      throw Exception('Failed to fetch teacher data');
    }
  }

  Future<List<Student>> getStudents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final accessToken = prefs.getString('accessToken');

    if (email == null) {
      throw Exception('Unauthorized access');
    }

    final parent = await getParent();
    final parent_id = parent.id;

    final response = await http
        .get(Uri.parse('$baseUrl/parents/$parent_id/view_students'), headers: {
      'Accept': 'Application/json',
      'Authorization': 'Bearer ${accessToken}',
    });
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      List<Student> sections =
          List<Student>.from(parsed.map((e) => Student.fromJson(e)));
      return sections;
    } else {
      throw Exception('Failed to fetch students data');
    }
  }

  Future<List<StudentAttendance>> getAttendance(int studentId, String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    final response = await http.get(
      Uri.parse('$baseUrl/attendance/?student=$studentId&date=$date'),
      headers: {
        'Accept': 'Application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> parsed = json.decode(response.body);
      List<StudentAttendance> attendanceList = parsed
          .map((e) => StudentAttendance.fromJson(e))
          .toList();
      return attendanceList;
    } else {
      throw Exception('Failed to fetch attendance data');
    }
  }
}

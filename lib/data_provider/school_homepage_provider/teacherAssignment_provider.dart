import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/teacherAssignment.dart';
import '../constants.dart';

class TeacherAssignmentProvider {

  Future<void> assignTeacher(TeacherAssignment assignment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final role = prefs.getString('role');
    final accessToken = prefs.getString('accessToken');

    if (role != 'SCHOOL' || email == null) {
      throw Exception('Unauthorized access: Not a school');
    }
    final response = await http.post(
      Uri.parse('$baseUrl/assign-teacher/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${accessToken}',
      },
      body: jsonEncode(assignment.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to assign teacher to section');
    }
  }

  Future<List<TeacherAssignment>> getAllAssignments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final role = prefs.getString('role');
    final accessToken = prefs.getString('accessToken');

    if (role != 'SCHOOL' || email == null) {
      throw Exception('Unauthorized access: Not a school');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/assign-teacher/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${accessToken}',
      },
    );
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      List<TeacherAssignment> assignments = List<TeacherAssignment>.from(
          parsed.map((e) => TeacherAssignment.fromJson(e)));
      print(assignments);
      return assignments; // Map JSON to the School model
    } else {
      throw Exception('Failed to fetch students data');
    }
  }

  Future<void> deleteAssignment(int? id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final role = prefs.getString('role');
    final accessToken = prefs.getString('accessToken');

    if (role != 'SCHOOL' || email == null) {
      throw Exception('Unauthorized access: Not a school');
    }
    final response = await http.delete(
      Uri.parse('$baseUrl/assign-teacher/${id}/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${accessToken}',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete assignment');
    }
  }
}

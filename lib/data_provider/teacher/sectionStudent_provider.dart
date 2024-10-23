import 'dart:convert';

import 'package:schoolui/models/students.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class SectionStudentDataProvider {

  Future<List<Student>> getStudents(int? id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    // Fetch school data using the saved email
    final response = await http
        .get(Uri.parse('$baseUrl/sections/$id/view_students/'), headers: {
      'Accept': 'Application/json',
      'Authorization': 'Bearer ${accessToken}',
    });
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      List<Student> students =
          List<Student>.from(parsed.map((e) => Student.fromJson(e)));
      return students;
    } else {
      throw Exception('Failed to fetch students data');
    }
  }
}

import 'dart:io';

import 'package:schoolui/data_provider/school_homepage_provider/school_homepage_provider.dart';
import 'package:schoolui/models/grade.dart';
import 'package:schoolui/models/section.dart';
import 'package:schoolui/models/students.dart';
import 'package:schoolui/models/subject.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/school.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/teacher.dart';
import '../constants.dart';

class TeacherDataProvider {

  Future<void> addTeacher(Teacher teacher) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final role = prefs.getString('role');
    final accessToken = prefs.getString('accessToken');

    if (role != 'SCHOOL' || email == null) {
      throw Exception('Unauthorized access: Not a school');
    }

    // Fetch school data using the saved email
    final school = await SchoolHomepageProvider().getSchoolData();
    final school_id = school.id;
    final newteacher = Teacher(
      first_name: teacher.first_name,
      last_name: teacher.last_name,
      email: teacher.email,
      phone: teacher.phone,
      school: school_id,
    );
    print(teacher.email);
    final response = await http.post(
      Uri.parse('$baseUrl/teachers/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${accessToken}'
      },
      body: jsonEncode(newteacher.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add teacher');
    }
  }

  Future<void> updateTeacher(Teacher teacher) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final role = prefs.getString('role');
    final accessToken = prefs.getString('accessToken');

    if (role != 'SCHOOL' || email == null) {
      throw Exception('Unauthorized access: Not a school');
    }

    // Fetch school data using the saved email
    final school = await SchoolHomepageProvider().getSchoolData();
    final school_id = school.id;
    final updatedTeacher = Teacher(
      first_name: teacher.first_name,
      last_name: teacher.last_name,
      email: teacher.email,
      phone: teacher.phone,
      school: school_id,
    );
    final response = await http.put(
      Uri.parse('$baseUrl/teachers/${teacher.id}/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${accessToken}',
      },
      body: jsonEncode(updatedTeacher.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update teacher');
    }
  }

  Future<void> deleteTeacher(int? id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final role = prefs.getString('role');
    final accessToken = prefs.getString('accessToken');

    if (role != 'SCHOOL' || email == null) {
      throw Exception('Unauthorized access: Not a school');
    }
    final response = await http.delete(
      Uri.parse('$baseUrl/teachers/${id}/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${accessToken}',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to update teacher');
    }
  }

  Future<void> uploadTeacherExcel(File file) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final role = prefs.getString('role');
    final accessToken = prefs.getString('accessToken');

    if (role != 'SCHOOL' || email == null) {
      throw Exception('Unauthorized access: Not a school');
    }
    // Fetch school data using the saved email
    final school = await SchoolHomepageProvider().getSchoolData();
    final school_id = school.id;

    final uri = Uri.parse('$baseUrl/teachers/upload-excel/');
    final request = http.MultipartRequest('POST', uri);

    // Add the file
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    // Add school ID to request fields
    request.fields['school_id'] = school_id.toString();

    // Add Authorization header
    request.headers['Authorization'] = 'Bearer $accessToken';

    final response = await request.send();

    if (response.statusCode != 201) {
      throw Exception('Failed to upload the file');
    }
  }
}

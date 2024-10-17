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

class StudentDataProvider {
  final String baseUrl = "http://192.168.8.11:8000/api";

  Future<void> addStudent(Student student) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final accessToken = prefs.getString('accessToken');

    // Fetch school data using the saved email
    final school = await SchoolHomepageProvider().getSchoolData();

    final newStudent = Student(
      first_name: student.first_name,
      last_name: student.last_name,
      gender: student.gender,
      student_id: student.student_id,
      school: school.id,
      section: student.section,
      age: student.age,
    );

    final response = await http.post(
      Uri.parse('$baseUrl/students/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${accessToken}'
      },
      body: jsonEncode(newStudent.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add teacher');
    }
  }

  Future<void> updateStudent(Student student) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    // Fetch school data using the saved email
    final school = await SchoolHomepageProvider().getSchoolData();
    final updatedStudent = Student(
        first_name: student.first_name,
        last_name: student.last_name,
        gender: student.gender,
        student_id: student.student_id,
        school: school.id,
        section: student.section,
        age: student.age);
    final response = await http.put(
      Uri.parse('$baseUrl/students/${student.id}/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${accessToken}',
      },
      body: jsonEncode(updatedStudent.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update student');
    }
  }

  Future<void> deleteStudent(int? id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    final response = await http.delete(
      Uri.parse('$baseUrl/students/${id}/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${accessToken}',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete a student');
    }
  }

  Future<void> uploadStudentExcel(File file, int? section) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    final school = await SchoolHomepageProvider().getSchoolData();

    final uri = Uri.parse('$baseUrl/students/upload-excel/');
    final request = http.MultipartRequest('POST', uri);

    // Add the file
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    // Add school ID to request fields
    request.fields['school_id'] = school.id.toString();
    request.fields['section_id'] = section.toString();
    print("this is the sectionnnnn " + section.toString());
    // Add Authorization header
    request.headers['Authorization'] = 'Bearer $accessToken';

    final response = await request.send();

    if (response.statusCode != 201) {
      throw Exception('Failed to upload the file');
    }
  }
}

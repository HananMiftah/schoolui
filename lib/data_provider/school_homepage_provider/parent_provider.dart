import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:schoolui/data_provider/school_homepage_provider/school_homepage_provider.dart';
import 'package:schoolui/models/parent.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class ParentDataProvider {

  Future<void> addParent(Parent parent) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    // Fetch school data using the saved email
    final school = await SchoolHomepageProvider().getSchoolData();

    final newParent = Parent(
      first_name: parent.first_name,
      last_name: parent.last_name,
      phone: parent.phone,
      email: parent.email,
      stu_id: parent.stu_id,
      school: school.id,
      student: parent.student,
    );

    final response = await http.post(
      Uri.parse('$baseUrl/parents/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(newParent.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add parent');
    }
  }

  Future<void> updateParent(Parent parent) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final school = await SchoolHomepageProvider().getSchoolData();

    final updatedParent = Parent(
      first_name: parent.first_name,
      last_name: parent.last_name,
      phone: parent.phone,
      email: parent.email,
      stu_id: parent.stu_id,
      school: school.id,
      student: parent.student,
    );
    final response = await http.put(
      Uri.parse('$baseUrl/parents/${parent.id}/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(updatedParent.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update parent');
    }
  }

  Future<void> deleteParent(int? id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    final response = await http.delete(
      Uri.parse('$baseUrl/parents/$id/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete parent');
    }
  }

  Future<void> uploadParentExcel(File file) async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    final school = await SchoolHomepageProvider().getSchoolData();

    final uri = Uri.parse('$baseUrl/parents/upload-excel/');
    final request = http.MultipartRequest('POST', uri);

    // Add the file
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    // Add school ID to request fields
    request.fields['school_id'] = school.id.toString();

    // Add Authorization header
    request.headers['Authorization'] = 'Bearer $accessToken';

    final response = await request.send();

    if (response.statusCode != 201) {
      throw Exception('Failed to upload the file');
    }
  }
}

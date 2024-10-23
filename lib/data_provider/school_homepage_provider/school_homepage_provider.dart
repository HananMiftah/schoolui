import 'package:schoolui/models/grade.dart';
import 'package:schoolui/models/section.dart';
import 'package:schoolui/models/students.dart';
import 'package:schoolui/models/subject.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/parent.dart';
import '../../models/school.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/teacher.dart';
import '../constants.dart';

class SchoolHomepageProvider {

  Future<School> getSchoolData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final role = prefs.getString('role');

    if (role != 'SCHOOL' || email == null) {
      throw Exception('Unauthorized access: Not a school');
    }

    // Fetch school data using the saved email
    final response = await http.get(
      Uri.parse('$baseUrl/schools/email=$email/'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return School.fromJson(data); // Map JSON to the School model
    } else {
      throw Exception('Failed to fetch school data');
    }
  }

  Future<List<Teacher>> getTeachers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final role = prefs.getString('role');
    final accessToken = prefs.getString('accessToken');

    if (role != 'SCHOOL' || email == null) {
      throw Exception('Unauthorized access: Not a school');
    }

    // Fetch school data using the saved email
    final school = await getSchoolData();
    final school_id = school.id;

    final response = await http
        .get(Uri.parse('$baseUrl/schools/$school_id/get-teachers/'), headers: {
      'Accept': 'Application/json',
      'Authorization': 'Bearer ${accessToken}',
    });
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      List<Teacher> teachers =
          List<Teacher>.from(parsed.map((e) => Teacher.fromJson(e)));
      return teachers; // Map JSON to the School model
    } else {
      throw Exception('Failed to fetch teachers data');
    }
  }

  Future<List<Student>> getStudents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final role = prefs.getString('role');
    final accessToken = prefs.getString('accessToken');

    if (role != 'SCHOOL' || email == null) {
      throw Exception('Unauthorized access: Not a school');
    }

    // Fetch school data using the saved email
    final school = await getSchoolData();
    final school_id = school.id;

    final response = await http
        .get(Uri.parse('$baseUrl/schools/$school_id/get-students/'), headers: {
      'Accept': 'Application/json',
      'Authorization': 'Bearer ${accessToken}',
    });
    print("responseeeeeeeeeeee");
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      List<Student> students =
          List<Student>.from(parsed.map((e) => Student.fromJson(e)));
      return students; // Map JSON to the School model
    } else {
      throw Exception('Failed to fetch students data');
    }
  }

  Future<List<Grade>> getGrades() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final role = prefs.getString('role');
    final accessToken = prefs.getString('accessToken');

    if (role != 'SCHOOL' || email == null) {
      throw Exception('Unauthorized access: Not a school');
    }

    // Fetch school data using the saved email
    final school = await getSchoolData();
    final school_id = school.id;

    final response = await http
        .get(Uri.parse('$baseUrl/schools/$school_id/get-grades/'), headers: {
      'Accept': 'Application/json',
      'Authorization': 'Bearer ${accessToken}',
    });
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      List<Grade> grades =
          List<Grade>.from(parsed.map((e) => Grade.fromJson(e)));
      return grades; // Map JSON to the School model
    } else {
      throw Exception('Failed to fetch grade data');
    }
  }

  Future<List<Section>> getSections() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final role = prefs.getString('role');
    final accessToken = prefs.getString('accessToken');

    if (role != 'SCHOOL' || email == null) {
      throw Exception('Unauthorized access: Not a school');
    }

    // Fetch school data using the saved email
    final school = await getSchoolData();
    final school_id = school.id;

    final response = await http.get(
        Uri.parse('$baseUrl/schools/$school_id/get-school-sections/'),
        headers: {
          'Accept': 'Application/json',
          'Authorization': 'Bearer ${accessToken}',
        });
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      List<Section> sections =
          List<Section>.from(parsed.map((e) => Section.fromJson(e)));
      return sections;
    } else {
      throw Exception('Failed to fetch section data');
    }
  }

  Future<List<Subject>> getSubjects() async {
    // Fetch school data using the saved email
    final school = await getSchoolData();
    final school_id = school.id;

    final response = await http.get(
      Uri.parse('$baseUrl/schools/$school_id/get-subjects/'),
    );
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      List<Subject> subjects =
          List<Subject>.from(parsed.map((e) => Subject.fromJson(e)));
      return subjects;
    } else {
      throw Exception('Failed to fetch subjects data');
    }
  }

  Future<List<Parent>> getParents() async {
    // Fetch school data using the saved email
    final school = await getSchoolData();
    final school_id = school.id;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final accessToken = prefs.getString('accessToken');

    final response = await http
        .get(Uri.parse('$baseUrl/schools/$school_id/get-parents/'), headers: {
      'Accept': 'Application/json',
      'Authorization': 'Bearer ${accessToken}',
    });

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      List<Parent> parents =
          List<Parent>.from(parsed.map((e) => Parent.fromJson(e)));
      return parents;
    } else {
      throw Exception('Failed to fetch parents data');
    }
  }
}

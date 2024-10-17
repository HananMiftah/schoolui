import 'dart:io';

import 'package:schoolui/data_provider/school_homepage_provider/student_provider.dart';

import '../../models/students.dart';

class StudentRepository {
  final StudentDataProvider dataProvider;

  StudentRepository({required this.dataProvider});

  Future<void> addStudent(Student student) async {
    await dataProvider.addStudent(student);
  }

  Future<void> updateStudent(Student student) async {
    await dataProvider.updateStudent(student);
  }

  Future<void> deleteStudent(int? id) async {
    await dataProvider.deleteStudent(id);
  }

  Future<void> uploadExcel(File file, int? id) async {
    await dataProvider.uploadStudentExcel(file, id);
  }
}
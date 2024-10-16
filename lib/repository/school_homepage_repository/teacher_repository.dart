import 'dart:io';

import '../../data_provider/school_homepage_provider/teacher_provider.dart';
import '../../models/teacher.dart';

class TeacherRepository {
  final TeacherDataProvider dataProvider;

  TeacherRepository({required this.dataProvider});

  Future<void> addTeacher(Teacher teacher) async {
    await dataProvider.addTeacher(teacher);
  }

  Future<void> updateTeacher(Teacher teacher) async {
    await dataProvider.updateTeacher(teacher);
  }

  Future<void> deleteTeacher(int? id) async {
    await dataProvider.deleteTeacher(id);
  }

  Future<void> uploadTeacherExcel(File file) async {
    await dataProvider.uploadTeacherExcel(file);
  }
}

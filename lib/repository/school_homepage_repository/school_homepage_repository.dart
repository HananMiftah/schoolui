import 'package:schoolui/data_provider/school_homepage_provider/school_homepage_provider.dart';
import 'package:schoolui/models/grade.dart';
import 'package:schoolui/models/section.dart';
import 'package:schoolui/models/students.dart';
import 'package:schoolui/models/subject.dart';
import 'package:schoolui/models/teacher.dart';

import '../../models/school.dart';

class SchoolHomepageRepository {
  final SchoolHomepageProvider homeProvider;

  SchoolHomepageRepository(this.homeProvider);

  Future<School> getSchoolData() {
    return homeProvider.getSchoolData();
  }

  Future<List<Teacher>> getTeachers() {
    return homeProvider.getTeachers();
  }

  Future<List<Student>> getStudents() {
    return homeProvider.getStudents();
  }

  Future<List<Grade>> getGrades() {
    return homeProvider.getGrades();
  }

  Future<List<Section>> getSections() {
    return homeProvider.getSections();
  }

  Future<List<Subject>> getSubjects() {
    return homeProvider.getSubjects();
  }
}

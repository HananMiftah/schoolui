import 'package:schoolui/models/parent.dart';
import 'package:schoolui/models/students.dart';

import '../../data_provider/parent/parentpage_provider.dart';
import '../../models/student_attendance.dart';

class ParentPageRepository {
  final ParentPageDataProvider dataProvider;

  ParentPageRepository({required this.dataProvider});

  // Fetch teacher data
  Future<Parent> getParent() async {
    return await dataProvider.getParent();
  }

  // Fetch teacher's sections
  Future<List<Student>> getStudents() async {
    return await dataProvider.getStudents();
  }

  Future<List<StudentAttendance>> getAttendance(
      int studentId, String date) async {
    return await dataProvider.getAttendance(studentId, date);
  }
}

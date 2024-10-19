import '../../data_provider/school_homepage_provider/teacherAssignment_provider.dart';
import '../../models/teacherAssignment.dart';

class TeacherAssignmentRepository {
  final TeacherAssignmentProvider dataProvider;

  TeacherAssignmentRepository({required this.dataProvider});

  Future<void> assignTeacher(TeacherAssignment assignment) async {
    await dataProvider.assignTeacher(assignment);
  }

  Future<List<TeacherAssignment>> getAllAssignments() async {
    return dataProvider.getAllAssignments();
  }

  Future<void> deleteAssignment(int? id) async {
    return dataProvider.deleteAssignment(id);
  }
}

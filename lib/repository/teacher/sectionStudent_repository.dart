import 'package:schoolui/data_provider/teacher/sectionStudent_provider.dart';
import 'package:schoolui/models/students.dart';

class SectionStudentPageRepository {
  final SectionStudentDataProvider dataProvider;

  SectionStudentPageRepository({required this.dataProvider});


  Future<List<Student>> getStudents(int? id) async {
    return await dataProvider.getStudents(id);
  }
}
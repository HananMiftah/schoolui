import '../../data_provider/teacher/teacherpage_provider.dart';
import '../../models/teacher.dart';
import '../../models/teacherSection.dart';

class TeacherPageRepository {
  final TeacherPageDataProvider dataProvider;

  TeacherPageRepository({required this.dataProvider});

  // Fetch teacher data
  Future<Teacher> getTeacher() async {
    return await dataProvider.getTeacher();
  }

  // Fetch teacher's sections
  Future<List<TeacherSection>> getSections() async {
    return await dataProvider.getSections();
  }
}

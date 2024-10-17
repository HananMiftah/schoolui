import 'package:schoolui/data_provider/school_homepage_provider/grade_provider.dart';
import 'package:schoolui/models/grade.dart';

class GradeRepository {
  final GradeDataProvider dataProvider;

  GradeRepository({required this.dataProvider});

  Future<void> addGrade(Grade grade) async {
    await dataProvider.addGrade(grade);
  }

  Future<void> editGrade(Grade grade) async {
    await dataProvider.editGrade(grade);
  }

  Future<void> deleteGrade(int id) async {
    await dataProvider.deleteGrade(id);
  }
}

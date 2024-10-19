import 'package:schoolui/data_provider/school_homepage_provider/grade_provider.dart';
import 'package:schoolui/data_provider/school_homepage_provider/subject_provider.dart';
import 'package:schoolui/models/grade.dart';
import 'package:schoolui/models/subject.dart';

class SubjectRepository {
  final SubjectDataProvider dataProvider;

  SubjectRepository({required this.dataProvider});

  Future<void> addSubject(Subject subject) async {
    await dataProvider.addSubject(subject);
  }

  Future<void> editSubject(Subject subject) async {
    await dataProvider.editSubject(subject);
  }

  Future<void> deleteSubject(int id) async {
    await dataProvider.deleteSubject(id);
  }
}

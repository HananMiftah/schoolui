import 'package:schoolui/data_provider/school_homepage_provider/section_provider.dart';
import 'package:schoolui/models/section.dart';

class SectionRepository {
  final SectionDataProvider dataProvider;

  SectionRepository({required this.dataProvider});

  Future<void> addSection(Section section) async {
    await dataProvider.addSection(section);
  }

  Future<void> editSection(Section section) async {
    await dataProvider.editSection(section);
  }

  Future<void> deleteSection(int id) async {
    await dataProvider.deleteSection(id);
  }
}

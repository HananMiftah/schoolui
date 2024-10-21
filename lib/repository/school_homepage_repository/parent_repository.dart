import 'dart:io';
import 'package:schoolui/data_provider/school_homepage_provider/parent_provider.dart';
import 'package:schoolui/models/parent.dart';

class ParentRepository {
  final ParentDataProvider dataProvider;

  ParentRepository({required this.dataProvider});

  Future<void> addParent(Parent parent) async {
    await dataProvider.addParent(parent);
  }

  Future<void> updateParent(Parent parent) async {
    await dataProvider.updateParent(parent);
  }

  Future<void> deleteParent(int? id) async {
    await dataProvider.deleteParent(id);
  }

  Future<void> uploadExcel(File file) async {
    await dataProvider.uploadParentExcel(file);
  }
}

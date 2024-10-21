import 'dart:io';
import '../../../models/parent.dart';

abstract class ParentEvent {}

class AddParentEvent extends ParentEvent {
  final Parent parent;

  AddParentEvent(this.parent);
}

class UpdateParentEvent extends ParentEvent {
  final Parent parent;

  UpdateParentEvent(this.parent);
}

class DeleteParentEvent extends ParentEvent {
  final int? id;

  DeleteParentEvent(this.id);
}

class UploadParentExcelEvent extends ParentEvent {
  final File file;

  UploadParentExcelEvent(this.file);

  @override
  List<Object?> get props => [
        file,
      ];
}

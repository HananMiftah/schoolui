import 'dart:io';

import '../../../models/students.dart';

abstract class StudentEvent {}

class AddStudentEvent extends StudentEvent {
  final Student student;

  AddStudentEvent(this.student);
}

class UpdateStudentEvent extends StudentEvent {
  final Student student;

  UpdateStudentEvent(this.student);
}

class DeleteStudentEvent extends StudentEvent {
  final int? id;

  DeleteStudentEvent(this.id);
}

class UploadStudentExcel extends StudentEvent {
  final File file;
  final int? id;

  UploadStudentExcel(this.file, this.id);

  @override
  List<Object?> get props => [file, id];
}

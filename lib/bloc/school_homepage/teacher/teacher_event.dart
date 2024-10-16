import 'dart:io';

import 'package:equatable/equatable.dart';
import '../../../models/teacher.dart';

abstract class TeacherEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddTeacherEvent extends TeacherEvent {
  final Teacher teacher;

  AddTeacherEvent(this.teacher);

  @override
  List<Object?> get props => [teacher];
}

class UpdateTeacherEvent extends TeacherEvent {
  final Teacher teacher;

  UpdateTeacherEvent(this.teacher);

  @override
  List<Object?> get props => [teacher];
}

class DeleteTeacherEvent extends TeacherEvent {
  final int? id;

  DeleteTeacherEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class UploadTeacherExcel extends TeacherEvent {
  final File file;

  UploadTeacherExcel(this.file);

  @override
  List<Object?> get props => [file];
}


import 'package:equatable/equatable.dart';

import '../../../../models/teacherAssignment.dart';

abstract class TeacherAssignmentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAssignments extends TeacherAssignmentEvent {}

class AssignTeacherEvent extends TeacherAssignmentEvent {
  final TeacherAssignment assignment;

  AssignTeacherEvent(this.assignment);

  @override
  List<Object?> get props => [assignment];
}

class DeleteTeacherAssignmentEvent extends TeacherAssignmentEvent {
  final int? id;

  DeleteTeacherAssignmentEvent(this.id);

  @override
  List<Object?> get props => [id];
}

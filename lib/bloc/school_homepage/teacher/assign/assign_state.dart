import 'package:equatable/equatable.dart';
import 'package:schoolui/models/teacherAssignment.dart';

abstract class TeacherAssignmentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TeacherAssignmentInitial extends TeacherAssignmentState {}

class TeacherAssignmentLoading extends TeacherAssignmentState {}

class AssignmentsLoaded extends TeacherAssignmentState {
  final List<TeacherAssignment> assignments;

  AssignmentsLoaded({required this.assignments});

  @override
  List<Object?> get props => [assignments];
}

class TeacherAssignmentSuccess extends TeacherAssignmentState {}

class TeacherAssignmentFailure extends TeacherAssignmentState {
  final String error;

  TeacherAssignmentFailure(this.error);

  @override
  List<Object?> get props => [error];
}

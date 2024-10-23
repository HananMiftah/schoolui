// states/student_state.dart
import 'package:equatable/equatable.dart';

import '../../../models/students.dart';

abstract class SectionStudentState extends Equatable {
  const SectionStudentState();

  @override
  List<Object?> get props => [];
}

class StudentLoading extends SectionStudentState {}

class StudentLoaded extends SectionStudentState {
  final List<Student> students;

  const StudentLoaded(this.students);

  @override
  List<Object?> get props => [students];
}

class StudentError extends SectionStudentState {
  final String message;

  const StudentError(this.message);

  @override
  List<Object?> get props => [message];
}

import 'package:equatable/equatable.dart';
import 'package:schoolui/models/teacher.dart';
import 'package:schoolui/models/teacherSection.dart';

abstract class TeacherPageState extends Equatable {
  const TeacherPageState();

  @override
  List<Object?> get props => [];
}

// Initial state
class TeacherInitial extends TeacherPageState {}

// Loading state
class TeacherLoading extends TeacherPageState {}

// State when teacher data is loaded successfully
class TeacherLoaded extends TeacherPageState {
  final Teacher teacher;

  const TeacherLoaded(this.teacher);

  @override
  List<Object?> get props => [teacher];
}

// State when teacher's sections are loaded successfully
class TeacherSectionsLoaded extends TeacherPageState {
  final List<TeacherSection> sections;

  const TeacherSectionsLoaded(this.sections);

  @override
  List<Object?> get props => [sections];
}

// Error state
class TeacherError extends TeacherPageState {
  final String message;

  const TeacherError(this.message);

  @override
  List<Object?> get props => [message];
}

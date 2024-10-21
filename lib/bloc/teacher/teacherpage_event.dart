import 'package:equatable/equatable.dart';

abstract class TeacherPageEvent extends Equatable {
  const TeacherPageEvent();

  @override
  List<Object?> get props => [];
}

// Event to load teacher's data
class LoadTeacher extends TeacherPageEvent {}

// Event to load sections associated with the teacher
class LoadTeacherSections extends TeacherPageEvent {}

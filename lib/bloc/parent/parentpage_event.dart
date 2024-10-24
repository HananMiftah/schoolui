import 'package:equatable/equatable.dart';

abstract class ParentPageEvent extends Equatable {
  const ParentPageEvent();

  @override
  List<Object?> get props => [];
}

// Event to load students associated with the parent
class LoadParentStudents extends ParentPageEvent {}

// Event to refresh the student list
class RefreshParentStudents extends ParentPageEvent {}

// Event to load attendance records for a specific student
class LoadStudentAttendance extends ParentPageEvent {
  final int studentId; // ID of the student whose attendance is to be loaded
  final String date;
  const LoadStudentAttendance(this.studentId, this.date);

  @override
  List<Object?> get props => [studentId];
}

// Event to refresh attendance records for a specific student
class RefreshStudentAttendance extends ParentPageEvent {
  final int studentId; // ID of the student whose attendance is to be refreshed
  final String date;
  const RefreshStudentAttendance(this.studentId, this.date);

  @override
  List<Object?> get props => [studentId];
}

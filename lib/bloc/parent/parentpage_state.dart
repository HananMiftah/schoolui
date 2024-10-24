import 'package:equatable/equatable.dart';

import '../../models/students.dart'; // Import your Student model here
import '../../models/student_attendance.dart'; // Import your StudentAttendance model here

abstract class ParentPageState extends Equatable {
  const ParentPageState();

  @override
  List<Object?> get props => [];
}

// Initial state
class ParentInitial extends ParentPageState {}

// Loading state
class ParentLoading extends ParentPageState {}

// State when student data is loaded successfully
class ParentStudentsLoaded extends ParentPageState {
  final List<Student> students; // List of students associated with the parent

  const ParentStudentsLoaded(this.students);

  @override
  List<Object?> get props => [students];
}

// Loading state for attendance
class ParentAttendanceLoading extends ParentPageState {}

// State when attendance data is loaded successfully
class ParentAttendanceLoaded extends ParentPageState {
  final List<StudentAttendance> attendanceRecords; // List of attendance records

  const ParentAttendanceLoaded(this.attendanceRecords);

  @override
  List<Object?> get props => [attendanceRecords];
}

// Error state
class ParentError extends ParentPageState {
  final String message;

  const ParentError(this.message);

  @override
  List<Object?> get props => [message];
}

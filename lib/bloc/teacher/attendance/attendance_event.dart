// bloc/attendance/attendance_event.dart
import 'package:equatable/equatable.dart';

import '../../../models/attendance.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object> get props => [];
}

// Event to fetch attendance for a specific section on a specific date
class FetchAttendance extends AttendanceEvent {
  final int sectionId;
  final DateTime date;

  const FetchAttendance(this.sectionId, this.date);

  @override
  List<Object> get props => [sectionId, date];
}

// Event to post attendance
class PostAttendance extends AttendanceEvent {
  final List<Attendance> attendanceList;

  const PostAttendance(this.attendanceList);

  @override
  List<Object> get props => [attendanceList];
}

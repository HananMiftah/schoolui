import 'package:equatable/equatable.dart';

abstract class AttendanceStatusEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UpdateAttendanceStatus extends AttendanceStatusEvent {
  final int studentId;
  final String status;

  UpdateAttendanceStatus({required this.studentId, required this.status});

  @override
  List<Object> get props => [studentId, status];
}

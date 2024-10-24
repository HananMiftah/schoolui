import 'package:equatable/equatable.dart';

class AttendanceStatusState extends Equatable {
  final Map<int, String> attendanceStatus;

  AttendanceStatusState({required this.attendanceStatus});

  @override
  List<Object> get props => [attendanceStatus];

  AttendanceStatusState copyWith({Map<int, String>? attendanceStatus}) {
    return AttendanceStatusState(
      attendanceStatus: attendanceStatus ?? this.attendanceStatus,
    );
  }
}

// bloc/attendance/attendance_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/teacher/attendance_repository.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendanceRepository repository;

  AttendanceBloc({required this.repository}) : super(AttendanceLoading()) {
    on<FetchAttendance>((event, emit) async {
      emit(AttendanceLoading());
      try {
        final attendance =
            await repository.fetchAttendance(event.sectionId, event.date);
        emit(AttendanceLoaded(attendance));
      } catch (e) {
        emit(AttendanceError('Failed to fetch attendance'));
      }
    });

    on<PostAttendance>((event, emit) async {
      try {
        await repository.postAttendance(event.attendanceList);
        emit(AttendancePosted('Attendance posted successfully'));
      } catch (e) {
        emit(AttendanceError('Failed to post attendance'));
      }
    });
  }
}

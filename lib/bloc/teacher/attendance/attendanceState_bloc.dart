import 'package:flutter_bloc/flutter_bloc.dart';

import 'attendanceState_event.dart';
import 'attendanceState_state.dart';

class AttendanceStatusBloc extends Bloc<AttendanceStatusEvent, AttendanceStatusState> {
  AttendanceStatusBloc() : super(AttendanceStatusState(attendanceStatus: {}));

  Stream<AttendanceStatusState> mapEventToState(AttendanceStatusEvent event) async* {
    if (event is UpdateAttendanceStatus) {
      final newAttendanceStatus = Map<int, String>.from(state.attendanceStatus);
      newAttendanceStatus[event.studentId] = event.status;

      yield state.copyWith(attendanceStatus: newAttendanceStatus);
    }
  }
}

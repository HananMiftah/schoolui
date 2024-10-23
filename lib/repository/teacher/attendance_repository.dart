import 'package:schoolui/data_provider/teacher/attendance_provider.dart';
import 'package:schoolui/models/attendance.dart';

class AttendanceRepository {
  final AttendanceDataProvider dataProvider;

  AttendanceRepository({required this.dataProvider});

  Future<List<Attendance>> fetchAttendance(
      int? sectionId, DateTime date) async {
    return await dataProvider.fetchAttendance(sectionId, date);
  }

  Future<void> postAttendance(
      List<Attendance> attendanceList) async {
    return await dataProvider.postAttendance(attendanceList);
  }
}

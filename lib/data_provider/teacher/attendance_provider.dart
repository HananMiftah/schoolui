import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/attendance.dart';
import '../constants.dart';

class AttendanceDataProvider {
  Future<List<Attendance>> fetchAttendance(
      int? sectionId, DateTime date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final formattedDate = date
        .toIso8601String()
        .split("T")
        .first; // Convert DateTime to YYYY-MM-DD format
    final response = await http.get(
        Uri.parse(
            '$baseUrl/attendance/?section=$sectionId&date=$formattedDate'),
        headers: {
          'Accept': 'Application/json',
          'Authorization': 'Bearer ${accessToken}',
        });

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Attendance> attendanceList =
          body.map((dynamic item) => Attendance.fromJson(item)).toList();
      return attendanceList;
    } else {
      throw Exception('Failed to load attendance');
    }
  }

  Future<void> postAttendance(List<AttendancePost> attendanceList) async {
    final url = '$baseUrl/attendance/';
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final accessToken = prefs.getString('accessToken');
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${accessToken}',
      },
      body: jsonEncode(
          attendanceList.map((attendance) => attendance.toJson()).toList()),
    );
    print(response.body);
    if (response.statusCode != 200) {
      throw Exception('Failed to post attendance. Error: ${response.body}');
    }
  }
}

class Attendance {
  final int id;
  final int studentId;
  final String studentFirst;
  final String studentLast;
  final String status;

  Attendance({
    required this.id,
    required this.studentId,
    required this.studentFirst,
    required this.studentLast,
    required this.status,
  });

  // Factory constructor for creating a new Attendance instance from JSON
  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'] ?? -1,
      studentId: json['student'] ?? -1,
      studentFirst: json['student_first'] ?? '',
      studentLast: json['student_last'] ?? '',
      status: json['status'] ?? 'PRESENT',
    );
  }

  // Method for converting Attendance instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student': studentId,
      'student_first': studentFirst,
      'student_last': studentLast,
      'status': status,
    };
  }
}

class AttendancePost {
  final int studentId;
  final int sectionId;

  final String date;
  final String status;

  AttendancePost({
    required this.studentId,
    required this.sectionId,
    required this.date,
    required this.status,
  });

  factory AttendancePost.fromJson(Map<String, dynamic> json) {
    return AttendancePost(
      studentId: json['student'],
      date: json['date'],
      status: json['status'],
      sectionId: json['section_subject'],
    );
  }

  // Convert an Attendance object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'student': studentId,
      'date': date, // Convert DateTime to a string format
      'status': status,
      'section_subject': sectionId,
    };
  }
}

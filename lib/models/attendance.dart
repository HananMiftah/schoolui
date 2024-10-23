class Attendance {
  final int id;
  final String studentFirst;
  final String studentLast;
  final String status;

  Attendance({
    required this.id,
    required this.studentFirst,
    required this.studentLast,
    required this.status,
  });

  // Factory constructor for creating a new Attendance instance from JSON
  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'] ?? -1,
      studentFirst: json['student_first'] ?? '',
      studentLast: json['student_last'] ?? '',
      status: json['status'] ?? 'PRESENT',
    );
  }

  // Method for converting Attendance instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_first': studentFirst,
      'student_last': studentLast,
      'status': status,
    };
  }
}

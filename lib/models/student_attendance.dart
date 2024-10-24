class StudentAttendance {
  final int id;
  final String status;
  final int student;
  final String grade;
  final String section;
  final String subject;

  StudentAttendance({
    required this.id,
    required this.status,
    required this.student,
    required this.grade,
    required this.section,
    required this.subject,
  });

  // Factory method to create an instance from a JSON object
  factory StudentAttendance.fromJson(Map<String, dynamic> json) {
    return StudentAttendance(
      id: json['id'],
      status: json['status'],
      student: json['student'],
      grade: json['grade'],
      section: json['section'],
      subject: json['subject'],
    );
  }

  // Method to convert an instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'student': student,
      'grade': grade,
      'section': section,
      'subject': subject,
    };
  }
}

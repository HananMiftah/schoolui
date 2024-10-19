class TeacherAssignment {
  final int? id;
  final int teacher;
  final int section;
  final int subject;

  TeacherAssignment({
    this.id,
    required this.teacher,
    required this.section,
    required this.subject,
  });

  // Convert from JSON
  factory TeacherAssignment.fromJson(Map<String, dynamic> json) {
    return TeacherAssignment(
      id: json['id'],
      teacher: json['teacher'],
      section: json['section'],
      subject: json['subject'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'teacher_id': teacher,
      'section_id': section,
      'subject_id': subject,
    };
  }
}

class TeacherSection {
  final int id;
  final int sectionId;
  final int subjectId;
  final String gradeName;
  final String sectionName;
  final String subjectName;

  TeacherSection({
    required this.id,
    required this.subjectId,
    required this.sectionId,
    required this.gradeName,
    required this.sectionName,
    required this.subjectName,
  });

  // Factory method to parse from JSON
  factory TeacherSection.fromJson(Map<String, dynamic> json) {
    return TeacherSection(
      id: json['id'],
      subjectId: json['subject'],
      sectionId: json['section'],
      gradeName: json['grade_name'],
      sectionName: json['section_name'],
      subjectName: json['subject_name'],
    );
  }

  // Convert to JSON if needed
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'section': sectionId,
      'subject': subjectId,
      'subject_name': subjectName,
      'grade_name': gradeName,
      'section_name': sectionName,
    };
  }
}

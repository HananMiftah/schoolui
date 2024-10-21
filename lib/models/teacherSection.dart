class TeacherSection {
  final int id;
  final int sectionId;
  final String gradeName;
  final String sectionName;

  TeacherSection({
    required this.id,
    required this.sectionId,
    required this.gradeName,
    required this.sectionName,
  });

  // Factory method to parse from JSON
  factory TeacherSection.fromJson(Map<String, dynamic> json) {
    return TeacherSection(
      id: json['id'],
      sectionId: json['section'],
      gradeName: json['grade_name'],
      sectionName: json['section_name'],
    );
  }

  // Convert to JSON if needed
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'section': sectionId,
      'grade_name': gradeName,
      'section_name': sectionName,
    };
  }
}

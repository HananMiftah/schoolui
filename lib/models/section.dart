class Section {
  final int? id;
  final String grade_name;
  final String section;
  final int? grade;

  Section({
    this.id,
    required this.grade_name,
    this.grade,
    required this.section,
  });

  // Map JSON data to the School object
  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'],
      grade_name: json['grade_name'],
      section: json['section'],
      grade: json['grade'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'grade_name': grade_name,
      'grade': grade,
      'section': section,
    };
  }
  Section copyWith({
    int? id,
    String? section,
    int? grade,
    String? grade_name,
  }) {
    return Section(
      id: id ?? this.id,
      section: section ?? this.section,
      grade: grade ?? this.grade,
      grade_name: grade_name ?? this.grade_name,
    );
  }
}

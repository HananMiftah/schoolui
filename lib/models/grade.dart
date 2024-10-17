class Grade {
  final int? id;
  final String grade_name;
  final int? school;

  Grade({
    this.id,
    required this.grade_name,
    this.school,
  });

  // Map JSON data to the School object
  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      id: json['id'],
      grade_name: json['grade_name'],
      school: json['school'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'grade_name': grade_name,
      'school': school,
    };
  }
}

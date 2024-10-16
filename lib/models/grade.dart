class Grade {
  final int id;
  final String grade_name;
  final int school;

  Grade({
    required this.id,
    required this.grade_name,
    required this.school,
  });

  // Map JSON data to the School object
  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      id: json['id'],
      grade_name: json['grade_name'],
      school: json['school'],
    );
  }
}

class Student {
  final int? id;
  final int age;
  final String first_name;
  final String last_name;
  final String gender;
  final String student_id;
  final int? school;
  final int section;

  Student(
      {this.id,
      required this.first_name,
      required this.last_name,
      required this.gender,
      required this.age,
      this.school,
      required this.student_id,
      required this.section});

  // Map JSON data to the School object
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
        id: json['id'],
        first_name: json['first_name'],
        last_name: json['last_name'],
        gender: json['gender'],
        student_id: json['student_id'],
        school: json['school'],
        section: json['section'],
        age: json['age']);
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': first_name,
      'last_name': last_name,
      'gender': gender,
      'student_id': student_id,
      'school': school,
      'section': section,
      'age': age,
    };
  }
}

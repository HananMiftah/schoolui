class Parent {
  final int? id;
  final String first_name;
  final String last_name;
  final String phone;
  final String email;
  final String stu_id;
  final int? school;
  final int? student;

  Parent(
      {this.id,
      required this.first_name,
      required this.last_name,
      required this.phone,
      required this.email,
      this.school,
      required this.stu_id,
      this.student});

  // Map JSON data to the School object
  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
        id: json['id'],
        first_name: json['first_name'],
        last_name: json['last_name'],
        phone: json['phone'],
        email: json['email'],
        school: json['school'],
        stu_id: json['stu_id'],
        student: json['student']);
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': first_name,
      'last_name': last_name,
      'phone': phone,
      'email': email,
      'school': school,
      'stu_id': stu_id,
      'student': student,
    };
  }
}

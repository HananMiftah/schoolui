class Teacher {
  final int? id;
  final String first_name;
  final String last_name;
  final String phone;
  final String email;
  final int? school;

  Teacher({
    this.id,
    required this.first_name,
    required this.last_name,
    required this.phone,
    required this.email,
    this.school,
  });

  // Map JSON data to the School object
  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      phone: json['phone'],
      email: json['email'],
      school: json['school'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'phone': phone,
      'school': school,
    };
  }
}

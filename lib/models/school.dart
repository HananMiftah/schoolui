class School {
  final int id;
  final String name;
  final String address;
  final String phone;
  final String email;

  School({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
  });

  // Map JSON data to the School object
  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
    );
  }
}

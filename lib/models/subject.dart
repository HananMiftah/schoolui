class Subject {
  final int id;
  final String subject;
  final int school;

  Subject({
    required this.id,
    required this.subject,
    required this.school,
  });

  // Map JSON data to the School object
  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      subject: json['subject'],
      school: json['school'],
    );
  }
}

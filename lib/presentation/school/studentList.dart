import 'package:flutter/material.dart';

import '../../models/students.dart';

class StudentList extends StatelessWidget {
  final List<Student> students;
  const StudentList({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            leading: const Icon(Icons.person, size: 40, color: Colors.orange),
            title: Text('${student.first_name} ${student.last_name}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            subtitle: Text('Age: ${student.age}\nGender: ${student.gender}'),
          ),
        );
      },
    );
  }
}

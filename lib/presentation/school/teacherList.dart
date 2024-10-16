import 'package:flutter/material.dart';
import 'package:schoolui/presentation/school/addTeacherPage.dart';

import '../../models/teacher.dart';

class TeacherList extends StatelessWidget {
  final List<Teacher> teachers;
  const TeacherList({super.key, required this.teachers});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: teachers.length,
      itemBuilder: (context, index) {
        final teacher = teachers[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTeacherPage(teacher: teacher),
              ),
            );
          },
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: const Icon(Icons.person, size: 40, color: Colors.orange),
              title: Text('${teacher.first_name} ${teacher.last_name}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle:
                  Text('Email: ${teacher.email}\nPhone: ${teacher.phone}'),
            ),
          ),
        );
      },
    );
  }
}

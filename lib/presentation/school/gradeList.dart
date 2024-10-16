import 'package:flutter/material.dart';
import '../../models/grade.dart'; // Import your model

class GradeList extends StatelessWidget {
  final List<Grade> grades;

  const GradeList({super.key, required this.grades});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: grades.length,
      itemBuilder: (context, index) {
        final grade = grades[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            leading: const Icon(
              Icons.school,
              size: 40,
              color: Colors.orange,
            ),
            title: Text(
              grade.grade_name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'School ID: ${grade.school}',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onPressed: () {
                // Handle click for more actions
              },
            ),
          ),
        );
      },
    );
  }
}

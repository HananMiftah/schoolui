import 'package:flutter/material.dart';

import '../../models/teacherSection.dart';

class StudentsPage extends StatelessWidget {
  final TeacherSection section;

  const StudentsPage({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${section.gradeName} - ${section.sectionName} Students'),
        backgroundColor: Colors.orange,
      ),
      body: const Center(
        child: Text('Display the list of students here'),
      ),
    );
  }
}

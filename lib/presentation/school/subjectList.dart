import 'package:flutter/material.dart';
import 'package:schoolui/models/subject.dart';

import 'subjectDialog.dart';

class SubjectList extends StatelessWidget {
  final List<Subject> subjects;

  const SubjectList({super.key, required this.subjects});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        final subject = subjects[index];
        return InkWell(
          onTap: () {
            showSubjectDialog(subject: subject, context);
          },
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: const Icon(
                Icons.subject,
                size: 40,
                color: Colors.orange,
              ),
              title: Text(
                subject.subject,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                onPressed: () {
                  // Handle click for more actions
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

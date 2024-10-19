import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolui/bloc/school_homepage/subject/subject_bloc.dart';
import 'package:schoolui/models/subject.dart';

import '../../bloc/school_homepage/grade/grade_bloc.dart';
import '../../bloc/school_homepage/grade/grade_event.dart';
import '../../bloc/school_homepage/subject/subject_event.dart';
import '../../models/grade.dart';

void showSubjectDialog(BuildContext context, {Subject? subject}) {
  final TextEditingController _subjectController = TextEditingController();

  if (subject != null) {
    _subjectController.text = subject.subject;
  }

  // Use addPostFrameCallback to ensure the dialog is shown after the current frame
  WidgetsBinding.instance.addPostFrameCallback((_) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(subject == null ? 'Add Subject' : 'Edit Subject'),
          content: TextField(
            controller: _subjectController,
            decoration: const InputDecoration(
              labelText: 'Subject Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            if (subject != null) // Show delete button only if grade exists
              TextButton(
                onPressed: () {
                  // Show confirmation dialog before deleting
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Delete Subject'),
                        content: const Text(
                            'Are you sure you want to delete this subject?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(
                                  context); // Close the confirmation dialog
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<SubjectBloc>().add(
                                  DeleteSubjectEvent(
                                      subject.id!)); // Trigger delete event
                              Navigator.pop(
                                  context); // Close the confirmation dialog
                              Navigator.pop(
                                  context); // Close the original dialog
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Delete'),
              ),
            TextButton(
              onPressed: () {
                final newSubjectName = _subjectController.text.trim();
                if (newSubjectName.isNotEmpty) {
                  Subject newSubject = subject ??
                      Subject(
                          subject: newSubjectName); // Create new grade object

                  if (subject == null) {
                    // Adding a new grade
                    context
                        .read<SubjectBloc>()
                        .add(AddSubjectEvent(newSubject));
                  } else {
                    // Editing existing grade
                    newSubject = Subject(
                        id: subject.id,
                        subject:
                            newSubjectName); // Update existing grade's name
                    context
                        .read<SubjectBloc>()
                        .add(UpdateSubjectEvent(newSubject));
                  }
                  Navigator.pop(context); // Close the dialog
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter a subject name')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  });
}

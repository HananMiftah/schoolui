import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/school_homepage/grade/grade_bloc.dart';
import '../../bloc/school_homepage/grade/grade_event.dart';
import '../../models/grade.dart';

void showGradeDialog(BuildContext context, {Grade? grade}) {
  final TextEditingController _gradeController = TextEditingController();

  if (grade != null) {
    _gradeController.text =
        grade.grade_name; // Prepopulate with existing grade name
  }

  // Use addPostFrameCallback to ensure the dialog is shown after the current frame
  WidgetsBinding.instance.addPostFrameCallback((_) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(grade == null ? 'Add Grade' : 'Edit Grade'),
          content: TextField(
            controller: _gradeController,
            decoration: const InputDecoration(
              labelText: 'Grade Name',
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
            if (grade != null) // Show delete button only if grade exists
              TextButton(
                onPressed: () {
                  // Show confirmation dialog before deleting
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Delete Grade'),
                        content: const Text(
                            'Are you sure you want to delete this grade?'),
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
                              context.read<GradeBloc>().add(DeleteGradeEvent(
                                  grade.id!)); // Trigger delete event
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
                final newGradeName = _gradeController.text.trim();
                if (newGradeName.isNotEmpty) {
                  Grade newGrade = grade ??
                      Grade(
                          grade_name: newGradeName); // Create new grade object

                  if (grade == null) {
                    // Adding a new grade
                    context.read<GradeBloc>().add(AddGradeEvent(newGrade));
                  } else {
                    // Editing existing grade
                    newGrade = Grade(
                        id: grade.id,
                        grade_name:
                            newGradeName); // Update existing grade's name
                    context.read<GradeBloc>().add(UpdateGradeEvent(newGrade));
                  }
                  Navigator.pop(context); // Close the dialog
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a grade name')),
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

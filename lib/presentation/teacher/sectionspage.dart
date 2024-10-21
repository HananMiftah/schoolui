import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/teacher/teacherpage_bloc.dart';
import '../../bloc/teacher/teacherpage_state.dart';
import '../../models/teacherSection.dart';
import 'studentspage.dart';

class SectionsPage extends StatelessWidget {
  const SectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherPageBloc, TeacherPageState>(
      builder: (context, state) {
        if (state is TeacherLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TeacherSectionsLoaded) {
          // Remove duplicate sections based on the 'section' field
          final uniqueSections = <TeacherSection>[];
          final seenSections = <String>{}; // Set to track seen section names

          for (var section in state.sections) {
            if (!seenSections.contains(section.sectionId)) {
              seenSections.add(section.sectionName); // Add section to seen set
              uniqueSections.add(section); // Add unique section to the list
            }
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: uniqueSections.length,
              itemBuilder: (context, index) {
                final section = uniqueSections[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Text(section.gradeName[0]),
                    ),
                    title: Text(
                      '${section.gradeName} - ${section.sectionName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentsPage(section: section),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        } else if (state is TeacherError) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}

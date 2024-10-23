import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolui/presentation/core/customShimmer.dart';
import '../../bloc/teacher/teacherpage_bloc.dart';
import '../../bloc/teacher/teacherpage_state.dart';
import '../../models/teacherSection.dart';
import 'studentspage.dart';

class SectionsPage extends StatelessWidget {
  const SectionsPage({super.key});

  // Function to remove duplicate sections based on 'gradeName' and 'sectionName'
  List<TeacherSection> _removeDuplicateSections(List<TeacherSection> sections) {
    final seenSections =
        <String>{}; // Set to store unique grade-section combinations
    return sections.where((section) {
      // Create a unique identifier by combining gradeName and sectionName
      final uniqueKey =
          '${section.gradeName}-${section.sectionName}'.toLowerCase();
      if (seenSections.contains(uniqueKey)) {
        return false; // If the combination already exists, skip this section
      } else {
        seenSections.add(uniqueKey); // Otherwise, add to seen set
        return true; // Include this section
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherPageBloc, TeacherPageState>(
      builder: (context, state) {
        if (state is TeacherLoading) {
          return const Center(child: CustomShimmer());
        } else if (state is TeacherSectionsLoaded) {
          // Apply the duplicate removal logic based on gradeName and sectionName
          final uniqueSections = _removeDuplicateSections(state.sections);

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

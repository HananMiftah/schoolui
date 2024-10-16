import 'package:flutter/material.dart';
import '../../models/section.dart'; // Import your Section model

class SectionList extends StatelessWidget {
  final List<Section> sections;

  const SectionList({super.key, required this.sections});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final section = sections[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            leading: Icon(
              Icons.class_,
              size: 40,
              color: Colors.orange,
            ),
            title: Text(
              '${section.grade_name}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Section: ${section.section}',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onPressed: () {
                // Handle click for more details
              },
            ),
          ),
        );
      },
    );
  }
}

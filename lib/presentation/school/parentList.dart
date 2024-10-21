import 'package:flutter/material.dart';
import 'package:schoolui/presentation/school/addParentPage.dart';

import '../../models/parent.dart';

class ParentList extends StatelessWidget {
  final List<Parent> parents;
  const ParentList({super.key, required this.parents});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: parents.length,
      itemBuilder: (context, index) {
        final parent = parents[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddParentPage(
                  parent: parent,
                  initialStudentId: parent.student,
                  initialStuId: parent.stu_id,
                ),
              ),
            );
          },
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: const Icon(Icons.people, size: 40, color: Colors.blue),
              title: Text('${parent.first_name} ${parent.last_name}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: Text(
                  'Phone: ${parent.phone}\nEmail: ${parent.email}\nStudent ID: ${parent.stu_id}'),
            ),
          ),
        );
      },
    );
  }
}

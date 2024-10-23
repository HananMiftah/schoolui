import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolui/bloc/teacher/teacherpage_bloc.dart';
import 'package:schoolui/bloc/teacher/teacherpage_event.dart';
import 'package:schoolui/presentation/core/customShimmer.dart';
import '../../bloc/teacher/sectionStudent/sectionStudent_bloc.dart';
import '../../bloc/teacher/sectionStudent/sectionStudent_event.dart';
import '../../bloc/teacher/sectionStudent/sectionStudent_state.dart';
import '../../models/teacherSection.dart';
import '../../models/students.dart';

class StudentsPage extends StatelessWidget {
  final TeacherSection section;

  const StudentsPage({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    context.read<SectionStudentBloc>().add(FetchStudents(section.sectionId));
    return WillPopScope(
      onWillPop: () async {
        // Trigger the LoadStudents event when navigating back
        context.read<TeacherPageBloc>().add(LoadTeacherSections());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('${section.gradeName} - ${section.sectionName} Students'),
          backgroundColor: Colors.orange,
        ),
        body: BlocBuilder<SectionStudentBloc, SectionStudentState>(
          builder: (context, state) {
            if (state is StudentLoading) {
              return const Center(child: CustomShimmer());
            } else if (state is StudentLoaded) {
              return _buildStudentList(state.students);
            } else if (state is StudentError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('No students available'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildStudentList(List<Student> students) {
    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.orange,
              child: Text(student.first_name[0]),
            ),
            title: Text(
              student.first_name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text('ID: ${student.student_id}'),
          ),
        );
      },
    );
  }
}

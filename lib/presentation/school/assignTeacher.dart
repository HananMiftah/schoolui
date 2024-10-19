import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolui/models/teacherAssignment.dart';
import 'package:schoolui/presentation/core/customShimmer.dart';
import '../../bloc/school_homepage/school/school_homepage_bloc.dart';
import '../../bloc/school_homepage/school/school_homepage_event.dart';
import '../../bloc/school_homepage/school/school_homepage_state.dart';
import '../../bloc/school_homepage/teacher/assign/assign_bloc.dart';
import '../../bloc/school_homepage/teacher/assign/assign_event.dart';
import '../../bloc/school_homepage/teacher/assign/assign_state.dart';
import '../../models/teacher.dart';
import '../../models/section.dart';
import '../../models/subject.dart';

class AssignTeacherPage extends StatefulWidget {
  @override
  _AssignTeacherPageState createState() => _AssignTeacherPageState();
}

class _AssignTeacherPageState extends State<AssignTeacherPage> {
  List<Teacher> _teachers = [];
  List<Section> _sections = [];
  List<Subject> _subjects = [];
  List<TeacherAssignment> _assignments = [];

  int? _selectedTeacher;
  int? _selectedSection;
  int? _selectedSubject;

  final Set<int> _selectedAssignments = {}; // Store selected assignment IDs.
  bool _isSelectionMode = false; // Track if selection mode is active.

  bool get isDataLoaded =>
      _teachers.isNotEmpty && _sections.isNotEmpty && _subjects.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    context.read<HomeBloc>().add(LoadTeachers());
    context.read<HomeBloc>().add(LoadSections());
    context.read<HomeBloc>().add(LoadSubjects());
    context.read<TeacherAssignmentBloc>().add(LoadAssignments());
  }

  String _getTeacherName(int teacherId) {
    final teacher = _teachers.firstWhere(
      (t) => t.id == teacherId,
      orElse: () => Teacher(
          id: 0,
          first_name: 'Unknown',
          last_name: 'Unknown',
          phone: "",
          email: ""),
    );
    return teacher.first_name; // Return teacher's first name
  }

  String _getSectionName(int sectionId) {
    final section = _sections.firstWhere(
      (s) => s.id == sectionId,
      orElse: () => Section(id: 0, section: 'Unknown', grade_name: ""),
    );
    String sectionDetail = '${section.grade_name} - ${section.section}';
    return sectionDetail; // Return section name
  }

  String _getSubjectName(int subjectId) {
    final subject = _subjects.firstWhere(
      (s) => s.id == subjectId,
      orElse: () => Subject(id: 0, subject: 'Unknown'),
    );
    return subject.subject; // Return subject name
  }

  bool _isDuplicateAssignment() {
    return _assignments.any((assignment) =>
        assignment.teacher == _selectedTeacher &&
        assignment.section == _selectedSection &&
        assignment.subject == _selectedSubject);
  }

  void _addAssignment(TeacherAssignment newAssignment) {
    if (!_isDuplicateAssignment()) {
      setState(() {
        _assignments.add(newAssignment);
      });
    }
  }

  void _toggleSelection(int assignmentId) {
    setState(() {
      if (_selectedAssignments.contains(assignmentId)) {
        _selectedAssignments.remove(assignmentId);
      } else {
        _selectedAssignments.add(assignmentId);
      }

      // Disable selection mode if no assignments are selected.
      if (_selectedAssignments.isEmpty) {
        _isSelectionMode = false;
      } else {
        _isSelectionMode =
            true; // Enable selection mode if any assignment is selected.
      }
    });
  }

  void _deleteSelectedAssignments() {
    final assignmentBloc = context.read<TeacherAssignmentBloc>();

    // Dispatch delete events for selected assignments.
    for (var assignmentId in _selectedAssignments) {
      assignmentBloc.add(DeleteTeacherAssignmentEvent(assignmentId));
    }

    // Clear the selection and refresh the list.
    setState(() {
      _selectedAssignments.clear(); // Clear selection after deletion.
      _isSelectionMode = false; // Exit selection mode.
    });

    // Reload assignments after deletion
    context.read<TeacherAssignmentBloc>().add(LoadAssignments());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Trigger the LoadStudents event when navigating back
        context.read<HomeBloc>().add(LoadTeachers());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isSelectionMode
              ? '${_selectedAssignments.length} Selected'
              : 'Assign Teacher to Section'),
          actions: [
            if (_isSelectionMode) ...[
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: _deleteSelectedAssignments,
              ),
            ],
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: MultiBlocListener(
                  listeners: [
                    BlocListener<HomeBloc, SchoolHomepageState>(
                        listener: (context, state) {
                      if (state is TeachersLoaded) {
                        setState(() {
                          _teachers = state.teachers;
                        });
                      } else if (state is SectionsLoaded) {
                        setState(() {
                          _sections = state.sections;
                        });
                      } else if (state is SubjectsLoaded) {
                        setState(() {
                          _subjects = state.subjects;
                        });
                      }
                    }),
                    BlocListener<TeacherAssignmentBloc, TeacherAssignmentState>(
                        listener: (context, state) {
                      if (state is AssignmentsLoaded) {
                        setState(() {
                          _assignments = state.assignments;
                        });
                      } else if (state is TeacherAssignmentSuccess) {
                        context
                            .read<TeacherAssignmentBloc>()
                            .add(LoadAssignments());
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Operation successfull!')),
                        );
                      } else if (state is TeacherAssignmentFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${state.error}')),
                        );
                      }
                    }),
                  ],
                  child: _buildBody(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 16),
          _buildDropdowns(),
          SizedBox(height: 32),
          _buildAssignButton(),
          _buildAssignmentsList(),
        ],
      ),
    );
  }

  Widget _buildAssignmentsList() {
    return _assignments.isNotEmpty
        ? Container(
            height: 450,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _assignments.length,
              itemBuilder: (context, index) {
                final assignment = _assignments[index];
                final teacherName = _getTeacherName(assignment.teacher);
                final sectionName = _getSectionName(assignment.section);
                final subjectName = _getSubjectName(assignment.subject);

                return GestureDetector(
                  onTap: () => _isSelectionMode
                      ? _toggleSelection(assignment.id!)
                      : null, // Toggle selection in selection mode.
                  onLongPress: () => _toggleSelection(assignment.id!),
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                    color: _selectedAssignments.contains(assignment.id!)
                        ? Colors.orange[100]
                        : Colors.white,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        teacherName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text(
                            sectionName,
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Subject: $subjectName',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.assignment),
                    ),
                  ),
                );
              },
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                'No assignments yet.',
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
            ),
          );
  }

  Widget _buildDropdowns() {
    return Column(
      children: [
        DropdownButtonFormField<int>(
          hint: Text('Select Teacher'),
          items: _teachers.map((teacher) {
            return DropdownMenuItem(
              value: teacher.id,
              child: Text(teacher.first_name),
            );
          }).toList(),
          onChanged: (value) => setState(() {
            _selectedTeacher = value;
          }),
        ),
        SizedBox(height: 16),
        DropdownButtonFormField<int>(
          hint: Text('Select Section'),
          items: _sections.map((section) {
            return DropdownMenuItem(
              value: section.id,
              child: Text(section.grade_name + ' - ' + section.section),
            );
          }).toList(),
          onChanged: (value) => setState(() {
            _selectedSection = value;
          }),
        ),
        SizedBox(height: 16),
        DropdownButtonFormField<int>(
          hint: Text('Select Subject'),
          items: _subjects.map((subject) {
            return DropdownMenuItem(
              value: subject.id,
              child: Text(subject.subject),
            );
          }).toList(),
          onChanged: (value) => setState(() {
            _selectedSubject = value;
          }),
        ),
      ],
    );
  }

  Widget _buildAssignButton() {
    return ElevatedButton(
      onPressed: _selectedTeacher != null &&
              _selectedSection != null &&
              _selectedSubject != null
          ? () {
              // Debugging: Print the selected values
              print('Selected Teacher: $_selectedTeacher');
              print('Selected Section: $_selectedSection');
              print('Selected Subject: $_selectedSubject');

              final newAssignment = TeacherAssignment(
                // Automatically generated
                teacher:
                    _selectedTeacher!, // Use null check only after confirming non-null
                section:
                    _selectedSection!, // Use null check only after confirming non-null
                subject:
                    _selectedSubject!, // Use null check only after confirming non-null
              );

              _addAssignment(newAssignment);
              context
                  .read<TeacherAssignmentBloc>()
                  .add(AssignTeacherEvent(newAssignment));
            }
          : () {
              // Optionally handle the case when the button is pressed without valid selections
              print(
                  'Please select a teacher, section, and subject before assigning.');
            },
      child: Text('Assign Teacher'),
    );
  }
}

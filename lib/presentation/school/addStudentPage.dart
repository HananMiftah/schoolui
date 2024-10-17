import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/school_homepage/school/school_homepage_bloc.dart';
import '../../bloc/school_homepage/school/school_homepage_event.dart';
import '../../bloc/school_homepage/school/school_homepage_state.dart';
import '../../bloc/school_homepage/student/student_bloc.dart';
import '../../bloc/school_homepage/student/student_event.dart';
import '../../bloc/school_homepage/student/student_state.dart';
import '../../models/students.dart';
import '../../models/section.dart';

class AddStudentPage extends StatefulWidget {
  final Student? student;
  final int? initialSection;
  const AddStudentPage({super.key, this.student, this.initialSection});

  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController studentIdController;
  late TextEditingController ageController;
  late String gender = 'Male'; // Default gender
  int? selectedSectionId; // Selected section

  @override
  void initState() {
    super.initState();
    firstNameController =
        TextEditingController(text: widget.student?.first_name ?? '');
    lastNameController =
        TextEditingController(text: widget.student?.last_name ?? '');
    studentIdController =
        TextEditingController(text: widget.student?.student_id ?? '');
    ageController =
        TextEditingController(text: widget.student?.age.toString() ?? '');
    gender = widget.student?.gender ?? 'Male';
    selectedSectionId = widget.initialSection;
    // Trigger loading of sections
    // Trigger LoadSections event to load sections
    context.read<HomeBloc>().add(LoadSections());
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    studentIdController.dispose();
    ageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final student = Student(
        id: widget.student?.id ?? 0, // Provide default id
        first_name: firstNameController.text,
        last_name: lastNameController.text,
        student_id: studentIdController.text,
        gender: gender,
        age: int.parse(ageController.text),
        section: selectedSectionId ?? 1, // Set selected section ID
      );

      final event = widget.student == null
          ? AddStudentEvent(student)
          : UpdateStudentEvent(student);

      context.read<StudentBloc>().add(event);
    }
  }

  void _deleteStudent() {
    if (widget.student != null) {
      context.read<StudentBloc>().add(DeleteStudentEvent(widget.student!.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Trigger the LoadStudents event when navigating back
        context.read<HomeBloc>().add(LoadStudents());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.student == null ? 'Add Student' : 'Edit Student'),
          actions: widget.student != null
              ? [
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await _showDeleteConfirmationDialog();
                      if (confirm) {
                        _deleteStudent();
                      }
                    },
                  ),
                ]
              : null,
        ),
        body: BlocListener<StudentBloc, StudentState>(
          listener: (context, state) {
            if (state is StudentSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Operation successful')),
              );
              Navigator.pop(context); // Navigate back to the previous page
            } else if (state is StudentFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.error}')),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildTextField('First Name', firstNameController),
                  const SizedBox(height: 16),
                  _buildTextField('Last Name', lastNameController),
                  const SizedBox(height: 16),
                  _buildTextField('Student ID', studentIdController),
                  const SizedBox(height: 16),
                  _buildTextField('Age', ageController,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 16),
                  _buildGenderDropdown(),
                  const SizedBox(height: 16),
                  _buildSectionDropdown(), // Section dropdown
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.orange,
                      ),
                      onPressed: _submitForm,
                      child: Text(
                        widget.student == null
                            ? 'Add Student'
                            : 'Update Student',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Student'),
            content:
                const Text('Are you sure you want to delete this student?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child:
                    const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ??
        false; // Default to false if dialog is dismissed
  }

  Widget _buildSectionDropdown() {
    return BlocConsumer<HomeBloc, SchoolHomepageState>(
      listener: (context, state) {
        if (state is SectionsLoaded && widget.initialSection != null) {
          // Ensure that the correct section is selected if editing
          final section = state.sections.firstWhere(
            (section) => section.id == widget.initialSection,
            orElse: () => state.sections.first, // Fallback to first section
          );
          setState(() {
            selectedSectionId = section.id;
          });
        }
      },
      builder: (context, state) {
        if (state is SectionsLoaded) {
          return DropdownButtonFormField<int>(
            value: selectedSectionId,
            decoration: InputDecoration(
              labelText: 'Section',
              border: const OutlineInputBorder(),
            ),
            onChanged: (int? newValue) {
              setState(() {
                selectedSectionId = newValue;
              });
            },
            items: state.sections.map<DropdownMenuItem<int>>((Section section) {
              return DropdownMenuItem<int>(
                value: section.id,
                child: Text('${section.grade_name} - ${section.section}'),
              );
            }).toList(),
            validator: (value) =>
                value == null ? 'Please select a section' : null,
          );
        } else if (state is HomeLoading) {
          return DropdownButtonFormField<int>(
            value: null,
            decoration: InputDecoration(
              labelText: 'Section',
              border: const OutlineInputBorder(),
            ),
            onChanged: null, // Disabled dropdown
            items: [], // Empty dropdown
          );
          // return const CircularProgressIndicator();
        } else {
          return const Text('Failed to load sections');
        }
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter $label' : null,
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: gender,
      decoration: InputDecoration(
        labelText: 'Gender',
        border: const OutlineInputBorder(),
      ),
      onChanged: (String? newValue) {
        setState(() {
          gender = newValue!;
        });
      },
      items: <String>['Male', 'Female']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

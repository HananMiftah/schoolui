import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolui/bloc/school_homepage/school/school_homepage_bloc.dart';
import 'package:schoolui/bloc/school_homepage/school/school_homepage_state.dart';
import '../../bloc/school_homepage/parent/parent_bloc.dart';
import '../../bloc/school_homepage/parent/parent_event.dart';
import '../../bloc/school_homepage/parent/parent_state.dart';
import '../../bloc/school_homepage/school/school_homepage_event.dart';
import '../../models/parent.dart';
import '../../models/students.dart';

class AddParentPage extends StatefulWidget {
  final Parent? parent;
  final int? initialStudentId;
  final String? initialStuId;

  const AddParentPage({super.key, this.parent, this.initialStudentId, this.initialStuId});

  @override
  _AddParentPageState createState() => _AddParentPageState();
}

class _AddParentPageState extends State<AddParentPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  String? studentIdController;
  int? selectedStudentId;
  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    firstNameController =
        TextEditingController(text: widget.parent?.first_name ?? '');
    lastNameController =
        TextEditingController(text: widget.parent?.last_name ?? '');
    phoneController = TextEditingController(text: widget.parent?.phone ?? '');
    emailController = TextEditingController(text: widget.parent?.email ?? '');

    selectedStudentId = widget.initialStudentId;
    studentIdController = widget.initialStuId;
    _loadStudents();
  }

  void _loadStudents() {
    context.read<HomeBloc>().add(LoadStudents());
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final parent = Parent(
        id: widget.parent?.id ?? 0,
        first_name: firstNameController.text,
        last_name: lastNameController.text,
        phone: phoneController.text,
        email: emailController.text,
        stu_id: studentIdController!,
        student: selectedStudentId ?? 1,
      );

      final event = widget.parent == null
          ? AddParentEvent(parent)
          : UpdateParentEvent(parent);

      context.read<ParentBloc>().add(event);
    }
  }

  void _deleteParent() {
    if (widget.parent != null) {
      context.read<ParentBloc>().add(DeleteParentEvent(widget.parent!.id!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<HomeBloc>().add(LoadParents());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.parent == null ? 'Add Parent' : 'Edit Parent'),
          actions: widget.parent != null
              ? [
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await _showDeleteConfirmationDialog();
                      if (confirm) {
                        _deleteParent();
                      }
                    },
                  ),
                ]
              : null,
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<ParentBloc, ParentState>(
              listener: (context, state) {
                if (state is ParentSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Operation successful')),
                  );
                  Navigator.pop(context); // Return parent
                } else if (state is ParentFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${state.error}')),
                  );
                }
              },
            ),
            BlocListener<HomeBloc, SchoolHomepageState>(
              listener: (context, state) {
                if (state is StudentsLoaded) {
                  setState(() {
                    students = state.students;
                  });
                }
              },
            ),
          ],
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
                  _buildTextField('Phone', phoneController),
                  const SizedBox(height: 16),
                  _buildTextField('Email', emailController,
                      keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 16),
                  _buildStudentDropdown(),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.orange,
                      ),
                      onPressed: _submitForm,
                      child: Text(
                        widget.parent == null ? 'Add Parent' : 'Update Parent',
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16),
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

  Widget _buildStudentDropdown() {
    return DropdownButtonFormField<int>(
      value: selectedStudentId,
      decoration: const InputDecoration(
        labelText: 'Student ID',
        border: OutlineInputBorder(),
      ),
      onChanged: (int? newValue) {
        setState(() {
          selectedStudentId = newValue;
          studentIdController = students
              .firstWhere((student) => student.id == newValue)
              .student_id;
        });
      },
      items: students.map<DropdownMenuItem<int>>((Student student) {
        return DropdownMenuItem<int>(
          value: student.id,
          child: Text(student.student_id),
        );
      }).toList(),
      validator: (value) => value == null ? 'Please select a student ID' : null,
    );
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Parent'),
            content: const Text('Are you sure you want to delete this parent?'),
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
        false;
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
}

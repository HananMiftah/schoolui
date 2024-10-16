import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/school_homepage/teacher/teacher_bloc.dart';
import '../../bloc/school_homepage/teacher/teacher_event.dart';
import '../../bloc/school_homepage/teacher/teacher_state.dart';
import '../../models/teacher.dart';

class AddTeacherPage extends StatefulWidget {
  final Teacher? teacher;

  const AddTeacherPage({super.key, this.teacher});

  @override
  _AddTeacherPageState createState() => _AddTeacherPageState();
}

class _AddTeacherPageState extends State<AddTeacherPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    firstNameController =
        TextEditingController(text: widget.teacher?.first_name ?? '');
    lastNameController =
        TextEditingController(text: widget.teacher?.last_name ?? '');
    emailController = TextEditingController(text: widget.teacher?.email ?? '');
    phoneController = TextEditingController(text: widget.teacher?.phone ?? '');
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final teacher = Teacher(
        id: widget.teacher?.id,
        first_name: firstNameController.text,
        last_name: lastNameController.text,
        email: emailController.text,
        phone: phoneController.text,
      );

      final event = widget.teacher == null
          ? AddTeacherEvent(teacher)
          : UpdateTeacherEvent(teacher);

      context.read<TeacherBloc>().add(event);
    }
  }

  void _deleteTeacher() {
    if (widget.teacher != null) {
      context.read<TeacherBloc>().add(DeleteTeacherEvent(widget.teacher!.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.teacher == null ? 'Add Teacher' : 'Edit Teacher'),
        actions: widget.teacher != null
            ? [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirm = await _showDeleteConfirmationDialog();
                    if (confirm) {
                      _deleteTeacher();
                    }
                  },
                ),
              ]
            : null,
      ),
      body: BlocListener<TeacherBloc, TeacherState>(
        listener: (context, state) {
          if (state is TeacherSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Operation successful')),
            );
            Navigator.pop(context); // Navigate back to the previous page
          } else if (state is TeacherFailure) {
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
                _buildTextField('Email', emailController,
                    keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 16),
                _buildTextField('Phone', phoneController,
                    keyboardType: TextInputType.phone),
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
                      widget.teacher == null ? 'Add Teacher' : 'Update Teacher',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
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

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Teacher'),
            content:
                const Text('Are you sure you want to delete this teacher?'),
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
}

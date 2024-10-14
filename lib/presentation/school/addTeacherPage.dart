import 'package:flutter/material.dart';

class Teacher {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String grade;
  final String section;

  Teacher({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.grade,
    required this.section,
  });
}

class AddTeacherPage extends StatefulWidget {
  final Teacher? teacher; // If a teacher is passed, this will be used for editing

  AddTeacherPage({this.teacher}); // Optional teacher parameter for editing

  @override
  _AddTeacherPageState createState() => _AddTeacherPageState();
}

class _AddTeacherPageState extends State<AddTeacherPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController gradeController;
  late TextEditingController sectionController;

  @override
  void initState() {
    super.initState();
    // If a teacher is passed, pre-fill the form with their data
    firstNameController = TextEditingController(text: widget.teacher?.firstName ?? '');
    lastNameController = TextEditingController(text: widget.teacher?.lastName ?? '');
    emailController = TextEditingController(text: widget.teacher?.email ?? '');
    phoneController = TextEditingController(text: widget.teacher?.phone ?? '');
    gradeController = TextEditingController(text: widget.teacher?.grade ?? '');
    sectionController = TextEditingController(text: widget.teacher?.section ?? '');
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    gradeController.dispose();
    sectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.teacher == null ? 'Add Teacher' : 'Edit Teacher'), // Change title based on mode
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // First Name
              TextFormField(
                controller: firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Last Name
              TextFormField(
                controller: lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter last name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Email
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Phone
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Grade
              TextFormField(
                controller: gradeController,
                decoration: InputDecoration(
                  labelText: 'Grade',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              // Section
              TextFormField(
                controller: sectionController,
                decoration: InputDecoration(
                  labelText: 'Section',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.teacher == null) {
                        // Adding new teacher logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('New Teacher Added')),
                        );
                      } else {
                        // Updating existing teacher logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Teacher Details Updated')),
                        );
                      }
                      Navigator.pop(context); // Go back to the list page
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.orange,
                  ),
                  child: Text(
                    widget.teacher == null ? 'Add Teacher' : 'Update Teacher', // Button label changes
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

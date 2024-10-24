import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:schoolui/bloc/school_homepage/school/school_homepage_bloc.dart';
import 'package:schoolui/bloc/school_homepage/school/school_homepage_state.dart';
import 'package:schoolui/bloc/school_homepage/school/school_homepage_event.dart';

import '../../models/parent.dart';
import '../../models/teacher.dart';

class CommunicationPage extends StatefulWidget {
  @override
  _CommunicationPageState createState() => _CommunicationPageState();
}

class _CommunicationPageState extends State<CommunicationPage> {
  String? _selectedOption;
  List<String> _selectedTeachers = [];
  List<String> _selectedParents = [];
  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Message'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Recipients",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedOption,
                hint: const Text("Select an option"),
                items: [
                  DropdownMenuItem(
                    value: "whole_teacher_parents",
                    child: const Text("Whole Teachers and Parents"),
                  ),
                  DropdownMenuItem(
                    value: "only_teachers",
                    child: const Text("Only Teachers"),
                  ),
                  DropdownMenuItem(
                    value: "only_parents",
                    child: const Text("Only Parents"),
                  ),
                  DropdownMenuItem(
                    value: "specific_teachers",
                    child: const Text("Specific Teachers"),
                  ),
                  DropdownMenuItem(
                    value: "specific_parents",
                    child: const Text("Specific Parents"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value;
                    // Clear previously selected teachers and parents when changing the option
                    _selectedTeachers.clear();
                    _selectedParents.clear();
                  });

                  // Trigger loading teachers or parents based on selection
                  if (value == "specific_teachers") {
                    context.read<HomeBloc>().add(LoadTeachers());
                  } else if (value == "specific_parents") {
                    context.read<HomeBloc>().add(LoadParents());
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Show additional UI based on selected option
              BlocBuilder<HomeBloc, SchoolHomepageState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Check which specific option is selected and load accordingly
                  if (_selectedOption == "specific_teachers" &&
                      state is TeachersLoaded) {
                    return _buildMultiSelectDropdownTeachers(state.teachers);
                  } else if (_selectedOption == "specific_parents" &&
                      state is ParentsLoaded) {
                    return _buildMultiSelectDropdownParents(state.parents);
                  }

                  return const SizedBox(); // Return empty widget if no data
                },
              ),

              const SizedBox(height: 20),
              _buildMessageInputBox(),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  if (_messageController.text.isNotEmpty) {
                    print('Message: ${_messageController.text}');
                    print(
                        'Send message to: Teachers: $_selectedTeachers, Parents: $_selectedParents');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a message!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Send Message',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMultiSelectDropdownTeachers(List<Teacher> teachers) {
    return MultiSelectDialogField(
      items: teachers
          .map((teacher) =>
              MultiSelectItem<String>(teacher.first_name, teacher.first_name))
          .toList(),
      title: const Text("Select Teachers"),
      selectedColor: Colors.orangeAccent,
      decoration: BoxDecoration(
        color: Colors.orangeAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.orangeAccent,
          width: 2,
        ),
      ),
      buttonText: const Text(
        "Select Teachers",
        style: TextStyle(
          color: Colors.orangeAccent,
          fontSize: 16,
        ),
      ),
      searchable: true,
      onConfirm: (values) {
        setState(() {
          _selectedTeachers = List<String>.from(values);
        });
      },
      chipDisplay: MultiSelectChipDisplay(
        onTap: (value) {
          setState(() {
            _selectedTeachers.remove(value);
          });
        },
      ),
    );
  }

  Widget _buildMultiSelectDropdownParents(List<Parent> parents) {
    return MultiSelectDialogField(
      items: parents
          .map((parent) =>
              MultiSelectItem<String>(parent.first_name, parent.first_name))
          .toList(),
      title: const Text("Select Parents"),
      selectedColor: Colors.orangeAccent,
      decoration: BoxDecoration(
        color: Colors.orangeAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.orangeAccent,
          width: 2,
        ),
      ),
      buttonText: const Text(
        "Select Parents",
        style: TextStyle(
          color: Colors.orangeAccent,
          fontSize: 16,
        ),
      ),
      searchable: true,
      onConfirm: (values) {
        setState(() {
          _selectedParents = List<String>.from(values);
        });
      },
      chipDisplay: MultiSelectChipDisplay(
        onTap: (value) {
          setState(() {
            _selectedParents.remove(value);
          });
        },
      ),
    );
  }

  Widget _buildMessageInputBox() {
    return TextField(
      controller: _messageController,
      decoration: InputDecoration(
        labelText: 'Type your message',
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolui/models/teacherSection.dart';
import 'package:schoolui/presentation/core/appdrawer.dart';
import 'package:schoolui/presentation/teacher/attendancepage.dart';
import 'package:schoolui/presentation/teacher/communicationspage.dart';
import 'sectionspage.dart';
import '../../bloc/teacher/teacherpage_bloc.dart';
import '../../bloc/teacher/teacherpage_event.dart';
import '../../bloc/teacher/teacherpage_state.dart';

class TeacherHomepage extends StatefulWidget {
  const TeacherHomepage({super.key});

  @override
  State<TeacherHomepage> createState() => _TeacherHomepageState();
}

class _TeacherHomepageState extends State<TeacherHomepage> {
  int _selectedIndex = 0;
  TeacherSection? _selectedSection;

  @override
  void initState() {
    super.initState();
    // Trigger loading of teacher sections on page load
    context.read<TeacherPageBloc>().add(LoadTeacherSections());
  }

  // When item is tapped, handle navigation or open dialog
  void _onItemTapped(int index) {
    if (index == 1) {
      _showSectionSelectionDialog(); // Attendance tab opens dialog
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // Screens for Bottom Navigation Bar
  static const List<Widget> _pages = <Widget>[
    SectionsPage(),
    CommunicationPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
        centerTitle: true,
      ),
      body: _selectedIndex == 1 && _selectedSection != null
          ? AttendancePage(
              section: _selectedSection!,
            ) // Display attendance section
          : _selectedIndex == 1
              ? _buildSelectSectionPrompt() // Show prompt if no section is selected
              : _pages[
                  _selectedIndex], // Display regular section or communication page
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            label: 'Sections',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Communication',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        onTap: _onItemTapped,
      ),
    );
  }

  // Build the prompt to select a section
  Widget _buildSelectSectionPrompt() {
    return const Center(
      child: Text('Please select a section to take attendance.'),
    );
  }

  // Show alert dialog with dropdown for section selection
  void _showSectionSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select a Section'),
          content: BlocBuilder<TeacherPageBloc, TeacherPageState>(
            builder: (context, state) {
              if (state is TeacherLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TeacherSectionsLoaded) {
                TeacherSection? selectedSectionInDialog;
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButton<TeacherSection>(
                          value: selectedSectionInDialog,
                          hint: const Text("Choose a section"),
                          isExpanded: true,
                          items: state.sections.map((section) {
                            return DropdownMenuItem<TeacherSection>(
                              value: section,
                              child: Text(
                                  '${section.gradeName} - ${section.sectionName} (${section.subjectName})'),
                            );
                          }).toList(),
                          onChanged: (TeacherSection? newValue) {
                            setState(() {
                              selectedSectionInDialog = newValue!;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: selectedSectionInDialog == null
                              ? null
                              : () {
                                  // Update selected section and close dialog
                                  setState(() {
                                    _selectedSection = selectedSectionInDialog;
                                  });
                                  Navigator.pop(context); // Close dialog
                                  _switchToAttendance(); // Update index and refresh
                                },
                          child: const Text('Go to Attendance'),
                        ),
                      ],
                    );
                  },
                );
              } else if (state is TeacherError) {
                return Center(
                  child: Text('Failed to load sections: ${state.message}'),
                );
              }
              return const Center(child: Text('Unknown error'));
            },
          ),
        );
      },
    );
  }

  // Switch to the Attendance section and update the UI
  void _switchToAttendance() {
    setState(() {
      _selectedIndex = 1; // Set index to attendance
    });
  }
}

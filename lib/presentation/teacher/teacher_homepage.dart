import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolui/models/teacherSection.dart';
import 'package:schoolui/presentation/core/appdrawer.dart';
import 'package:schoolui/presentation/teacher/attendancepage.dart';
import 'package:schoolui/presentation/teacher/communicationspage.dart';

import '../../bloc/teacher/teacherpage_bloc.dart';
import '../../bloc/teacher/teacherpage_event.dart';
import '../../bloc/teacher/teacherpage_state.dart';
import 'sectionspage.dart';

class TeacherHomepage extends StatefulWidget {
  const TeacherHomepage({super.key});

  @override
  State<TeacherHomepage> createState() => _TeacherHomepageState();
}

class _TeacherHomepageState extends State<TeacherHomepage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Trigger the loading of teacher sections on page load
    context.read<TeacherPageBloc>().add(LoadTeacherSections());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Screens for Bottom Navigation Bar
  static const List<Widget> _pages = <Widget>[
    SectionsPage(),
    AttendancePage(),
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
      body: _pages[_selectedIndex],
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
}

// Sections Page

// Students Page

// Attendance Page

// Communication Page

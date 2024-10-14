import 'package:flutter/material.dart';
import 'package:schoolui/presentation/core/appdrawer.dart';
import 'package:schoolui/presentation/school/addTeacherPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTabIndex = 0; // To track the current tab

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Two tabs: Teachers and Students
      child: Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          
          title: Text('Manage'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  size: 30,
                ),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            TabBar(
              onTap: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              tabs: [
                Tab(text: 'Teachers'),
                Tab(text: 'Students'),
                Tab(text: 'Grades'),
                Tab(text: 'Sections'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Tab 1: List of Teachers
                  TeacherList(),
                  // Tab 2: List of Students
                  StudentList(),
                  TeacherList(),
                  // Tab 2: List of Students
                  StudentList(),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: _getFloatingActionButton(),
      ),
    );
  }

  Widget? _getFloatingActionButton() {
    switch (_selectedTabIndex) {
      case 0:
        return FloatingActionButton(
          onPressed: () {
            // Action for adding a teacher
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTeacherPage()),
            );
          },
          child: Icon(Icons.add),
          tooltip: 'Add Teacher',
        );
      case 1:
        return FloatingActionButton(
          onPressed: () {
            // Action for adding a student
            // For now, just showing a snackbar as placeholder
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Add Student button pressed')),
            );
          },
          child: Icon(Icons.add),
          tooltip: 'Add Student',
        );
      case 2:
        return FloatingActionButton(
          onPressed: () {
            // Action for adding a grade
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Add Grade button pressed')),
            );
          },
          child: Icon(Icons.add),
          tooltip: 'Add Grade',
        );
      case 3:
        return FloatingActionButton(
          onPressed: () {
            // Action for adding a section
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Add Section button pressed')),
            );
          },
          child: Icon(Icons.add),
          tooltip: 'Add Section',
        );
      default:
        return null;
    }
  }
}

final List<Map<String, String>> studentData = [
  {
    'firstName': 'Alice',
    'lastName': 'Johnson',
    'phone': '111-222-3333',
    'email': 'alice.johnson@example.com',
  },
  {
    'firstName': 'Bob',
    'lastName': 'Williams',
    'phone': '444-555-6666',
    'email': 'bob.williams@example.com',
  },
  {
    'firstName': 'Alice',
    'lastName': 'Johnson',
    'phone': '111-222-3333',
    'email': 'alice.johnson@example.com',
  },
  {
    'firstName': 'Bob',
    'lastName': 'Williams',
    'phone': '444-555-6666',
    'email': 'bob.williams@example.com',
  },
  {
    'firstName': 'Alice',
    'lastName': 'Johnson',
    'phone': '111-222-3333',
    'email': 'alice.johnson@example.com',
  },
  {
    'firstName': 'Bob',
    'lastName': 'Williams',
    'phone': '444-555-6666',
    'email': 'bob.williams@example.com',
  },
  {
    'firstName': 'Alice',
    'lastName': 'Johnson',
    'phone': '111-222-3333',
    'email': 'alice.johnson@example.com',
  },
  {
    'firstName': 'Bob',
    'lastName': 'Williams',
    'phone': '444-555-6666',
    'email': 'bob.williams@example.com',
  },
  // Add more students as needed
];

// Teacher ListView
class TeacherList extends StatelessWidget {
  final List<Teacher> teachers = [
    Teacher(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        phone: '1234567890',
        grade: '10',
        section: 'A'),
    Teacher(
        firstName: 'Jane',
        lastName: 'Smith',
        email: 'jane@example.com',
        phone: '0987654321',
        grade: '11',
        section: 'B'),
    Teacher(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        phone: '1234567890',
        grade: '10',
        section: 'A'),
    Teacher(
        firstName: 'Jane',
        lastName: 'Smith',
        email: 'jane@example.com',
        phone: '0987654321',
        grade: '11',
        section: 'B'),
    Teacher(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        phone: '1234567890',
        grade: '10',
        section: 'A'),
    Teacher(
        firstName: 'Jane',
        lastName: 'Smith',
        email: 'jane@example.com',
        phone: '0987654321',
        grade: '11',
        section: 'B'),
    Teacher(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        phone: '1234567890',
        grade: '10',
        section: 'A'),
    Teacher(
        firstName: 'Jane',
        lastName: 'Smith',
        email: 'jane@example.com',
        phone: '0987654321',
        grade: '11',
        section: 'B'),
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: teachers.length,
      itemBuilder: (context, index) {
        final teacher = teachers[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTeacherPage(teacher: teacher),
              ),
            );
          },
          child: Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: Icon(Icons.person, size: 40, color: Colors.orange),
              title: Text(
                '${teacher.firstName} ${teacher.lastName}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text('Phone: ${teacher.phone}'),
                  Text('Email: ${teacher.email}'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Student ListView
class StudentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: studentData.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {},
          child: Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: Icon(Icons.person, size: 40, color: Colors.orange),
              title: Text(
                '${studentData[index]['firstName']} ${studentData[index]['lastName']}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text('Phone: ${studentData[index]['phone']}'),
                  Text('Email: ${studentData[index]['email']}'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

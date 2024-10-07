import 'package:flutter/material.dart';
import 'package:schoolui/presentation/Teacher/addTeacherPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Teachers and Students
      child: Scaffold(
        drawer: const Drawer(
          child: Column(
            children: [
              SizedBox(
                height: 90,
              ),
              Text("This is drawer"),
            ],
          ),
        ),
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
                    )))
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => AddTeacherPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange, // Set the button color
                    ),
                    child: Text('Add Teacher'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => AddTeacherPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange, // Set the button color
                    ),
                    child: Text('Add Student'),
                  ),
                ],
              ),
            ),
            TabBar(
              tabs: [
                Tab(text: 'Teachers'),
                Tab(text: 'Students'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Tab 1: List of Teachers
                  TeacherList(),
                  // Tab 2: List of Students
                  StudentList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy teacher data
final List<Map<String, String>> teacherData = [
  {
    'firstName': 'John',
    'lastName': 'Doe',
    'phone': '123-456-7890',
    'email': 'john.doe@example.com',
  },
  {
    'firstName': 'Jane',
    'lastName': 'Smith',
    'phone': '987-654-3210',
    'email': 'jane.smith@example.com',
  },
  {
    'firstName': 'John',
    'lastName': 'Doe',
    'phone': '123-456-7890',
    'email': 'john.doe@example.com',
  },
  {
    'firstName': 'Jane',
    'lastName': 'Smith',
    'phone': '987-654-3210',
    'email': 'jane.smith@example.com',
  },
  {
    'firstName': 'John',
    'lastName': 'Doe',
    'phone': '123-456-7890',
    'email': 'john.doe@example.com',
  },
  {
    'firstName': 'Jane',
    'lastName': 'Smith',
    'phone': '987-654-3210',
    'email': 'jane.smith@example.com',
  },
  {
    'firstName': 'John',
    'lastName': 'Doe',
    'phone': '123-456-7890',
    'email': 'john.doe@example.com',
  },
  {
    'firstName': 'Jane',
    'lastName': 'Smith',
    'phone': '987-654-3210',
    'email': 'jane.smith@example.com',
  },
  // Add more teachers as needed
];

// Dummy student data
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

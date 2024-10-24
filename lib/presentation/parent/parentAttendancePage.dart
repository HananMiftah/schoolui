import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../bloc/parent/parentpage_bloc.dart';
import '../../bloc/parent/parentpage_event.dart';
import '../../bloc/parent/parentpage_state.dart';
import '../../models/students.dart';

class ParentAttendancePage extends StatefulWidget {
  const ParentAttendancePage({super.key});

  @override
  State<ParentAttendancePage> createState() => _ParentAttendancePageState();
}

class _ParentAttendancePageState extends State<ParentAttendancePage> {
  DateTime _selectedDate = DateTime.now(); // Set default date to today
  Student? _selectedStudent; // Variable to hold the selected student
  List<Student> _students = []; // List to hold loaded students

  @override
  void initState() {
    super.initState();
    // Load students when the page initializes
    context.read<ParentPageBloc>().add(LoadParentStudents());
  }

  Future<DateTime?> _selectDate(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.orange,
            colorScheme: ColorScheme.light(primary: Colors.orange),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child ?? const Text(''),
        );
      },
    );
  }

  void _fetchAttendance() {
    if (_selectedStudent != null) {
      context.read<ParentPageBloc>().add(LoadStudentAttendance(
          _selectedStudent!.id!,
          DateFormat('yyyy-MM-dd').format(_selectedDate)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParentPageBloc, ParentPageState>(
      builder: (context, state) {
        if (state is ParentLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ParentStudentsLoaded) {
          _students = state.students; // Get students from the loaded state
        } else if (state is ParentError) {
          return Center(child: Text(state.message));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButton<Student>(
                          value: _selectedStudent,
                          hint: const Text('Select Your Student'),
                          onChanged: (Student? newValue) {
                            setState(() {
                              _selectedStudent = newValue;
                              // Clear previous attendance when student changes
                            });
                            _fetchAttendance(); // Fetch attendance for the new student
                          },
                          items: _students.map<DropdownMenuItem<Student>>(
                              (Student student) {
                            return DropdownMenuItem<Student>(
                              value: student,
                              child: Text(
                                  '${student.first_name} ${student.last_name}'),
                            );
                          }).toList(),
                          isExpanded: true,
                        ),
                      ),
                      const SizedBox(width: 16), // Add spacing
                      ElevatedButton(
                        onPressed: () async {
                          final selectedDate = await _selectDate(context);
                          if (selectedDate != null) {
                            setState(() {
                              _selectedDate = selectedDate;
                            });
                            _fetchAttendance(); // Fetch attendance for the selected date
                          }
                        },
                        child: Text(
                          DateFormat.yMMMMd().format(_selectedDate),
                          style: const TextStyle(color: Colors.orange),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Display attendance if available
                  Expanded(
                    child: AttendanceList(
                      selectedStudent: _selectedStudent,
                      selectedDate: _selectedDate,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AttendanceList extends StatelessWidget {
  final Student? selectedStudent;
  final DateTime selectedDate;

  const AttendanceList({
    Key? key,
    required this.selectedStudent,
    required this.selectedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParentPageBloc, ParentPageState>(
      builder: (context, state) {
        if (state is ParentAttendanceLoaded) {
          final attendanceRecords = state.attendanceRecords;

          return ListView.builder(
            itemCount: attendanceRecords.length,
            itemBuilder: (context, index) {
              final record = attendanceRecords[index];
              return ListTile(
                title: Text(
                    '${record.grade} - ${record.section} - ${record.subject} - ${record.status}'),
              );
            },
          );
        } else if (state is ParentError) {
          return Center(child: Text(state.message));
        }

        return const Text('No attendance records found.');
      },
    );
  }
}

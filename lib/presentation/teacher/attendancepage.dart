import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:schoolui/bloc/teacher/sectionStudent/sectionStudent_bloc.dart';
import 'package:schoolui/bloc/teacher/sectionStudent/sectionStudent_event.dart';
import 'package:schoolui/bloc/teacher/sectionStudent/sectionStudent_state.dart';
import '../../bloc/teacher/attendance/attendance_bloc.dart';
import '../../bloc/teacher/attendance/attendance_event.dart';
import '../../bloc/teacher/attendance/attendance_state.dart';
import '../../models/teacherSection.dart';
import '../../models/students.dart';
import '../../presentation/core/customShimmer.dart';

class AttendancePage extends StatefulWidget {
  final TeacherSection section;

  const AttendancePage({super.key, required this.section});

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final Map<int, String> _attendanceStatus = {};
  final List<String> _attendanceOptions = ["Present", "Absent", "Late"];
  DateTime _selectedDate = DateTime.now(); // Default to today
  late TeacherSection _currentSection;

  @override
  void initState() {
    super.initState();
    _currentSection = widget.section; // Initialize with the current section
    // Fetch attendance for the current date
    _fetchAttendanceForDate(_selectedDate);
  }

  void _fetchAttendanceForDate(DateTime date) {
    context.read<AttendanceBloc>().add(FetchAttendance(
          _currentSection.id,
          date,
        ));
  }

  void _fetchStudentsForSection() {
    context.read<SectionStudentBloc>().add(FetchStudents(_currentSection.sectionId));
  }

  @override
  void didUpdateWidget(covariant AttendancePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the section has changed
    if (oldWidget.section.id != widget.section.id) {
      // Update the current section and fetch attendance for the new section
      setState(() {
        _currentSection = widget.section;
      });
      _fetchAttendanceForDate(_selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${_currentSection.gradeName} - ${_currentSection.sectionName} (${_currentSection.subjectName})',
        ),
        backgroundColor: Colors.orange,
        actions: [
          TextButton(
            onPressed: () async {
              // Show the date picker
              final selectedDate = await _selectDate(context);
              if (selectedDate != null) {
                setState(() {
                  _selectedDate = selectedDate;
                });
                // Fetch attendance for the selected date
                _fetchAttendanceForDate(_selectedDate);
              }
            },
            child: Text(
              DateFormat.yMMMMd()
                  .format(_selectedDate), // Display the selected date
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
          if (state is AttendanceLoading) {
            return const Center(child: CustomShimmer());
          } else if (state is AttendanceLoaded) {
            if (state.attendanceList.isEmpty) {
              // Fetch students if attendanceList is empty
              _fetchStudentsForSection();
              return BlocBuilder<SectionStudentBloc, SectionStudentState>(
                builder: (context, studentState) {
                  if (studentState is StudentLoaded) {
                    List<Student> students = studentState.students;

                    // Initialize attendance status as Present for all students
                    for (var student in students) {
                      _attendanceStatus[student.id!] = _attendanceOptions[0];
                    }
                    return _buildAttendanceList(students);
                  } else if (studentState is StudentError) {
                    return Center(child: Text(studentState.message));
                  } else {
                    return const Center(child: Text('No students available'));
                  }
                },
              );
            } else {
              // Initialize attendance status with loaded attendance
              for (var attendance in state.attendanceList) {
                _attendanceStatus[attendance.id] = attendance.status;
              }

              // Extract students based on the attendance list
              List<Student> students = state.attendanceList.map((attendance) {
                return Student(
                    id: attendance.id,
                    first_name: attendance.studentFirst,
                    last_name: attendance.studentLast,
                    age: 0,
                    section: 0,
                    gender: "",
                    student_id: "");
              }).toList();

              return _buildAttendanceList(students);
            }
          } else if (state is AttendanceError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('No students available'));
          }
        },
      ),
    );
  }

  // Date picker to select attendance date
  Future<DateTime?> _selectDate(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
  }

  // Build the attendance list with the updated card design
  Widget _buildAttendanceList(List<Student> students) {
    final isToday = DateFormat('yyyy-MM-dd').format(_selectedDate) ==
        DateFormat('yyyy-MM-dd').format(DateTime.now());

    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        final studentId = student.id ?? -1; // Handle null ID
        if (studentId == -1) {
          return const SizedBox.shrink(); // Skip if no ID
        }

        // Default to Present if not set
        _attendanceStatus.putIfAbsent(studentId, () => _attendanceOptions[0]);

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(student.first_name,
                  style: const TextStyle(fontSize: 18)),
              trailing: isToday
                  ? DropdownButton<String>(
                      value: _attendanceStatus[studentId],
                      items: _attendanceOptions.map((String status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: (String? newStatus) {
                        setState(() {
                          _attendanceStatus[studentId] = newStatus!;
                        });
                      },
                    )
                  : Text(
                      _attendanceStatus[studentId] ?? "Unknown",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}

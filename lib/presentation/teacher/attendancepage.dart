import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:schoolui/bloc/teacher/sectionStudent/sectionStudent_bloc.dart';
import 'package:schoolui/bloc/teacher/sectionStudent/sectionStudent_event.dart';
import 'package:schoolui/bloc/teacher/sectionStudent/sectionStudent_state.dart';
import '../../bloc/teacher/attendance/attendance_bloc.dart';
import '../../bloc/teacher/attendance/attendance_event.dart';
import '../../bloc/teacher/attendance/attendance_state.dart';
import '../../models/attendance.dart';
import '../../models/teacherSection.dart';
import '../../models/students.dart';
import '../../presentation/core/customShimmer.dart';

// At the top of your file
class AttendancePage extends StatefulWidget {
  final TeacherSection section;

  const AttendancePage({super.key, required this.section});

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final Map<int, String> _attendanceStatus = {};
  final List<String> _attendanceOptions = ["PRESENT", "ABSENT", "LATE"];
  DateTime _selectedDate = DateTime.now();
  late TeacherSection _currentSection;
  late List<Student> _students = [];
  bool _isStudentsFetched = false; // Flag to check if students are fetched

  @override
  void initState() {
    super.initState();
    _currentSection = widget.section;
    _fetchAttendanceForDate(_selectedDate);
  }

  void _fetchAttendanceForDate(DateTime date) {
    context.read<AttendanceBloc>().add(FetchAttendance(
          _currentSection.id,
          date,
        ));
  }

  void _fetchStudentsForSection() {
    if (!_isStudentsFetched) {
      // Only fetch if not already done
      context
          .read<SectionStudentBloc>()
          .add(FetchStudents(_currentSection.sectionId));
    }
  }

  @override
  void didUpdateWidget(covariant AttendancePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.section.id != widget.section.id) {
      setState(() {
        _currentSection = widget.section;
        _isStudentsFetched = false; // Reset flag when section changes
      });
      _fetchAttendanceForDate(_selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isToday = DateFormat('yyyy-MM-dd').format(_selectedDate) ==
        DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${_currentSection.gradeName} - ${_currentSection.sectionName} (${_currentSection.subjectName})',
        ),
        backgroundColor: Colors.orange,
        actions: [
          TextButton(
            onPressed: () async {
              final selectedDate = await _selectDate(context);
              if (selectedDate != null) {
                setState(() {
                  _selectedDate = selectedDate;
                });
                _fetchAttendanceForDate(_selectedDate);
              }
            },
            child: Text(
              DateFormat.yMMMMd().format(_selectedDate),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: BlocListener<AttendanceBloc, AttendanceState>(
        listener: (context, state) {
          if (state is AttendancePosted) {
            // Attendance saved successfully, fetch attendance for the current date again
            _fetchAttendanceForDate(_selectedDate);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Attendance successfully saved!'),
                duration: Duration(
                    seconds: 2), // Duration the snackbar will be visible
                backgroundColor: Colors.green, // Snackbar background color
              ),
            );
          }
        },
        child: BlocBuilder<AttendanceBloc, AttendanceState>(
          builder: (context, state) {
            if (state is AttendanceLoading) {
              return const Center(child: CustomShimmer());
            } else if (state is AttendanceLoaded) {
              if (state.attendanceList.isEmpty) {
                _fetchStudentsForSection();
                return BlocBuilder<SectionStudentBloc, SectionStudentState>(
                  builder: (context, studentState) {
                    if (studentState is StudentLoaded) {
                      _students = studentState.students;
                      _initializeAttendanceStatus();
                      return _buildAttendanceList(_students);
                    } else if (studentState is StudentError) {
                      return Center(child: Text(studentState.message));
                    } else if (studentState is StudentLoading) {
                      return CustomShimmer();
                    }
                    return const Center(child: Text('No students available'));
                  },
                );
              } else {
                _initializeAttendanceStatusFromLoaded(state);
                return _buildAttendanceList(_students);
              }
            } else if (state is AttendanceError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('No students available'));
          },
        ),
      ),
      bottomNavigationBar: isToday
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _saveAttendance,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: const Text(
                  'Save Attendance',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          : null,
    );
  }

  // Initialize attendance status based on loaded data
  void _initializeAttendanceStatus() {
    _attendanceStatus.clear(); // Clear previous statuses
    for (var student in _students) {
      _attendanceStatus[student.id!] =
          _attendanceOptions[0]; // Default to PRESENT
    }
    _isStudentsFetched = true; // Mark students as fetched
  }

  void _initializeAttendanceStatusFromLoaded(AttendanceLoaded state) {
    _attendanceStatus.clear(); // Clear previous statuses
    for (var attendance in state.attendanceList) {
      _attendanceStatus[attendance.studentId] = attendance.status;
    }

    // Create the students list based on the attendance list
    _students = state.attendanceList.map((attendance) {
      return Student(
        id: attendance.studentId,
        first_name: attendance.studentFirst,
        last_name: attendance.studentLast,
        age: 0,
        section: 0,
        gender: "",
        student_id: "",
      );
    }).toList();
  }

  Future<DateTime?> _selectDate(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
  }

  Widget _buildAttendanceList(List<Student> students) {
    final isToday = DateFormat('yyyy-MM-dd').format(_selectedDate) ==
        DateFormat('yyyy-MM-dd').format(DateTime.now());

    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        final studentId = student.id ?? -1;
        if (studentId == -1) {
          return const SizedBox.shrink();
        }

        _attendanceStatus.putIfAbsent(studentId, () => _attendanceOptions[0]);
        ValueNotifier<String> selectedStatus =
            ValueNotifier<String>(_attendanceStatus[studentId]!);

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(student.first_name,
                  style: const TextStyle(fontSize: 18)),
              trailing: isToday
                  ? ValueListenableBuilder<String>(
                      valueListenable: selectedStatus,
                      builder: (context, value, child) {
                        return DropdownButton<String>(
                          value: value,
                          items: _attendanceOptions.map((String status) {
                            return DropdownMenuItem<String>(
                              value: status,
                              child: Text(status),
                            );
                          }).toList(),
                          onChanged: (String? newStatus) {
                            if (newStatus != null) {
                              selectedStatus.value = newStatus;
                              _attendanceStatus[studentId] = newStatus;
                            }
                          },
                        );
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

  void _saveAttendance() {
    List<AttendancePost> attendanceList = [];
    _attendanceStatus.forEach((studentId, status) {
      attendanceList.add(AttendancePost(
          studentId: studentId,
          date: DateFormat('yyyy-MM-dd').format(_selectedDate),
          status: status,
          sectionId: _currentSection.id));
    });

    context.read<AttendanceBloc>().add(PostAttendance(attendanceList));
    print("Saving attendance...");
  }
}

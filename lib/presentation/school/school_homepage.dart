import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolui/bloc/school_homepage/school/school_homepage_bloc.dart';
import 'package:schoolui/bloc/school_homepage/school/school_homepage_state.dart';
import 'package:schoolui/bloc/school_homepage/teacher/teacher_bloc.dart';
import 'package:schoolui/bloc/school_homepage/teacher/teacher_event.dart';
import 'package:schoolui/bloc/school_homepage/teacher/teacher_state.dart';
import 'package:schoolui/models/students.dart';
import 'package:schoolui/presentation/core/appdrawer.dart';
import 'package:schoolui/presentation/core/customShimmer.dart';
import 'package:schoolui/presentation/school/gradeList.dart';
import 'package:schoolui/presentation/school/sectionList.dart';

import '../../bloc/school_homepage/school/school_homepage_event.dart';
import '../../models/teacher.dart';
import 'addTeacherPage.dart';
import 'studentList.dart';
import 'teacherList.dart';
// import 'addTeacherPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTabIndex = 0; // Track the current tab

  @override
  void initState() {
    super.initState();
    // Load teachers by default
    context.read<HomeBloc>().add(LoadTeachers());
    // context.read<HomeBloc>().add(LoadSchool());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TeacherBloc, TeacherState>(
      listener: (context, state) {
        if (state is TeacherSuccess) {
          // Reload teachers when the operation is successful
          context.read<HomeBloc>().add(LoadTeachers());
        }
        if (state is TeacherUploading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Uploading file...'),
              duration:
                  Duration(minutes: 5), // Keep SnackBar showing until dismissed
            ),
          );
        } else if (state is TeacherUploadSuccess) {
          context.read<HomeBloc>().add(LoadTeachers());
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('File uploaded successfully!')),
          );
        } else if (state is TeacherUploadFailure) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload failed: ${state.error}')),
          );
        }
      },
      child: DefaultTabController(
        length: 4, // 4 tabs: Teachers, Students, Grades, Sections
        child: Scaffold(
          drawer: const AppDrawer(),
          appBar: AppBar(
            title: const Text('Manage'),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search, size: 30),
              ),
            ],
          ),
          body: Column(
            children: [
              TabBar(
                onTap: (index) {
                  setState(() {
                    _selectedTabIndex = index;
                  });
                  if (index == 0) {
                    context.read<HomeBloc>().add(LoadTeachers());
                  } else if (index == 1) {
                    context.read<HomeBloc>().add(LoadStudents());
                  } else if (index == 2) {
                    context.read<HomeBloc>().add(LoadGrades());
                  } else if (index == 3) {
                    context.read<HomeBloc>().add(LoadSections());
                  }
                },
                tabs: const [
                  Tab(text: 'Teachers'),
                  Tab(text: 'Students'),
                  Tab(text: 'Grades'),
                  Tab(text: 'Sections'),
                ],
              ),
              Expanded(
                child: BlocBuilder<HomeBloc, SchoolHomepageState>(
                  builder: (context, state) {
                    if (state is HomeLoading) {
                      return const Center(child: CustomShimmer());
                    } else if (state is TeachersLoaded) {
                      return TeacherList(teachers: state.teachers);
                    } else if (state is StudentsLoaded) {
                      return StudentList(students: state.students);
                    } else if (state is GradesLoaded) {
                      return GradeList(grades: state.grades);
                    } else if (state is SectionsLoaded) {
                      return SectionList(sections: state.sections);
                    } else if (state is HomeError) {
                      return Center(child: Text(state.error));
                    }
                    return RefreshIndicator(
                        onRefresh: () async {
                          context.read<HomeBloc>().add(LoadTeachers());
                        },
                        child: Container());
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: _getFloatingActionButton(),
        ),
      ),
    );
  }

  void _showUploadProgress(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BlocBuilder<TeacherBloc, TeacherState>(
          builder: (context, state) {
            if (state is TeacherUploadProgress) {
              return AlertDialog(
                title: const Text('Uploading...'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LinearProgressIndicator(value: state.progress),
                    const SizedBox(height: 10),
                    Text('${(state.progress * 100).toStringAsFixed(1)}%'),
                  ],
                ),
              );
            }
            return const SizedBox(); // Avoid returning null
          },
        );
      },
    );
  }

  Widget? _getFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        if (_selectedTabIndex == 0) {
          _showAddOptions();
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => AddTeacherPage()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Floating action for tab $_selectedTabIndex')),
          );
        }
      },
      child: const Icon(Icons.add),
    );
  }

  void _showAddOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person_add),
                title: const Text('Add Teacher'),
                onTap: () {
                  Navigator.pop(context); // Close the modal
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddTeacherPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.upload_file),
                title: const Text('Upload Excel File'),
                onTap: () {
                  Navigator.pop(context); // Close the modal
                  _uploadExcelFile(); // Handle file upload
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadExcelFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      final file = File(result.files.single.path!);
      context.read<TeacherBloc>().add(UploadTeacherExcel(file));
    }
  }
}

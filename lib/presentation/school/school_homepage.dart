import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolui/bloc/school_homepage/grade/grade_bloc.dart';
import 'package:schoolui/bloc/school_homepage/grade/grade_state.dart';
import 'package:schoolui/bloc/school_homepage/school/school_homepage_bloc.dart';
import 'package:schoolui/bloc/school_homepage/school/school_homepage_state.dart';
import 'package:schoolui/bloc/school_homepage/section/section_bloc.dart';
import 'package:schoolui/bloc/school_homepage/section/section_state.dart';
import 'package:schoolui/bloc/school_homepage/student/student_bloc.dart';
import 'package:schoolui/bloc/school_homepage/subject/subject_bloc.dart';
import 'package:schoolui/bloc/school_homepage/subject/subject_state.dart';
import 'package:schoolui/bloc/school_homepage/teacher/teacher_bloc.dart';
import 'package:schoolui/bloc/school_homepage/teacher/teacher_event.dart';
import 'package:schoolui/bloc/school_homepage/teacher/teacher_state.dart';
// import 'package:schoolui/models/students.dart';
import 'package:schoolui/presentation/core/appdrawer.dart';
import 'package:schoolui/presentation/core/customShimmer.dart';
import 'package:schoolui/presentation/school/addSectionPage.dart';
import 'package:schoolui/presentation/school/addStudentPage.dart';
import 'package:schoolui/presentation/school/gradeList.dart';
import 'package:schoolui/presentation/school/sectionList.dart';
import 'package:schoolui/presentation/school/subjectList.dart';

import '../../bloc/school_homepage/school/school_homepage_event.dart';
import '../../bloc/school_homepage/student/student_event.dart';
import '../../bloc/school_homepage/student/student_state.dart';
import '../../models/section.dart';
import '../../models/teacher.dart';
import 'addTeacherPage.dart';
import 'gradeDialog.dart';
import 'studentList.dart';
import 'subjectDialog.dart';
import 'teacherList.dart';
// import 'addTeacherPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTabIndex = 0; // Track the current tab
  List<Section> _sections = [];
  @override
  void initState() {
    super.initState();
    // Load teachers by default
    context.read<HomeBloc>().add(LoadSections());
    context.read<HomeBloc>().add(LoadTeachers());
    // context.read<HomeBloc>().add(LoadSchool());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SubjectBloc, SubjectState>(listener: (context, state) {
          if (state is SubjectSuccess) {
            // Reload teachers when the operation is successful
            context.read<HomeBloc>().add(LoadSubjects());
          }
        }),
        BlocListener<SectionBloc, SectionState>(listener: (context, state) {
          if (state is SectionSuccess) {
            // Reload teachers when the operation is successful
            context.read<HomeBloc>().add(LoadSections());
          }
        }),
        BlocListener<GradeBloc, GradeState>(listener: (context, state) {
          if (state is GradeSuccess) {
            // Reload teachers when the operation is successful
            context.read<HomeBloc>().add(LoadGrades());
          }
        }),
        BlocListener<HomeBloc, SchoolHomepageState>(
          listener: (context, state) {
            if (state is SectionsLoaded) {
              // Directly update the _sections variable without calling setState
              setState(() {
                _sections = state.sections;
              });
            }
          },
        ),
        BlocListener<TeacherBloc, TeacherState>(
          listener: (context, state) {
            if (state is TeacherSuccess) {
              // Reload teachers when the operation is successful
              context.read<HomeBloc>().add(LoadTeachers());
            }
            if (state is TeacherUploading) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Uploading file...'),
                  duration: Duration(
                      minutes: 5), // Keep SnackBar showing until dismissed
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
                SnackBar(content: Text('Upload failed: //${state.error}')),
              );
            }
          },
        ),
        BlocListener<StudentBloc, StudentState>(
          listener: (context, state) {
            if (state is StudentSuccess) {
              // Reload students when the operation is successful
              context.read<HomeBloc>().add(LoadStudents());
            }
            // Handle other student states if necessary, e.g., showing errors
            if (state is StudentFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Error loading students: ${state.error}')),
              );
            }
            if (state is StudentUploading) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Uploading file...'),
                  duration: Duration(
                      minutes: 5), // Keep SnackBar showing until dismissed
                ),
              );
            } else if (state is StudentUploadSuccess) {
              context.read<HomeBloc>().add(LoadStudents());
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('File uploaded successfully!')),
              );
            } else if (state is StudentUploadFailure) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Upload failed: //${state.error}')),
              );
            }
          },
        ),
      ],
      child: DefaultTabController(
        length: 5, // 4 tabs: Teachers, Students, Grades, Sections
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
                indicatorColor: Colors.orange,
                labelColor: Colors.black,
                isScrollable: true,
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
                  } else if (index == 4) {
                    context.read<HomeBloc>().add(LoadSubjects());
                  }
                },
                tabs: const [
                  Tab(text: 'Teachers'),
                  Tab(text: 'Students'),
                  Tab(text: 'Grades'),
                  Tab(text: 'Sections'),
                  Tab(text: 'Subjects'),
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
                      _sections = state.sections;
                      return SectionList(sections: state.sections);
                    } else if (state is SubjectsLoaded) {
                      return SubjectList(subjects: state.subjects);
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

  Widget? _getFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        if (_selectedTabIndex == 0) {
          _showAddOptions("Teacher");
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => AddTeacherPage()));
        } else if (_selectedTabIndex == 1) {
          _showAddOptions("Student");
        } else if (_selectedTabIndex == 2) {
          showGradeDialog(context);
        } else if (_selectedTabIndex == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddSectionPage(),
            ),
          );
        } else if (_selectedTabIndex == 4) {
          showSubjectDialog(context);
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

  void _showAddOptions(String tab) {
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
                title: Text('Add $tab'),
                onTap: () {
                  Navigator.pop(context); // Close the modal
                  if (tab == "Teacher") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddTeacherPage()),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddStudentPage()),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.upload_file),
                title: const Text('Upload Excel File'),
                onTap: () {
                  Navigator.pop(context); // Close the modal
                  _uploadExcelFile(tab); // Handle file upload
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadExcelFile(String tab) async {
    if (tab == "Student") {
      _showUploadOptionsForStudent();
    } else {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result != null && tab == "Teacher") {
        final file = File(result.files.single.path!);
        context.read<TeacherBloc>().add(UploadTeacherExcel(file));
      }
    }

    // if (result != null && tab == "Student") {
    //   final file = File(result.files.single.path!);
    // context.read<StudentBloc>().add(UploadTeacherExcel(file));
    // }
  }

  int? _selectedSection; // Store the selected section

  void _showUploadOptionsForStudent() {
    if (_sections.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No sections available. Please try again later.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Section and Upload'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                value: _selectedSection,
                decoration: const InputDecoration(
                  labelText: 'Section',
                  border: OutlineInputBorder(),
                ),
                items: _sections.map<DropdownMenuItem<int>>((section) {
                  return DropdownMenuItem<int>(
                    value: section.id,
                    child: Text('${section.grade_name} - ${section.section}'),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedSection = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a section' : null,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_selectedSection != null) {
                  Navigator.pop(context); // Close the dialog
                  _uploadExcelFileForStudent(); // Upload the file
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a section')),
                  );
                }
              },
              child: const Text('Upload'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadExcelFileForStudent() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      final file = File(result.files.single.path!);
      print(_selectedSection);
      // Here, pass the selected section id along with the file to your upload event
      context
          .read<StudentBloc>()
          .add(UploadStudentExcel(file, _selectedSection!));
    }
  }
}

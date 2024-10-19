import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolui/bloc/school_homepage/school/school_homepage_bloc.dart';
import 'package:schoolui/bloc/school_homepage/school/school_homepage_event.dart';
import 'package:schoolui/bloc/school_homepage/school/school_homepage_state.dart';
import 'package:schoolui/bloc/school_homepage/section/section_bloc.dart';
import 'package:schoolui/bloc/school_homepage/student/student_bloc.dart';
import 'package:schoolui/bloc/school_homepage/subject/subject_bloc.dart';
import 'package:schoolui/bloc/school_homepage/teacher/teacher_bloc.dart';
import 'package:schoolui/data_provider/school_homepage_provider/grade_provider.dart';
import 'package:schoolui/data_provider/school_homepage_provider/school_homepage_provider.dart';
import 'package:schoolui/data_provider/school_homepage_provider/section_provider.dart';
import 'package:schoolui/data_provider/school_homepage_provider/student_provider.dart';
import 'package:schoolui/data_provider/school_homepage_provider/subject_provider.dart';
import 'package:schoolui/presentation/school/school_homepage.dart';
import 'package:schoolui/presentation/signin/signin.dart';
import 'package:schoolui/repository/school_homepage_repository/grade_repository.dart';
import 'package:schoolui/repository/school_homepage_repository/school_homepage_repository.dart';
import 'package:schoolui/repository/school_homepage_repository/section_repository.dart';
import 'package:schoolui/repository/school_homepage_repository/student_repository.dart';
import 'package:schoolui/repository/school_homepage_repository/subject_repository.dart';
import 'package:schoolui/repository/school_homepage_repository/teacher_repository.dart';

import '../bloc/school_homepage/grade/grade_bloc.dart';
import '../bloc/signin/auth_bloc.dart';
import '../data_provider/auth_provider/auth_provider.dart';
import '../data_provider/school_homepage_provider/teacher_provider.dart';
import '../repository/auth_repository/auth_repository.dart';
import 'landing_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(AuthRepository(AuthProvider())),
        ),
        BlocProvider<HomeBloc>(
          create: (_) =>
              HomeBloc(SchoolHomepageRepository(SchoolHomepageProvider()))
                ..add(LoadTeachers()),
        ),
        BlocProvider<TeacherBloc>(
          create: (_) => TeacherBloc(
              TeacherRepository(dataProvider: TeacherDataProvider())),
        ),
        BlocProvider<StudentBloc>(
          create: (_) => StudentBloc(
              StudentRepository(dataProvider: StudentDataProvider())),
        ),
        BlocProvider<GradeBloc>(
          create: (_) =>
              GradeBloc(GradeRepository(dataProvider: GradeDataProvider())),
        ),
        BlocProvider<SectionBloc>(
          create: (_) => SectionBloc(
              SectionRepository(dataProvider: SectionDataProvider())),
        ),
        BlocProvider<SubjectBloc>(
          create: (_) => SubjectBloc(
              SubjectRepository(dataProvider: SubjectDataProvider())),
        ),
      ],
      child: MaterialApp(
        title: 'School App',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => LandingPage(),
          '/login': (context) => SignInPage(),
          '/school-home': (context) => HomePage(),
          // '/home-admin': (context) => HomePageAdmin(),
        },
      ),
    );
  }
}

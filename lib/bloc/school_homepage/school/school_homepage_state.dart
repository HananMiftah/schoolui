
import 'package:schoolui/models/grade.dart';
import 'package:schoolui/models/parent.dart';
import 'package:schoolui/models/school.dart';
import 'package:schoolui/models/section.dart';
import 'package:schoolui/models/students.dart';
import 'package:schoolui/models/teacher.dart';

import '../../../models/subject.dart';


abstract class SchoolHomepageState {}

class HomeLoading extends SchoolHomepageState {}

// Loaded state for teachers
class TeachersLoaded extends SchoolHomepageState {
  final List<Teacher> teachers;

  TeachersLoaded({required this.teachers});

  @override
  List<Object?> get props => [teachers];
}

// Loaded state for students
class StudentsLoaded extends SchoolHomepageState {
  final List<Student> students;

  StudentsLoaded({required this.students});

  @override
  List<Object?> get props => [students];
}

class GradesLoaded extends SchoolHomepageState {
  final List<Grade> grades;

  GradesLoaded({required this.grades});

  @override
  List<Object?> get props => [grades];
}

class SectionsLoaded extends SchoolHomepageState {
  final List<Section> sections;

  SectionsLoaded({required this.sections});

  @override
  List<Object?> get props => [sections];
}

class SubjectsLoaded extends SchoolHomepageState {
  final List<Subject> subjects;

  SubjectsLoaded({required this.subjects});

  @override
  List<Object?> get props => [subjects];
}

class ParentsLoaded extends SchoolHomepageState {
  final List<Parent> parents;

  ParentsLoaded({required this.parents});

  @override
  List<Object?> get props => [parents];
}

// Error state
class HomeError extends SchoolHomepageState {
  final String error;

  HomeError(this.error);

  @override
  List<Object?> get props => [error];
}

class SchoolLoaded extends SchoolHomepageState {
  final School school;

  SchoolLoaded({required this.school});
}

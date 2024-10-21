import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/teacher/teacherpage_repository.dart';
import 'teacherpage_event.dart';
import 'teacherpage_state.dart';

class TeacherPageBloc extends Bloc<TeacherPageEvent, TeacherPageState> {
  final TeacherPageRepository teacherRepository;

  TeacherPageBloc({required this.teacherRepository}) : super(TeacherInitial()) {
    on<LoadTeacher>(_onLoadTeacher);
    on<LoadTeacherSections>(_onLoadTeacherSections);
  }

  Future<void> _onLoadTeacher(
      LoadTeacher event, Emitter<TeacherPageState> emit) async {
    emit(TeacherLoading());
    try {
      final teacher = await teacherRepository.getTeacher();
      emit(TeacherLoaded(teacher));
    } catch (e) {
      emit(TeacherError('Failed to load teacher data'));
    }
  }

  Future<void> _onLoadTeacherSections(
      LoadTeacherSections event, Emitter<TeacherPageState> emit) async {
    emit(TeacherLoading());
    try {
      final sections = await teacherRepository.getSections();
      emit(TeacherSectionsLoaded(sections));
    } catch (e) {
      emit(TeacherError('Failed to load sections data'));
    }
  }
}

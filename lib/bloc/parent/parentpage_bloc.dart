import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/parent/parentpage_repository.dart'; // Ensure to create this repository
import 'parentpage_event.dart';
import 'parentpage_state.dart';

class ParentPageBloc extends Bloc<ParentPageEvent, ParentPageState> {
  final ParentPageRepository parentRepository;

  ParentPageBloc({required this.parentRepository}) : super(ParentInitial()) {
    on<LoadParentStudents>(_onLoadParentStudents);
    on<RefreshParentStudents>(_onRefreshParentStudents);
    on<LoadStudentAttendance>(_onLoadStudentAttendance); // Add attendance event
    on<RefreshStudentAttendance>(_onRefreshStudentAttendance); // Add attendance event
  }

  Future<void> _onLoadParentStudents(
      LoadParentStudents event, Emitter<ParentPageState> emit) async {
    emit(ParentLoading());
    try {
      final students = await parentRepository.getStudents(); // Ensure you implement this method
      emit(ParentStudentsLoaded(students));
    } catch (e) {
      emit(ParentError('Failed to load student data'));
    }
  }

  Future<void> _onRefreshParentStudents(
      RefreshParentStudents event, Emitter<ParentPageState> emit) async {
    emit(ParentLoading());
    try {
      final students = await parentRepository.getStudents(); // Refresh logic
      emit(ParentStudentsLoaded(students));
    } catch (e) {
      emit(ParentError('Failed to refresh student data'));
    }
  }

  Future<void> _onLoadStudentAttendance(
      LoadStudentAttendance event, Emitter<ParentPageState> emit) async {
    emit(ParentLoading());
    try {
      // Assuming you have a method in the repository to get attendance by student ID
      final attendance = await parentRepository.getAttendance(event.studentId,event.date); 
      emit(ParentAttendanceLoaded(attendance)); // Create this state to hold attendance data
    } catch (e) {
      emit(ParentError('Failed to load attendance data'));
    }
  }

  Future<void> _onRefreshStudentAttendance(
      RefreshStudentAttendance event, Emitter<ParentPageState> emit) async {
    emit(ParentLoading());
    try {
      // Refresh attendance logic
      final attendance = await parentRepository.getAttendance(event.studentId, event.date); 
      emit(ParentAttendanceLoaded(attendance)); // Create this state to hold attendance data
    } catch (e) {
      emit(ParentError('Failed to refresh attendance data'));
    }
  }
}

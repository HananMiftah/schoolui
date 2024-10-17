import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolui/bloc/school_homepage/student/student_event.dart';
import 'package:schoolui/bloc/school_homepage/student/student_state.dart';
import 'package:schoolui/repository/school_homepage_repository/student_repository.dart';
import '../../../repository/school_homepage_repository/teacher_repository.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentRepository repository;

  StudentBloc(this.repository) : super(StudentInitial()) {
    on<AddStudentEvent>((event, emit) async {
      emit(StudentLoading());
      try {
        await repository.addStudent(event.student);
        emit(StudentSuccess());
      } catch (e) {
        emit(StudentFailure(e.toString()));
      }
    });

    on<UpdateStudentEvent>((event, emit) async {
      emit(StudentLoading());
      try {
        await repository.updateStudent(event.student);
        emit(StudentSuccess());
      } catch (e) {
        emit(StudentFailure(e.toString()));
      }
    });

    on<DeleteStudentEvent>((event, emit) async {
      emit(StudentLoading());
      try {
        await repository.deleteStudent(event.id);
        emit(StudentSuccess());
      } catch (e) {
        emit(StudentFailure(e.toString()));
      }
    });

    on<UploadStudentExcel>((event, emit) async {
      emit(StudentUploading());
      try {
        await repository.uploadExcel(event.file, event.id);
        emit(StudentUploadSuccess());
      } catch (e) {
        emit(StudentUploadFailure(e.toString()));
      }
    });
  }
}

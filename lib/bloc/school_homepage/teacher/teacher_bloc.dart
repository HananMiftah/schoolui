import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/school_homepage_repository/teacher_repository.dart';
import 'teacher_event.dart';
import 'teacher_state.dart';

class TeacherBloc extends Bloc<TeacherEvent, TeacherState> {
  final TeacherRepository repository;

  TeacherBloc(this.repository) : super(TeacherInitial()) {
    on<AddTeacherEvent>((event, emit) async {
      emit(TeacherLoading());
      try {
        await repository.addTeacher(event.teacher);
        emit(TeacherSuccess());
      } catch (e) {
        emit(TeacherFailure(e.toString()));
      }
    });

    on<UpdateTeacherEvent>((event, emit) async {
      emit(TeacherLoading());
      try {
        await repository.updateTeacher(event.teacher);
        emit(TeacherSuccess());
      } catch (e) {
        emit(TeacherFailure(e.toString()));
      }
    });

    on<DeleteTeacherEvent>((event, emit) async {
      emit(TeacherLoading());
      try {
        await repository.deleteTeacher(event.id);
        emit(TeacherSuccess());
      } catch (e) {
        emit(TeacherFailure(e.toString()));
      }
    });

    on<UploadTeacherExcel>((event, emit) async {
      emit(TeacherUploading());
      try {
        await repository.uploadTeacherExcel(event.file);
        emit(TeacherUploadSuccess());
      } catch (e) {
        emit(TeacherUploadFailure(e.toString()));
      }
    });
  }
}

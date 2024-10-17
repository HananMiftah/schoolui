import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolui/bloc/school_homepage/grade/grade_event.dart';
import 'package:schoolui/bloc/school_homepage/grade/grade_state.dart';
import 'package:schoolui/repository/school_homepage_repository/grade_repository.dart';

class GradeBloc extends Bloc<GradeEvent, GradeState> {
  final GradeRepository repository;

  GradeBloc(this.repository) : super(GradeInitial()) {
    on<AddGradeEvent>((event, emit) async {
      emit(GradeLoading());
      try {
        await repository.addGrade(event.grade);
        emit(GradeSuccess());
      } catch (e) {
        emit(GradeFailure(e.toString()));
      }
    });

    on<UpdateGradeEvent>((event, emit) async {
      emit(GradeLoading());
      try {
        await repository.editGrade(event.grade);
        emit(GradeSuccess());
      } catch (e) {
        emit(GradeFailure(e.toString()));
      }
    });

    on<DeleteGradeEvent>((event, emit) async {
      emit(GradeLoading());
      try {
        await repository.deleteGrade(event.id);
        emit(GradeSuccess());
      } catch (e) {
        emit(GradeFailure(e.toString()));
      }
    });
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolui/bloc/school_homepage/grade/grade_event.dart';
import 'package:schoolui/bloc/school_homepage/grade/grade_state.dart';
import 'package:schoolui/bloc/school_homepage/subject/subject_event.dart';
import 'package:schoolui/bloc/school_homepage/subject/subject_state.dart';
import 'package:schoolui/repository/school_homepage_repository/grade_repository.dart';
import 'package:schoolui/repository/school_homepage_repository/subject_repository.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  final SubjectRepository repository;

  SubjectBloc(this.repository) : super(SubjectInitial()) {
    on<AddSubjectEvent>((event, emit) async {
      emit(SubjectLoading());
      try {
        await repository.addSubject(event.subject);
        emit(SubjectSuccess());
      } catch (e) {
        emit(SubjectFailure(e.toString()));
      }
    });

    on<UpdateSubjectEvent>((event, emit) async {
      emit(SubjectLoading());
      try {
        await repository.editSubject(event.subject);
        emit(SubjectSuccess());
      } catch (e) {
        emit(SubjectFailure(e.toString()));
      }
    });

    on<DeleteSubjectEvent>((event, emit) async {
      emit(SubjectLoading());
      try {
        await repository.deleteSubject(event.id);
        emit(SubjectSuccess());
      } catch (e) {
        emit(SubjectFailure(e.toString()));
      }
    });
  }
}

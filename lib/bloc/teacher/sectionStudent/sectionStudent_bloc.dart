import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/teacher/sectionStudent_repository.dart';
import 'sectionStudent_event.dart';
import 'sectionStudent_state.dart';

class SectionStudentBloc
    extends Bloc<SectionStudentEvent, SectionStudentState> {
  final SectionStudentPageRepository repository;

  SectionStudentBloc({required this.repository}) : super(StudentLoading()) {
    on<FetchStudents>((event, emit) async {
      try {
        emit(StudentLoading());
        final students = await repository.getStudents(event.sectionId);
        emit(StudentLoaded(students));
      } catch (e) {
        emit(StudentError('Failed to fetch students'));
      }
    });
  }
}

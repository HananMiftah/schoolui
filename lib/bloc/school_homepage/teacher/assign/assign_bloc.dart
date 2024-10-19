import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../repository/school_homepage_repository/assignTeacher_repository.dart';
import 'assign_event.dart';
import 'assign_state.dart';

class TeacherAssignmentBloc
    extends Bloc<TeacherAssignmentEvent, TeacherAssignmentState> {
  final TeacherAssignmentRepository repository;

  TeacherAssignmentBloc(this.repository) : super(TeacherAssignmentInitial()) {
    on<AssignTeacherEvent>((event, emit) async {
      emit(TeacherAssignmentLoading());
      try {
        await repository.assignTeacher(event.assignment);
        emit(TeacherAssignmentSuccess());
      } catch (e) {
        emit(TeacherAssignmentFailure(e.toString()));
      }
    });

    on<LoadAssignments>((event, emit) async {
      emit(TeacherAssignmentLoading());
      try {
        final assignments = await repository.getAllAssignments();
        emit(AssignmentsLoaded(assignments: assignments));
      } catch (e) {
        emit(TeacherAssignmentFailure(e.toString()));
      }
    });

    on<DeleteTeacherAssignmentEvent>((event, emit) async {
      emit(TeacherAssignmentLoading());
      try {
        await repository.deleteAssignment(event.id);
        emit(TeacherAssignmentSuccess());
      } catch (e) {
        emit(TeacherAssignmentFailure(e.toString()));
      }
    });
  }
}

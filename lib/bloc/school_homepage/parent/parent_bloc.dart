import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolui/bloc/school_homepage/parent/parent_event.dart';
import 'package:schoolui/bloc/school_homepage/parent/parent_state.dart';
import 'package:schoolui/repository/school_homepage_repository/parent_repository.dart';

class ParentBloc extends Bloc<ParentEvent, ParentState> {
  final ParentRepository repository;

  ParentBloc(this.repository) : super(ParentInitial()) {
    on<AddParentEvent>((event, emit) async {
      emit(ParentLoading());
      try {
        await repository.addParent(event.parent);
        emit(ParentSuccess());
      } catch (e) {
        emit(ParentFailure(e.toString()));
      }
    });

    on<UpdateParentEvent>((event, emit) async {
      emit(ParentLoading());
      try {
        await repository.updateParent(event.parent);
        emit(ParentSuccess());
      } catch (e) {
        emit(ParentFailure(e.toString()));
      }
    });

    on<DeleteParentEvent>((event, emit) async {
      emit(ParentLoading());
      try {
        await repository.deleteParent(event.id);
        emit(ParentSuccess());
      } catch (e) {
        emit(ParentFailure(e.toString()));
      }
    });

    on<UploadParentExcelEvent>((event, emit) async {
      emit(ParentUploading());
      try {
        await repository.uploadExcel(event.file);
        emit(ParentUploadSuccess());
      } catch (e) {
        emit(ParentUploadFailure(e.toString()));
      }
    });
  }
}

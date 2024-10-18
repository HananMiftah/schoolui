// section_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/school_homepage_repository/section_repository.dart';
import 'section_event.dart';
import 'section_state.dart';

class SectionBloc extends Bloc<SectionEvent, SectionState> {
  final SectionRepository repository;

  SectionBloc(this.repository) : super(SectionInitial()) {
    on<AddSection>((event, emit) async {
      try {
        await repository.addSection(event.section);
        emit(SectionSuccess()); // Reload sections after adding
      } catch (e) {
        emit(SectionError('Failed to add section'));
      }
    });

    on<UpdateSection>((event, emit) async {
      try {
        await repository.editSection(event.section);
        emit(SectionSuccess()); // Reload sections after updating
      } catch (e) {
        emit(SectionError('Failed to update section'));
      }
    });

    on<DeleteSection>((event, emit) async {
      try {
        await repository.deleteSection(event.id);
        emit(SectionSuccess()); // Reload sections after deletion
      } catch (e) {
        emit(SectionError('Failed to delete section'));
      }
    });
  }
}

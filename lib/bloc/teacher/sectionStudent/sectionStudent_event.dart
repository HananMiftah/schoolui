// events/student_event.dart
import 'package:equatable/equatable.dart';

abstract class SectionStudentEvent extends Equatable {
  const SectionStudentEvent();

  @override
  List<Object?> get props => [];
}

class FetchStudents extends SectionStudentEvent {
  final int? sectionId;

  const FetchStudents(this.sectionId);

  @override
  List<Object?> get props => [sectionId];
}

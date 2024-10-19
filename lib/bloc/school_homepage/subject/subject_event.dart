import 'package:equatable/equatable.dart';
import 'package:schoolui/models/subject.dart';

import '../../../models/grade.dart';

abstract class SubjectEvent extends Equatable {
  const SubjectEvent();

  @override
  List<Object> get props => [];
}

class AddSubjectEvent extends SubjectEvent {
  final Subject subject;

  const AddSubjectEvent(this.subject);

  @override
  List<Object> get props => [Subject];
}

class UpdateSubjectEvent extends SubjectEvent {
  final Subject subject;

  const UpdateSubjectEvent(this.subject);

  @override
  List<Object> get props => [Subject];
}

class DeleteSubjectEvent extends SubjectEvent {
  final int id;

  const DeleteSubjectEvent(this.id);

  @override
  List<Object> get props => [id];
}

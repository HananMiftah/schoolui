import 'package:equatable/equatable.dart';

import '../../../models/grade.dart';

abstract class GradeEvent extends Equatable {
  const GradeEvent();

  @override
  List<Object> get props => [];
}

class AddGradeEvent extends GradeEvent {
  final Grade grade;

  const AddGradeEvent(this.grade);

  @override
  List<Object> get props => [Grade];
}

class UpdateGradeEvent extends GradeEvent {
  final Grade grade;

  const UpdateGradeEvent(this.grade);

  @override
  List<Object> get props => [Grade];
}

class DeleteGradeEvent extends GradeEvent {
  final int id;

  const DeleteGradeEvent(this.id);

  @override
  List<Object> get props => [id];
}

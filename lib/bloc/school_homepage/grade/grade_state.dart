import 'package:equatable/equatable.dart';

abstract class GradeState extends Equatable {
  const GradeState();

  @override
  List<Object> get props => [];
}

class GradeInitial extends GradeState {}

class GradeLoading extends GradeState {}

class GradeSuccess extends GradeState {}

class GradeFailure extends GradeState {
  final String error;

  const GradeFailure(this.error);

  @override
  List<Object> get props => [error];
}

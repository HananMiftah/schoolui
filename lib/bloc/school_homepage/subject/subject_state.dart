import 'package:equatable/equatable.dart';

abstract class SubjectState extends Equatable {
  const SubjectState();

  @override
  List<Object> get props => [];
}

class SubjectInitial extends SubjectState {}

class SubjectLoading extends SubjectState {}

class SubjectSuccess extends SubjectState {}

class SubjectFailure extends SubjectState {
  final String error;

  const SubjectFailure(this.error);

  @override
  List<Object> get props => [error];
}

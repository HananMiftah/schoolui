import 'package:equatable/equatable.dart';

abstract class TeacherState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TeacherInitial extends TeacherState {}

class TeacherLoading extends TeacherState {}

class TeacherSuccess extends TeacherState {}

class TeacherUploadSuccess extends TeacherState {}

class TeacherUploadFailure extends TeacherState {
  final String error;

  TeacherUploadFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class TeacherFailure extends TeacherState {
  final String error;

  TeacherFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class TeacherUploadProgress extends TeacherState {
  final double progress;
  TeacherUploadProgress(this.progress);
}

class TeacherUploading extends TeacherState {}

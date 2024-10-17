abstract class StudentState {}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentSuccess extends StudentState {}

class StudentFailure extends StudentState {
  final String error;

  StudentFailure(this.error);
}

class StudentUploadSuccess extends StudentState {}

class StudentUploading extends StudentState {}

class StudentUploadFailure extends StudentState {
  final String error;

  StudentUploadFailure(this.error);

  @override
  List<Object?> get props => [error];
}

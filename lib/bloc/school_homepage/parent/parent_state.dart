abstract class ParentState {}

class ParentInitial extends ParentState {}

class ParentLoading extends ParentState {}

class ParentSuccess extends ParentState {}

class ParentFailure extends ParentState {
  final String error;

  ParentFailure(this.error);
}

class ParentUploadSuccess extends ParentState {}

class ParentUploading extends ParentState {}

class ParentUploadFailure extends ParentState {
  final String error;

  ParentUploadFailure(this.error);

  @override
  List<Object?> get props => [error];
}

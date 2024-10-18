// section_state.dart
import 'package:equatable/equatable.dart';

abstract class SectionState extends Equatable {
  const SectionState();

  @override
  List<Object?> get props => [];
}

class SectionInitial extends SectionState {}

class SectionLoading extends SectionState {}

class SectionSuccess extends SectionState {}

class SectionError extends SectionState {
  final String message;

  const SectionError(this.message);

  @override
  List<Object?> get props => [message];
}

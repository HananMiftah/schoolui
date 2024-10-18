// section_event.dart
import 'package:equatable/equatable.dart';
import '../../../models/section.dart';
abstract class SectionEvent extends Equatable {
  const SectionEvent();

  @override
  List<Object?> get props => [];
}
class AddSection extends SectionEvent {
  final Section section;

  const AddSection(this.section);

  @override
  List<Object?> get props => [section];
}

class UpdateSection extends SectionEvent {
  final Section section;

  const UpdateSection(this.section);

  @override
  List<Object?> get props => [section];
}

class DeleteSection extends SectionEvent {
  final int id;

  const DeleteSection(this.id);

  @override
  List<Object?> get props => [id];
}

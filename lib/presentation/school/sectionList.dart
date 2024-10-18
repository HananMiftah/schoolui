import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolui/bloc/school_homepage/school/school_homepage_bloc.dart';
import 'package:schoolui/bloc/school_homepage/school/school_homepage_event.dart';
import 'package:schoolui/presentation/school/addSectionPage.dart';
import '../../bloc/school_homepage/section/section_bloc.dart';
import '../../bloc/school_homepage/section/section_event.dart';
import '../../models/section.dart';

class SectionList extends StatefulWidget {
  final List<Section> sections;

  const SectionList({Key? key, required this.sections}) : super(key: key);

  @override
  _SectionListState createState() => _SectionListState();
}

class _SectionListState extends State<SectionList> {
  final Set<int> _selectedSections = {}; // Store selected section IDs.
  bool _isSelectionMode = false; // Track if selection mode is active.

  // Toggle selection of a section.
  void _toggleSelection(int sectionId) {
    setState(() {
      if (_selectedSections.contains(sectionId)) {
        _selectedSections.remove(sectionId);
      } else {
        _selectedSections.add(sectionId);
      }

      // Disable selection mode if no sections are selected.
      if (_selectedSections.isEmpty) {
        _isSelectionMode = false;
      }
    });
  }

  // Handle long press to activate selection mode.
  void _onLongPress(int sectionId) {
    setState(() {
      _isSelectionMode = true;
      _toggleSelection(sectionId);
    });
  }

  // Delete selected sections.
  void _deleteSelected() {
    final sectionBloc = context.read<SectionBloc>();

    // Dispatch delete events for selected sections.
    for (var sectionId in _selectedSections) {
      sectionBloc.add(DeleteSection(sectionId));
    }

    // Clear the selection and refresh the list.
    setState(() {
      _selectedSections.clear(); // Clear selection after deletion.
      _isSelectionMode = false; // Exit selection mode.
    });

    // Reload sections after deletion
    context.read<HomeBloc>().add(LoadSections());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSelectionMode
            ? '${_selectedSections.length} Selected'
            : 'Sections'),
        actions: [
          if (_isSelectionMode) ...[
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _deleteSelected,
            ),
          ],
        ],
      ),
      body: ListView.builder(
        itemCount: widget.sections.length,
        itemBuilder: (context, index) {
          final section = widget.sections[index];
          final isSelected = _selectedSections.contains(section.id);

          return GestureDetector(
            onLongPress: () => _onLongPress(section.id!),
            onTap: _isSelectionMode
                ? () => _toggleSelection(section.id!)
                : null, // Toggle selection in selection mode.
            child: Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: isSelected ? Colors.orange[100] : Colors.white,
              child: ListTile(
                leading: const Icon(
                  Icons.class_,
                  size: 40,
                  color: Colors.orange,
                ),
                title: Text(
                  section.grade_name!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text('Section: ${section.section}'),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddSectionPage(),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddSectionPage(),
            ),
          );

          if (result != null) {
            setState(() {
              widget.sections.add(result); // Add the new section.
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

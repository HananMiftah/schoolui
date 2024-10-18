import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/school_homepage/school/school_homepage_bloc.dart';
import '../../bloc/school_homepage/school/school_homepage_event.dart';
import '../../bloc/school_homepage/school/school_homepage_state.dart';
import '../../bloc/school_homepage/section/section_bloc.dart';
import '../../bloc/school_homepage/section/section_event.dart';
import '../../models/grade.dart';
import '../../models/section.dart';

class AddSectionPage extends StatefulWidget {
  const AddSectionPage({Key? key}) : super(key: key);

  @override
  _AddSectionPageState createState() => _AddSectionPageState();
}

class _AddSectionPageState extends State<AddSectionPage> {
  Grade? _selectedGrade;
  List<Section> _allSections = [];
  List<Section> _selectedSections = []; // For selected sections
  List<Grade> _grades = [];
  final TextEditingController _newSectionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadGrades());
    context.read<HomeBloc>().add(LoadSections());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, SchoolHomepageState>(
      listener: (context, state) {
        if (state is GradesLoaded) {
          setState(() {
            _grades = state.grades;
          });
        }
        if (state is SectionsLoaded) {
          setState(() {
            _allSections = _removeDuplicateSections(state.sections);
          });
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          // Trigger the LoadStudents event when navigating back
          context.read<HomeBloc>().add(LoadSections());
          return true;
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Add Section')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Grade Dropdown
                DropdownButtonFormField<Grade>(
                  value: _selectedGrade,
                  onChanged: (grade) => setState(() => _selectedGrade = grade),
                  items: _grades.map((grade) {
                    return DropdownMenuItem<Grade>(
                      value: grade,
                      child: Text(grade.grade_name),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Select Grade',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Wrap with Chips for section selection
                const Text(
                  'Select Sections',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: _allSections.map((section) {
                    final isSelected = _selectedSections.contains(section);
                    return ChoiceChip(
                      label: Text(section.section),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedSections.add(section);
                          } else {
                            _selectedSections.remove(section);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),

                // TextField to add a new section
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _newSectionController,
                          decoration: const InputDecoration(
                            labelText: 'Add New Section',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          final newSectionName =
                              _newSectionController.text.trim();
                          if (newSectionName.isNotEmpty &&
                              !_sectionExists(newSectionName)) {
                            final newSection = Section(
                              section: newSectionName,
                              grade: _selectedGrade?.id,
                              grade_name: _selectedGrade?.grade_name ?? '',
                            );

                            setState(() {
                              _allSections.add(newSection);  // Update all sections
                              _selectedSections.add(newSection); // Update selected sections
                              _newSectionController.clear();
                            });

                            // Optionally, add the new section to the Bloc immediately
                            context.read<SectionBloc>().add(AddSection(newSection));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Section already exists or empty!'),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Save Button
                ElevatedButton(
                  onPressed: _saveSections,
                  child: const Text('Save Sections'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Remove duplicate sections based on section name (case-insensitive)
  List<Section> _removeDuplicateSections(List<Section> sections) {
    final seenSections = <String>{};
    return sections.where((section) {
      final lowerCaseName = section.section.toLowerCase();
      if (seenSections.contains(lowerCaseName)) {
        return false;
      } else {
        seenSections.add(lowerCaseName);
        return true;
      }
    }).toList();
  }

  // Check if a section with the same name already exists
  bool _sectionExists(String sectionName) {
    return _allSections.any(
      (section) => section.section.toLowerCase() == sectionName.toLowerCase(),
    );
  }

  void _saveSections() {
    if (_selectedGrade == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a grade.')),
      );
      return;
    }

    final gradeId = _selectedGrade!.id;
    final sectionsToSave = _selectedSections.map((section) {
      return Section(
        section: section.section,
        grade: gradeId,
        grade_name: _selectedGrade!.grade_name,
      );
    }).toList();

    // Add each section using the Bloc event.
    for (var section in sectionsToSave) {
      context.read<SectionBloc>().add(AddSection(section));
    }
    context.read<HomeBloc>().add(LoadSections());
    // Pop and trigger refresh on return to section list.
    Navigator.pop(context, true); // Send 'true' to indicate new data.
  }
}

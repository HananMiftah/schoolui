// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:schoolui/data_provider/school_homepage_provider/school_homepage_provider.dart';

// class SectionsState {
//   final List<Section> sections;
//   final bool isLoading;
//   final String? error;

//   SectionsState({
//     this.sections = const [],
//     this.isLoading = false,
//     this.error,
//   });
// }

// class SectionsCubit extends Cubit<SectionsState> {
//   final SchoolHomepageProvider apiService; // Inject your API service

//   SectionsCubit(this.apiService) : super(SectionsState());

//   Future<void> loadSections() async {
//     emit(SectionsState(isLoading: true));
//     try {
//       final sections = await apiService.getSections(); // Fetch from API
//       emit(SectionsState(sections: sections));
//     } catch (e) {
//       emit(SectionsState(error: 'Failed to load sections'));
//     }
//   }
// }

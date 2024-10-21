import 'package:bloc/bloc.dart';
import 'package:schoolui/bloc/school_homepage/school/school_homepage_event.dart';
import 'package:schoolui/bloc/school_homepage/school/school_homepage_state.dart';
import 'package:schoolui/repository/school_homepage_repository/school_homepage_repository.dart';

class HomeBloc extends Bloc<SchoolHomepageEvent, SchoolHomepageState> {
  final SchoolHomepageRepository homepageRepository;

  HomeBloc(this.homepageRepository) : super(HomeLoading()) {
    on<LoadTeachers>((event, emit) async {
      emit(HomeLoading());
      try {
        final teachersResponse = await homepageRepository.getTeachers();

        emit(TeachersLoaded(teachers: teachersResponse));
      } catch (e) {
        emit(HomeError('Failed to load teachers'));
      }
    });

    on<LoadStudents>((event, emit) async {
      emit(HomeLoading());
      try {
        final studentsResponse = await homepageRepository.getStudents();

        emit(StudentsLoaded(students: studentsResponse));
      } catch (e) {
        emit(HomeError('Failed to load students'));
      }
    });

    on<LoadGrades>((event, emit) async {
      emit(HomeLoading());
      try {
        final gradesResponse = await homepageRepository.getGrades();

        emit(GradesLoaded(grades: gradesResponse));
      } catch (e) {
        emit(HomeError('Failed to load grades'));
      }
    });

    on<LoadSections>((event, emit) async {
      emit(HomeLoading());
      try {
        final sectionsResponse = await homepageRepository.getSections();

        emit(SectionsLoaded(sections: sectionsResponse));
      } catch (e) {
        emit(HomeError('Failed to load sections'));
      }
    });

    on<LoadSubjects>((event, emit) async {
      emit(HomeLoading());
      try {
        final subjectsResponse = await homepageRepository.getSubjects();

        emit(SubjectsLoaded(subjects: subjectsResponse));
      } catch (e) {
        emit(HomeError('Failed to load subjects'));
      }
    });

    on<LoadParents>((event, emit) async {
      emit(HomeLoading());
      try {
        final parentsResponse = await homepageRepository.getParents();

        emit(ParentsLoaded(parents: parentsResponse));
      } catch (e) {
        emit(HomeError('Failed to load parents'));
      }
    });

    on<LoadSchool>((event, emit) async {
      try {
        final school = await homepageRepository.getSchoolData();
        emit(SchoolLoaded(school: school));
      } catch (e) {
        emit(HomeError('Failed to load students'));
      }
    });
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/cinnamon_grade_data_source.dart';
import '../../data/cinnamon_grade_repository.dart';
import '../../domain/cinnamon_grade.dart';

final cinnamonGradeRepositoryProvider = Provider<CinnamonGradeRepository>(
  (ref) => CinnamonGradeRepository(CinnamonGradeDataSource()),
);
final gradeCatalogueProvider = FutureProvider<CinnamonGradeCatalogue>(
  (ref) => ref.watch(cinnamonGradeRepositoryProvider).load(),
);

class StudyFilter {
  const StudyFilter({this.query = '', this.group});
  final String query;
  final GradeGroup? group;
}

class StudyFilterController extends Notifier<StudyFilter> {
  @override
  StudyFilter build() => const StudyFilter();
  void setQuery(String query) =>
      state = StudyFilter(query: query, group: state.group);
  void setGroup(GradeGroup? group) =>
      state = StudyFilter(query: state.query, group: group);
  void clear() => state = const StudyFilter();
}

final studyFilterProvider =
    NotifierProvider<StudyFilterController, StudyFilter>(
      StudyFilterController.new,
    );
final filteredGradesProvider = Provider<AsyncValue<List<CinnamonGrade>>>((ref) {
  final filter = ref.watch(studyFilterProvider);
  return ref
      .watch(gradeCatalogueProvider)
      .whenData(
        (catalogue) =>
            catalogue.search(query: filter.query, group: filter.group),
      );
});

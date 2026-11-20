import '../domain/cinnamon_grade.dart';
import 'cinnamon_grade_data_source.dart';

/// Reusable offline source. No HTTP or account dependencies.
class CinnamonGradeRepository {
  CinnamonGradeRepository(this._source);
  final CinnamonGradeDataSource _source;
  Future<CinnamonGradeCatalogue> load() => _source.load();
}

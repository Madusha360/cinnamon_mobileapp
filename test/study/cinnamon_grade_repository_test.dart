import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quillgrade_mobile/features/study/data/cinnamon_grade_data_source.dart';
import 'package:quillgrade_mobile/features/study/data/cinnamon_grade_repository.dart';
import 'package:quillgrade_mobile/features/study/domain/cinnamon_grade.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late CinnamonGradeCatalogue catalogue;
  setUp(() async {
    catalogue = await CinnamonGradeRepository(CinnamonGradeDataSource()).load();
  });

  test(
    'real bundled catalogue contains all 13 published diameter references',
    () {
      expect(
        {
          for (final grade in catalogue.grades)
            grade.name: grade.referenceDiameterMm,
        },
        {
          'Alba': 6,
          'C5 Extra Special': 8,
          'C5 Special': 10,
          'C5': 12,
          'C4': 16,
          'C3': 18,
          'M5 Special': 16,
          'M5': 18,
          'M4': 21,
          'H1': 23,
          'H2 Special': 25,
          'H2': 32,
          'H3': 38,
        },
      );
      expect(catalogue.groups.map((group) => group.group), GradeGroup.values);
      expect(
        catalogue.source.url,
        'https://cinnamon.gov.lk/about-cinnamon/post-harvest-technology/',
      );
      expect(catalogue.source.checkedAt, '2026-11-20');
    },
  );

  test('quill counts retain the 42-inch source basis and foxing values', () {
    expect(catalogue.grades.map((grade) => grade.quillsPerKg), [
      45,
      33,
      30,
      27,
      22,
      20,
      22,
      20,
      15,
      10,
      9,
      7,
      6,
    ]);
    expect(catalogue.grades.map((grade) => grade.foxingPercent), [
      10,
      10,
      10,
      15,
      15,
      20,
      60,
      60,
      60,
      25,
      40,
      55,
      65,
    ]);
  });

  test('unsupplied photos and individual finishing descriptions stay null', () {
    expect(
      catalogue.grades.every(
        (grade) =>
            grade.imageAsset == null &&
            grade.appearance == null &&
            grade.finishingCharacteristics == null,
      ),
      isTrue,
    );
  });

  test('search combines group and normalized case-insensitive name terms', () {
    expect(
      catalogue.search(query: '  c5-EXTRA   special  ').single.id,
      'c5-extra-special',
    );
    expect(
      catalogue.search(query: 'special', group: GradeGroup.hamburg).single.id,
      'h2-special',
    );
    expect(catalogue.search(query: 'Alba', group: GradeGroup.mexican), isEmpty);
    expect(catalogue.search(group: GradeGroup.continental), hasLength(5));
    expect(catalogue.byId('unknown'), isNull);
  });

  test(
    'bad schema, duplicate identities and invalid diameters are rejected',
    () async {
      final original = await rootBundle.loadString(
        CinnamonGradeDataSource.assetPath,
      );
      Map<String, dynamic> decoded() =>
          jsonDecode(original) as Map<String, dynamic>;
      expect(
        () =>
            CinnamonGradeCatalogue.fromJson(decoded()..['schemaVersion'] = 999),
        throwsFormatException,
      );
      final duplicate = decoded();
      (duplicate['grades'] as List).add((duplicate['grades'] as List).first);
      expect(
        () => CinnamonGradeCatalogue.fromJson(duplicate),
        throwsFormatException,
      );
      final invalid = decoded();
      invalid['grades'][0]['referenceDiameterMm'] = 0;
      expect(
        () => CinnamonGradeCatalogue.fromJson(invalid),
        throwsFormatException,
      );
    },
  );

  test('reference photo entries require local paths and attribution', () async {
    final data = jsonDecode(
      await rootBundle.loadString(CinnamonGradeDataSource.assetPath),
    ) as Map<String, dynamic>;
    data['grades'][0]['imageAsset'] = 'https://example.com/unverified.jpg';
    expect(() => CinnamonGradeCatalogue.fromJson(data), throwsFormatException);
    data['grades'][0]['imageAsset'] = 'assets/images/study/alba/reference.jpg';
    expect(() => CinnamonGradeCatalogue.fromJson(data), throwsFormatException);
  });
}

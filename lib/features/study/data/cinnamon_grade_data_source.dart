import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/cinnamon_grade.dart';

class CinnamonGradeDataSource {
  CinnamonGradeDataSource({AssetBundle? bundle})
    : _bundle = bundle ?? rootBundle;
  final AssetBundle _bundle;
  static const assetPath = 'assets/data/cinnamon_grades.json';
  Future<CinnamonGradeCatalogue> load() async {
    final data = await _bundle.loadString(assetPath);
    return CinnamonGradeCatalogue.fromJson(
      jsonDecode(data) as Map<String, dynamic>,
    );
  }
}

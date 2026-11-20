enum GradeGroup {
  alba,
  continental,
  mexican,
  hamburg;

  String get label => switch (this) {
    alba => 'Alba',
    continental => 'Continental',
    mexican => 'Mexican',
    hamburg => 'Hamburg',
  };
}

class GradeSource {
  const GradeSource({
    required this.title,
    required this.url,
    required this.checkedAt,
  });
  final String title;
  final String url;
  final String checkedAt;
  factory GradeSource.fromJson(Map<String, dynamic> json) {
    final url = json['url'] as String;
    if (Uri.tryParse(url)?.scheme != 'https') {
      throw const FormatException('Invalid reference source');
    }
    return GradeSource(
      title: json['title'] as String,
      url: url,
      checkedAt: json['checkedAt'] as String,
    );
  }
}

class GradeGroupInfo {
  const GradeGroupInfo({
    required this.group,
    required this.description,
    required this.typeName,
  });
  final GradeGroup group;
  final String description;
  final String typeName;
  factory GradeGroupInfo.fromJson(Map<String, dynamic> json) => GradeGroupInfo(
    group: GradeGroup.values.byName(json['id'] as String),
    description: json['description'] as String,
    typeName: json['typeName'] as String,
  );
}

class CinnamonGrade {
  const CinnamonGrade({
    required this.id,
    required this.name,
    required this.group,
    required this.referenceDiameterMm,
    required this.description,
    required this.source,
    required this.quillsPerKg,
    required this.foxingPercent,
    this.appearance,
    this.finishingCharacteristics,
    this.imageAsset,
    this.imageAttribution,
  });
  final String id;
  final String name;
  final GradeGroup group;
  final double referenceDiameterMm;
  final String description;
  final String? appearance;
  final String? finishingCharacteristics;
  final String? imageAsset;
  final String? imageAttribution;
  final int quillsPerKg;
  final double foxingPercent;
  final GradeSource source;
  String get diameterLabel => referenceDiameterMm.toStringAsFixed(
    referenceDiameterMm == referenceDiameterMm.roundToDouble() ? 0 : 1,
  );
  String get foxingLabel => foxingPercent.toStringAsFixed(
    foxingPercent == foxingPercent.roundToDouble() ? 0 : 1,
  );

  factory CinnamonGrade.fromJson(
    Map<String, dynamic> json,
    GradeSource source,
  ) {
    final diameter = (json['referenceDiameterMm'] as num).toDouble();
    final foxing = (json['foxingPercent'] as num).toDouble();
    final count = json['quillsPerKg'] as int;
    final id = json['id'] as String;
    final image = json['imageAsset'] as String?;
    if (!diameter.isFinite ||
        diameter <= 0 ||
        !foxing.isFinite ||
        foxing < 0 ||
        foxing > 100 ||
        count <= 0 ||
        id.isEmpty) {
      throw const FormatException('Invalid grade reference values');
    }
    if (image != null &&
        (!image.startsWith('assets/images/study/') ||
            image.contains('..') ||
            (json['imageAttribution'] as String?)?.isNotEmpty != true)) {
      throw const FormatException(
        'Reference photos require a local study asset and attribution',
      );
    }
    return CinnamonGrade(
      id: id,
      name: json['name'] as String,
      group: GradeGroup.values.byName(json['group'] as String),
      referenceDiameterMm: diameter,
      description: json['description'] as String,
      appearance: json['appearance'] as String?,
      finishingCharacteristics: json['finishingCharacteristics'] as String?,
      imageAsset: image,
      imageAttribution: json['imageAttribution'] as String?,
      quillsPerKg: count,
      foxingPercent: foxing,
      source: source,
    );
  }
}

class CinnamonGradeCatalogue {
  CinnamonGradeCatalogue({
    required List<CinnamonGrade> grades,
    required List<GradeGroupInfo> groups,
    required this.source,
  }) : grades = List.unmodifiable(grades),
       groups = List.unmodifiable(groups);
  final List<CinnamonGrade> grades;
  final List<GradeGroupInfo> groups;
  final GradeSource source;

  factory CinnamonGradeCatalogue.fromJson(Map<String, dynamic> json) {
    if (json['schemaVersion'] != 1) {
      throw const FormatException('Unsupported grade catalogue');
    }
    final source = GradeSource.fromJson(json['source'] as Map<String, dynamic>);
    final groups = (json['groups'] as List)
        .map((item) => GradeGroupInfo.fromJson(item as Map<String, dynamic>))
        .toList();
    final grades = (json['grades'] as List)
        .map(
          (item) =>
              CinnamonGrade.fromJson(item as Map<String, dynamic>, source),
        )
        .toList();
    if (grades.isEmpty ||
        grades.map((g) => g.id).toSet().length != grades.length ||
        groups.map((g) => g.group).toSet().length != groups.length ||
        grades.any(
          (grade) => !groups.any((group) => group.group == grade.group),
        )) {
      throw const FormatException('Incomplete or duplicate grade catalogue');
    }
    return CinnamonGradeCatalogue(
      grades: grades,
      groups: groups,
      source: source,
    );
  }

  CinnamonGrade? byId(String id) {
    for (final grade in grades) {
      if (grade.id == id) return grade;
    }
    return null;
  }

  GradeGroupInfo groupInfo(GradeGroup group) =>
      groups.firstWhere((item) => item.group == group);

  List<CinnamonGrade> search({String query = '', GradeGroup? group}) {
    final terms = query
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[-\s]+'), ' ')
        .split(' ')
        .where((term) => term.isNotEmpty);
    return grades
        .where(
          (grade) =>
              (group == null || grade.group == group) &&
              terms.every((term) => grade.name.toLowerCase().contains(term)),
        )
        .toList(growable: false);
  }
}

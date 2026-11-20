// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SamplesTable extends Samples with TableInfo<$SamplesTable, DbSample> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SamplesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL COLLATE NOCASE UNIQUE CHECK(length(trim(code)) > 0)',
  );
  static const VerificationMeta _batchIdMeta = const VerificationMeta(
    'batchId',
  );
  @override
  late final GeneratedColumn<String> batchId = GeneratedColumn<String>(
    'batch_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _capturedAtMeta = const VerificationMeta(
    'capturedAt',
  );
  @override
  late final GeneratedColumn<DateTime> capturedAt = GeneratedColumn<DateTime>(
    'captured_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _detectionStatusMeta = const VerificationMeta(
    'detectionStatus',
  );
  @override
  late final GeneratedColumn<String> detectionStatus = GeneratedColumn<String>(
    'detection_status',
    aliasedName,
    false,
    check: () =>
        detectionStatus.isIn(['not_validated', 'validated', 'rejected']),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('not_validated'),
  );
  static const VerificationMeta _calibrationStatusMeta = const VerificationMeta(
    'calibrationStatus',
  );
  @override
  late final GeneratedColumn<String> calibrationStatus =
      GeneratedColumn<String>(
        'calibration_status',
        aliasedName,
        false,
        check: () =>
            calibrationStatus.isIn(['not_calibrated', 'calibrated', 'invalid']),
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('not_calibrated'),
      );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    check: () => syncStatus.isIn([
      'pending',
      'uploading',
      'synced',
      'failed',
      'conflict',
    ]),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    check: () => ComparableExpr(revision).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    batchId,
    capturedAt,
    notes,
    detectionStatus,
    calibrationStatus,
    syncStatus,
    revision,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'samples';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbSample> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('batch_id')) {
      context.handle(
        _batchIdMeta,
        batchId.isAcceptableOrUnknown(data['batch_id']!, _batchIdMeta),
      );
    }
    if (data.containsKey('captured_at')) {
      context.handle(
        _capturedAtMeta,
        capturedAt.isAcceptableOrUnknown(data['captured_at']!, _capturedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_capturedAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('detection_status')) {
      context.handle(
        _detectionStatusMeta,
        detectionStatus.isAcceptableOrUnknown(
          data['detection_status']!,
          _detectionStatusMeta,
        ),
      );
    }
    if (data.containsKey('calibration_status')) {
      context.handle(
        _calibrationStatusMeta,
        calibrationStatus.isAcceptableOrUnknown(
          data['calibration_status']!,
          _calibrationStatusMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbSample map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbSample(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      batchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}batch_id'],
      ),
      capturedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}captured_at'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      detectionStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detection_status'],
      )!,
      calibrationStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}calibration_status'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $SamplesTable createAlias(String alias) {
    return $SamplesTable(attachedDatabase, alias);
  }
}

class DbSample extends DataClass implements Insertable<DbSample> {
  final String id;
  final String code;
  final String? batchId;
  final DateTime capturedAt;
  final String? notes;
  final String detectionStatus;
  final String calibrationStatus;
  final String syncStatus;
  final int revision;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const DbSample({
    required this.id,
    required this.code,
    this.batchId,
    required this.capturedAt,
    this.notes,
    required this.detectionStatus,
    required this.calibrationStatus,
    required this.syncStatus,
    required this.revision,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['code'] = Variable<String>(code);
    if (!nullToAbsent || batchId != null) {
      map['batch_id'] = Variable<String>(batchId);
    }
    map['captured_at'] = Variable<DateTime>(capturedAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['detection_status'] = Variable<String>(detectionStatus);
    map['calibration_status'] = Variable<String>(calibrationStatus);
    map['sync_status'] = Variable<String>(syncStatus);
    map['revision'] = Variable<int>(revision);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  SamplesCompanion toCompanion(bool nullToAbsent) {
    return SamplesCompanion(
      id: Value(id),
      code: Value(code),
      batchId: batchId == null && nullToAbsent
          ? const Value.absent()
          : Value(batchId),
      capturedAt: Value(capturedAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      detectionStatus: Value(detectionStatus),
      calibrationStatus: Value(calibrationStatus),
      syncStatus: Value(syncStatus),
      revision: Value(revision),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory DbSample.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbSample(
      id: serializer.fromJson<String>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      batchId: serializer.fromJson<String?>(json['batchId']),
      capturedAt: serializer.fromJson<DateTime>(json['capturedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      detectionStatus: serializer.fromJson<String>(json['detectionStatus']),
      calibrationStatus: serializer.fromJson<String>(json['calibrationStatus']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      revision: serializer.fromJson<int>(json['revision']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'code': serializer.toJson<String>(code),
      'batchId': serializer.toJson<String?>(batchId),
      'capturedAt': serializer.toJson<DateTime>(capturedAt),
      'notes': serializer.toJson<String?>(notes),
      'detectionStatus': serializer.toJson<String>(detectionStatus),
      'calibrationStatus': serializer.toJson<String>(calibrationStatus),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'revision': serializer.toJson<int>(revision),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  DbSample copyWith({
    String? id,
    String? code,
    Value<String?> batchId = const Value.absent(),
    DateTime? capturedAt,
    Value<String?> notes = const Value.absent(),
    String? detectionStatus,
    String? calibrationStatus,
    String? syncStatus,
    int? revision,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => DbSample(
    id: id ?? this.id,
    code: code ?? this.code,
    batchId: batchId.present ? batchId.value : this.batchId,
    capturedAt: capturedAt ?? this.capturedAt,
    notes: notes.present ? notes.value : this.notes,
    detectionStatus: detectionStatus ?? this.detectionStatus,
    calibrationStatus: calibrationStatus ?? this.calibrationStatus,
    syncStatus: syncStatus ?? this.syncStatus,
    revision: revision ?? this.revision,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  DbSample copyWithCompanion(SamplesCompanion data) {
    return DbSample(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      batchId: data.batchId.present ? data.batchId.value : this.batchId,
      capturedAt: data.capturedAt.present
          ? data.capturedAt.value
          : this.capturedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      detectionStatus: data.detectionStatus.present
          ? data.detectionStatus.value
          : this.detectionStatus,
      calibrationStatus: data.calibrationStatus.present
          ? data.calibrationStatus.value
          : this.calibrationStatus,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      revision: data.revision.present ? data.revision.value : this.revision,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbSample(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('batchId: $batchId, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('notes: $notes, ')
          ..write('detectionStatus: $detectionStatus, ')
          ..write('calibrationStatus: $calibrationStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('revision: $revision, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    code,
    batchId,
    capturedAt,
    notes,
    detectionStatus,
    calibrationStatus,
    syncStatus,
    revision,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbSample &&
          other.id == this.id &&
          other.code == this.code &&
          other.batchId == this.batchId &&
          other.capturedAt == this.capturedAt &&
          other.notes == this.notes &&
          other.detectionStatus == this.detectionStatus &&
          other.calibrationStatus == this.calibrationStatus &&
          other.syncStatus == this.syncStatus &&
          other.revision == this.revision &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class SamplesCompanion extends UpdateCompanion<DbSample> {
  final Value<String> id;
  final Value<String> code;
  final Value<String?> batchId;
  final Value<DateTime> capturedAt;
  final Value<String?> notes;
  final Value<String> detectionStatus;
  final Value<String> calibrationStatus;
  final Value<String> syncStatus;
  final Value<int> revision;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const SamplesCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.batchId = const Value.absent(),
    this.capturedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.detectionStatus = const Value.absent(),
    this.calibrationStatus = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.revision = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SamplesCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    this.batchId = const Value.absent(),
    required DateTime capturedAt,
    this.notes = const Value.absent(),
    this.detectionStatus = const Value.absent(),
    this.calibrationStatus = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.revision = const Value.absent(),
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : code = Value(code),
       capturedAt = Value(capturedAt),
       updatedAt = Value(updatedAt);
  static Insertable<DbSample> custom({
    Expression<String>? id,
    Expression<String>? code,
    Expression<String>? batchId,
    Expression<DateTime>? capturedAt,
    Expression<String>? notes,
    Expression<String>? detectionStatus,
    Expression<String>? calibrationStatus,
    Expression<String>? syncStatus,
    Expression<int>? revision,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (batchId != null) 'batch_id': batchId,
      if (capturedAt != null) 'captured_at': capturedAt,
      if (notes != null) 'notes': notes,
      if (detectionStatus != null) 'detection_status': detectionStatus,
      if (calibrationStatus != null) 'calibration_status': calibrationStatus,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (revision != null) 'revision': revision,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SamplesCompanion copyWith({
    Value<String>? id,
    Value<String>? code,
    Value<String?>? batchId,
    Value<DateTime>? capturedAt,
    Value<String?>? notes,
    Value<String>? detectionStatus,
    Value<String>? calibrationStatus,
    Value<String>? syncStatus,
    Value<int>? revision,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return SamplesCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      batchId: batchId ?? this.batchId,
      capturedAt: capturedAt ?? this.capturedAt,
      notes: notes ?? this.notes,
      detectionStatus: detectionStatus ?? this.detectionStatus,
      calibrationStatus: calibrationStatus ?? this.calibrationStatus,
      syncStatus: syncStatus ?? this.syncStatus,
      revision: revision ?? this.revision,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (batchId.present) {
      map['batch_id'] = Variable<String>(batchId.value);
    }
    if (capturedAt.present) {
      map['captured_at'] = Variable<DateTime>(capturedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (detectionStatus.present) {
      map['detection_status'] = Variable<String>(detectionStatus.value);
    }
    if (calibrationStatus.present) {
      map['calibration_status'] = Variable<String>(calibrationStatus.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SamplesCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('batchId: $batchId, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('notes: $notes, ')
          ..write('detectionStatus: $detectionStatus, ')
          ..write('calibrationStatus: $calibrationStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('revision: $revision, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ModelMetadataTable extends ModelMetadata
    with TableInfo<$ModelMetadataTable, DbModelMetadata> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ModelMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    check: () => kind.isIn(['detection', 'finishing']),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sha256Meta = const VerificationMeta('sha256');
  @override
  late final GeneratedColumn<String> sha256 = GeneratedColumn<String>(
    'sha256',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _installedMeta = const VerificationMeta(
    'installed',
  );
  @override
  late final GeneratedColumn<bool> installed = GeneratedColumn<bool>(
    'installed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("installed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    version,
    localPath,
    sha256,
    installed,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'model_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbModelMetadata> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    }
    if (data.containsKey('sha256')) {
      context.handle(
        _sha256Meta,
        sha256.isAcceptableOrUnknown(data['sha256']!, _sha256Meta),
      );
    }
    if (data.containsKey('installed')) {
      context.handle(
        _installedMeta,
        installed.isAcceptableOrUnknown(data['installed']!, _installedMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {kind, version},
  ];
  @override
  DbModelMetadata map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbModelMetadata(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}version'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      ),
      sha256: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sha256'],
      ),
      installed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}installed'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ModelMetadataTable createAlias(String alias) {
    return $ModelMetadataTable(attachedDatabase, alias);
  }
}

class DbModelMetadata extends DataClass implements Insertable<DbModelMetadata> {
  final String id;
  final String kind;
  final String version;
  final String? localPath;
  final String? sha256;
  final bool installed;
  final DateTime updatedAt;
  const DbModelMetadata({
    required this.id,
    required this.kind,
    required this.version,
    this.localPath,
    this.sha256,
    required this.installed,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['kind'] = Variable<String>(kind);
    map['version'] = Variable<String>(version);
    if (!nullToAbsent || localPath != null) {
      map['local_path'] = Variable<String>(localPath);
    }
    if (!nullToAbsent || sha256 != null) {
      map['sha256'] = Variable<String>(sha256);
    }
    map['installed'] = Variable<bool>(installed);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ModelMetadataCompanion toCompanion(bool nullToAbsent) {
    return ModelMetadataCompanion(
      id: Value(id),
      kind: Value(kind),
      version: Value(version),
      localPath: localPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localPath),
      sha256: sha256 == null && nullToAbsent
          ? const Value.absent()
          : Value(sha256),
      installed: Value(installed),
      updatedAt: Value(updatedAt),
    );
  }

  factory DbModelMetadata.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbModelMetadata(
      id: serializer.fromJson<String>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      version: serializer.fromJson<String>(json['version']),
      localPath: serializer.fromJson<String?>(json['localPath']),
      sha256: serializer.fromJson<String?>(json['sha256']),
      installed: serializer.fromJson<bool>(json['installed']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kind': serializer.toJson<String>(kind),
      'version': serializer.toJson<String>(version),
      'localPath': serializer.toJson<String?>(localPath),
      'sha256': serializer.toJson<String?>(sha256),
      'installed': serializer.toJson<bool>(installed),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DbModelMetadata copyWith({
    String? id,
    String? kind,
    String? version,
    Value<String?> localPath = const Value.absent(),
    Value<String?> sha256 = const Value.absent(),
    bool? installed,
    DateTime? updatedAt,
  }) => DbModelMetadata(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    version: version ?? this.version,
    localPath: localPath.present ? localPath.value : this.localPath,
    sha256: sha256.present ? sha256.value : this.sha256,
    installed: installed ?? this.installed,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DbModelMetadata copyWithCompanion(ModelMetadataCompanion data) {
    return DbModelMetadata(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      version: data.version.present ? data.version.value : this.version,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      sha256: data.sha256.present ? data.sha256.value : this.sha256,
      installed: data.installed.present ? data.installed.value : this.installed,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbModelMetadata(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('version: $version, ')
          ..write('localPath: $localPath, ')
          ..write('sha256: $sha256, ')
          ..write('installed: $installed, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, kind, version, localPath, sha256, installed, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbModelMetadata &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.version == this.version &&
          other.localPath == this.localPath &&
          other.sha256 == this.sha256 &&
          other.installed == this.installed &&
          other.updatedAt == this.updatedAt);
}

class ModelMetadataCompanion extends UpdateCompanion<DbModelMetadata> {
  final Value<String> id;
  final Value<String> kind;
  final Value<String> version;
  final Value<String?> localPath;
  final Value<String?> sha256;
  final Value<bool> installed;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ModelMetadataCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.version = const Value.absent(),
    this.localPath = const Value.absent(),
    this.sha256 = const Value.absent(),
    this.installed = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ModelMetadataCompanion.insert({
    this.id = const Value.absent(),
    required String kind,
    required String version,
    this.localPath = const Value.absent(),
    this.sha256 = const Value.absent(),
    this.installed = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : kind = Value(kind),
       version = Value(version),
       updatedAt = Value(updatedAt);
  static Insertable<DbModelMetadata> custom({
    Expression<String>? id,
    Expression<String>? kind,
    Expression<String>? version,
    Expression<String>? localPath,
    Expression<String>? sha256,
    Expression<bool>? installed,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (version != null) 'version': version,
      if (localPath != null) 'local_path': localPath,
      if (sha256 != null) 'sha256': sha256,
      if (installed != null) 'installed': installed,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ModelMetadataCompanion copyWith({
    Value<String>? id,
    Value<String>? kind,
    Value<String>? version,
    Value<String?>? localPath,
    Value<String?>? sha256,
    Value<bool>? installed,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ModelMetadataCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      version: version ?? this.version,
      localPath: localPath ?? this.localPath,
      sha256: sha256 ?? this.sha256,
      installed: installed ?? this.installed,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (sha256.present) {
      map['sha256'] = Variable<String>(sha256.value);
    }
    if (installed.present) {
      map['installed'] = Variable<bool>(installed.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ModelMetadataCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('version: $version, ')
          ..write('localPath: $localPath, ')
          ..write('sha256: $sha256, ')
          ..write('installed: $installed, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SampleImagesTable extends SampleImages
    with TableInfo<$SampleImagesTable, DbSampleImage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SampleImagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _sampleIdMeta = const VerificationMeta(
    'sampleId',
  );
  @override
  late final GeneratedColumn<String> sampleId = GeneratedColumn<String>(
    'sample_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES samples (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _viewMeta = const VerificationMeta('view');
  @override
  late final GeneratedColumn<String> view = GeneratedColumn<String>(
    'view',
    aliasedName,
    false,
    check: () => view.isIn(['end', 'side']),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _byteCountMeta = const VerificationMeta(
    'byteCount',
  );
  @override
  late final GeneratedColumn<int> byteCount = GeneratedColumn<int>(
    'byte_count',
    aliasedName,
    false,
    check: () => ComparableExpr(byteCount).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detectorModelIdMeta = const VerificationMeta(
    'detectorModelId',
  );
  @override
  late final GeneratedColumn<String> detectorModelId = GeneratedColumn<String>(
    'detector_model_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES model_metadata (id)',
    ),
  );
  static const VerificationMeta _validatedAtMeta = const VerificationMeta(
    'validatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> validatedAt = GeneratedColumn<DateTime>(
    'validated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sampleId,
    view,
    localPath,
    byteCount,
    detectorModelId,
    validatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sample_images';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbSampleImage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sample_id')) {
      context.handle(
        _sampleIdMeta,
        sampleId.isAcceptableOrUnknown(data['sample_id']!, _sampleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sampleIdMeta);
    }
    if (data.containsKey('view')) {
      context.handle(
        _viewMeta,
        view.isAcceptableOrUnknown(data['view']!, _viewMeta),
      );
    } else if (isInserting) {
      context.missing(_viewMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('byte_count')) {
      context.handle(
        _byteCountMeta,
        byteCount.isAcceptableOrUnknown(data['byte_count']!, _byteCountMeta),
      );
    } else if (isInserting) {
      context.missing(_byteCountMeta);
    }
    if (data.containsKey('detector_model_id')) {
      context.handle(
        _detectorModelIdMeta,
        detectorModelId.isAcceptableOrUnknown(
          data['detector_model_id']!,
          _detectorModelIdMeta,
        ),
      );
    }
    if (data.containsKey('validated_at')) {
      context.handle(
        _validatedAtMeta,
        validatedAt.isAcceptableOrUnknown(
          data['validated_at']!,
          _validatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_validatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {sampleId, view},
  ];
  @override
  DbSampleImage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbSampleImage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sampleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sample_id'],
      )!,
      view: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}view'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      )!,
      byteCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}byte_count'],
      )!,
      detectorModelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detector_model_id'],
      ),
      validatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}validated_at'],
      )!,
    );
  }

  @override
  $SampleImagesTable createAlias(String alias) {
    return $SampleImagesTable(attachedDatabase, alias);
  }
}

class DbSampleImage extends DataClass implements Insertable<DbSampleImage> {
  final String id;
  final String sampleId;
  final String view;
  final String localPath;
  final int byteCount;
  final String? detectorModelId;
  final DateTime validatedAt;
  const DbSampleImage({
    required this.id,
    required this.sampleId,
    required this.view,
    required this.localPath,
    required this.byteCount,
    this.detectorModelId,
    required this.validatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sample_id'] = Variable<String>(sampleId);
    map['view'] = Variable<String>(view);
    map['local_path'] = Variable<String>(localPath);
    map['byte_count'] = Variable<int>(byteCount);
    if (!nullToAbsent || detectorModelId != null) {
      map['detector_model_id'] = Variable<String>(detectorModelId);
    }
    map['validated_at'] = Variable<DateTime>(validatedAt);
    return map;
  }

  SampleImagesCompanion toCompanion(bool nullToAbsent) {
    return SampleImagesCompanion(
      id: Value(id),
      sampleId: Value(sampleId),
      view: Value(view),
      localPath: Value(localPath),
      byteCount: Value(byteCount),
      detectorModelId: detectorModelId == null && nullToAbsent
          ? const Value.absent()
          : Value(detectorModelId),
      validatedAt: Value(validatedAt),
    );
  }

  factory DbSampleImage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbSampleImage(
      id: serializer.fromJson<String>(json['id']),
      sampleId: serializer.fromJson<String>(json['sampleId']),
      view: serializer.fromJson<String>(json['view']),
      localPath: serializer.fromJson<String>(json['localPath']),
      byteCount: serializer.fromJson<int>(json['byteCount']),
      detectorModelId: serializer.fromJson<String?>(json['detectorModelId']),
      validatedAt: serializer.fromJson<DateTime>(json['validatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sampleId': serializer.toJson<String>(sampleId),
      'view': serializer.toJson<String>(view),
      'localPath': serializer.toJson<String>(localPath),
      'byteCount': serializer.toJson<int>(byteCount),
      'detectorModelId': serializer.toJson<String?>(detectorModelId),
      'validatedAt': serializer.toJson<DateTime>(validatedAt),
    };
  }

  DbSampleImage copyWith({
    String? id,
    String? sampleId,
    String? view,
    String? localPath,
    int? byteCount,
    Value<String?> detectorModelId = const Value.absent(),
    DateTime? validatedAt,
  }) => DbSampleImage(
    id: id ?? this.id,
    sampleId: sampleId ?? this.sampleId,
    view: view ?? this.view,
    localPath: localPath ?? this.localPath,
    byteCount: byteCount ?? this.byteCount,
    detectorModelId: detectorModelId.present
        ? detectorModelId.value
        : this.detectorModelId,
    validatedAt: validatedAt ?? this.validatedAt,
  );
  DbSampleImage copyWithCompanion(SampleImagesCompanion data) {
    return DbSampleImage(
      id: data.id.present ? data.id.value : this.id,
      sampleId: data.sampleId.present ? data.sampleId.value : this.sampleId,
      view: data.view.present ? data.view.value : this.view,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      byteCount: data.byteCount.present ? data.byteCount.value : this.byteCount,
      detectorModelId: data.detectorModelId.present
          ? data.detectorModelId.value
          : this.detectorModelId,
      validatedAt: data.validatedAt.present
          ? data.validatedAt.value
          : this.validatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbSampleImage(')
          ..write('id: $id, ')
          ..write('sampleId: $sampleId, ')
          ..write('view: $view, ')
          ..write('localPath: $localPath, ')
          ..write('byteCount: $byteCount, ')
          ..write('detectorModelId: $detectorModelId, ')
          ..write('validatedAt: $validatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sampleId,
    view,
    localPath,
    byteCount,
    detectorModelId,
    validatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbSampleImage &&
          other.id == this.id &&
          other.sampleId == this.sampleId &&
          other.view == this.view &&
          other.localPath == this.localPath &&
          other.byteCount == this.byteCount &&
          other.detectorModelId == this.detectorModelId &&
          other.validatedAt == this.validatedAt);
}

class SampleImagesCompanion extends UpdateCompanion<DbSampleImage> {
  final Value<String> id;
  final Value<String> sampleId;
  final Value<String> view;
  final Value<String> localPath;
  final Value<int> byteCount;
  final Value<String?> detectorModelId;
  final Value<DateTime> validatedAt;
  final Value<int> rowid;
  const SampleImagesCompanion({
    this.id = const Value.absent(),
    this.sampleId = const Value.absent(),
    this.view = const Value.absent(),
    this.localPath = const Value.absent(),
    this.byteCount = const Value.absent(),
    this.detectorModelId = const Value.absent(),
    this.validatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SampleImagesCompanion.insert({
    this.id = const Value.absent(),
    required String sampleId,
    required String view,
    required String localPath,
    required int byteCount,
    this.detectorModelId = const Value.absent(),
    required DateTime validatedAt,
    this.rowid = const Value.absent(),
  }) : sampleId = Value(sampleId),
       view = Value(view),
       localPath = Value(localPath),
       byteCount = Value(byteCount),
       validatedAt = Value(validatedAt);
  static Insertable<DbSampleImage> custom({
    Expression<String>? id,
    Expression<String>? sampleId,
    Expression<String>? view,
    Expression<String>? localPath,
    Expression<int>? byteCount,
    Expression<String>? detectorModelId,
    Expression<DateTime>? validatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sampleId != null) 'sample_id': sampleId,
      if (view != null) 'view': view,
      if (localPath != null) 'local_path': localPath,
      if (byteCount != null) 'byte_count': byteCount,
      if (detectorModelId != null) 'detector_model_id': detectorModelId,
      if (validatedAt != null) 'validated_at': validatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SampleImagesCompanion copyWith({
    Value<String>? id,
    Value<String>? sampleId,
    Value<String>? view,
    Value<String>? localPath,
    Value<int>? byteCount,
    Value<String?>? detectorModelId,
    Value<DateTime>? validatedAt,
    Value<int>? rowid,
  }) {
    return SampleImagesCompanion(
      id: id ?? this.id,
      sampleId: sampleId ?? this.sampleId,
      view: view ?? this.view,
      localPath: localPath ?? this.localPath,
      byteCount: byteCount ?? this.byteCount,
      detectorModelId: detectorModelId ?? this.detectorModelId,
      validatedAt: validatedAt ?? this.validatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sampleId.present) {
      map['sample_id'] = Variable<String>(sampleId.value);
    }
    if (view.present) {
      map['view'] = Variable<String>(view.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (byteCount.present) {
      map['byte_count'] = Variable<int>(byteCount.value);
    }
    if (detectorModelId.present) {
      map['detector_model_id'] = Variable<String>(detectorModelId.value);
    }
    if (validatedAt.present) {
      map['validated_at'] = Variable<DateTime>(validatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SampleImagesCompanion(')
          ..write('id: $id, ')
          ..write('sampleId: $sampleId, ')
          ..write('view: $view, ')
          ..write('localPath: $localPath, ')
          ..write('byteCount: $byteCount, ')
          ..write('detectorModelId: $detectorModelId, ')
          ..write('validatedAt: $validatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CalibrationsTable extends Calibrations
    with TableInfo<$CalibrationsTable, DbCalibration> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalibrationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _markerSizeMmMeta = const VerificationMeta(
    'markerSizeMm',
  );
  @override
  late final GeneratedColumn<double> markerSizeMm = GeneratedColumn<double>(
    'marker_size_mm',
    aliasedName,
    false,
    check: () => ComparableExpr(markerSizeMm).isBiggerThanValue(0),
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pixelsPerMmMeta = const VerificationMeta(
    'pixelsPerMm',
  );
  @override
  late final GeneratedColumn<double> pixelsPerMm = GeneratedColumn<double>(
    'pixels_per_mm',
    aliasedName,
    false,
    check: () => ComparableExpr(pixelsPerMm).isBiggerThanValue(0),
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _calibratedAtMeta = const VerificationMeta(
    'calibratedAt',
  );
  @override
  late final GeneratedColumn<DateTime> calibratedAt = GeneratedColumn<DateTime>(
    'calibrated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    markerSizeMm,
    pixelsPerMm,
    method,
    calibratedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calibrations';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbCalibration> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('marker_size_mm')) {
      context.handle(
        _markerSizeMmMeta,
        markerSizeMm.isAcceptableOrUnknown(
          data['marker_size_mm']!,
          _markerSizeMmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_markerSizeMmMeta);
    }
    if (data.containsKey('pixels_per_mm')) {
      context.handle(
        _pixelsPerMmMeta,
        pixelsPerMm.isAcceptableOrUnknown(
          data['pixels_per_mm']!,
          _pixelsPerMmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pixelsPerMmMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('calibrated_at')) {
      context.handle(
        _calibratedAtMeta,
        calibratedAt.isAcceptableOrUnknown(
          data['calibrated_at']!,
          _calibratedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_calibratedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbCalibration map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbCalibration(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      markerSizeMm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}marker_size_mm'],
      )!,
      pixelsPerMm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pixels_per_mm'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      calibratedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}calibrated_at'],
      )!,
    );
  }

  @override
  $CalibrationsTable createAlias(String alias) {
    return $CalibrationsTable(attachedDatabase, alias);
  }
}

class DbCalibration extends DataClass implements Insertable<DbCalibration> {
  final String id;
  final double markerSizeMm;
  final double pixelsPerMm;
  final String method;
  final DateTime calibratedAt;
  const DbCalibration({
    required this.id,
    required this.markerSizeMm,
    required this.pixelsPerMm,
    required this.method,
    required this.calibratedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['marker_size_mm'] = Variable<double>(markerSizeMm);
    map['pixels_per_mm'] = Variable<double>(pixelsPerMm);
    map['method'] = Variable<String>(method);
    map['calibrated_at'] = Variable<DateTime>(calibratedAt);
    return map;
  }

  CalibrationsCompanion toCompanion(bool nullToAbsent) {
    return CalibrationsCompanion(
      id: Value(id),
      markerSizeMm: Value(markerSizeMm),
      pixelsPerMm: Value(pixelsPerMm),
      method: Value(method),
      calibratedAt: Value(calibratedAt),
    );
  }

  factory DbCalibration.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbCalibration(
      id: serializer.fromJson<String>(json['id']),
      markerSizeMm: serializer.fromJson<double>(json['markerSizeMm']),
      pixelsPerMm: serializer.fromJson<double>(json['pixelsPerMm']),
      method: serializer.fromJson<String>(json['method']),
      calibratedAt: serializer.fromJson<DateTime>(json['calibratedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'markerSizeMm': serializer.toJson<double>(markerSizeMm),
      'pixelsPerMm': serializer.toJson<double>(pixelsPerMm),
      'method': serializer.toJson<String>(method),
      'calibratedAt': serializer.toJson<DateTime>(calibratedAt),
    };
  }

  DbCalibration copyWith({
    String? id,
    double? markerSizeMm,
    double? pixelsPerMm,
    String? method,
    DateTime? calibratedAt,
  }) => DbCalibration(
    id: id ?? this.id,
    markerSizeMm: markerSizeMm ?? this.markerSizeMm,
    pixelsPerMm: pixelsPerMm ?? this.pixelsPerMm,
    method: method ?? this.method,
    calibratedAt: calibratedAt ?? this.calibratedAt,
  );
  DbCalibration copyWithCompanion(CalibrationsCompanion data) {
    return DbCalibration(
      id: data.id.present ? data.id.value : this.id,
      markerSizeMm: data.markerSizeMm.present
          ? data.markerSizeMm.value
          : this.markerSizeMm,
      pixelsPerMm: data.pixelsPerMm.present
          ? data.pixelsPerMm.value
          : this.pixelsPerMm,
      method: data.method.present ? data.method.value : this.method,
      calibratedAt: data.calibratedAt.present
          ? data.calibratedAt.value
          : this.calibratedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbCalibration(')
          ..write('id: $id, ')
          ..write('markerSizeMm: $markerSizeMm, ')
          ..write('pixelsPerMm: $pixelsPerMm, ')
          ..write('method: $method, ')
          ..write('calibratedAt: $calibratedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, markerSizeMm, pixelsPerMm, method, calibratedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbCalibration &&
          other.id == this.id &&
          other.markerSizeMm == this.markerSizeMm &&
          other.pixelsPerMm == this.pixelsPerMm &&
          other.method == this.method &&
          other.calibratedAt == this.calibratedAt);
}

class CalibrationsCompanion extends UpdateCompanion<DbCalibration> {
  final Value<String> id;
  final Value<double> markerSizeMm;
  final Value<double> pixelsPerMm;
  final Value<String> method;
  final Value<DateTime> calibratedAt;
  final Value<int> rowid;
  const CalibrationsCompanion({
    this.id = const Value.absent(),
    this.markerSizeMm = const Value.absent(),
    this.pixelsPerMm = const Value.absent(),
    this.method = const Value.absent(),
    this.calibratedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CalibrationsCompanion.insert({
    this.id = const Value.absent(),
    required double markerSizeMm,
    required double pixelsPerMm,
    required String method,
    required DateTime calibratedAt,
    this.rowid = const Value.absent(),
  }) : markerSizeMm = Value(markerSizeMm),
       pixelsPerMm = Value(pixelsPerMm),
       method = Value(method),
       calibratedAt = Value(calibratedAt);
  static Insertable<DbCalibration> custom({
    Expression<String>? id,
    Expression<double>? markerSizeMm,
    Expression<double>? pixelsPerMm,
    Expression<String>? method,
    Expression<DateTime>? calibratedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (markerSizeMm != null) 'marker_size_mm': markerSizeMm,
      if (pixelsPerMm != null) 'pixels_per_mm': pixelsPerMm,
      if (method != null) 'method': method,
      if (calibratedAt != null) 'calibrated_at': calibratedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CalibrationsCompanion copyWith({
    Value<String>? id,
    Value<double>? markerSizeMm,
    Value<double>? pixelsPerMm,
    Value<String>? method,
    Value<DateTime>? calibratedAt,
    Value<int>? rowid,
  }) {
    return CalibrationsCompanion(
      id: id ?? this.id,
      markerSizeMm: markerSizeMm ?? this.markerSizeMm,
      pixelsPerMm: pixelsPerMm ?? this.pixelsPerMm,
      method: method ?? this.method,
      calibratedAt: calibratedAt ?? this.calibratedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (markerSizeMm.present) {
      map['marker_size_mm'] = Variable<double>(markerSizeMm.value);
    }
    if (pixelsPerMm.present) {
      map['pixels_per_mm'] = Variable<double>(pixelsPerMm.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (calibratedAt.present) {
      map['calibrated_at'] = Variable<DateTime>(calibratedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalibrationsCompanion(')
          ..write('id: $id, ')
          ..write('markerSizeMm: $markerSizeMm, ')
          ..write('pixelsPerMm: $pixelsPerMm, ')
          ..write('method: $method, ')
          ..write('calibratedAt: $calibratedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MeasurementsTable extends Measurements
    with TableInfo<$MeasurementsTable, DbMeasurement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeasurementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _sampleIdMeta = const VerificationMeta(
    'sampleId',
  );
  @override
  late final GeneratedColumn<String> sampleId = GeneratedColumn<String>(
    'sample_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES samples (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _maximumWidthMmMeta = const VerificationMeta(
    'maximumWidthMm',
  );
  @override
  late final GeneratedColumn<double> maximumWidthMm = GeneratedColumn<double>(
    'maximum_width_mm',
    aliasedName,
    true,
    check: () => ComparableExpr(maximumWidthMm).isBiggerThanValue(0),
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _minimumWidthMmMeta = const VerificationMeta(
    'minimumWidthMm',
  );
  @override
  late final GeneratedColumn<double> minimumWidthMm = GeneratedColumn<double>(
    'minimum_width_mm',
    aliasedName,
    true,
    check: () => ComparableExpr(minimumWidthMm).isBiggerThanValue(0),
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _equivalentDiameterMmMeta =
      const VerificationMeta('equivalentDiameterMm');
  @override
  late final GeneratedColumn<double> equivalentDiameterMm =
      GeneratedColumn<double>(
        'equivalent_diameter_mm',
        aliasedName,
        true,
        check: () => ComparableExpr(equivalentDiameterMm).isBiggerThanValue(0),
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _outerCircumferenceMmMeta =
      const VerificationMeta('outerCircumferenceMm');
  @override
  late final GeneratedColumn<double> outerCircumferenceMm =
      GeneratedColumn<double>(
        'outer_circumference_mm',
        aliasedName,
        true,
        check: () => ComparableExpr(outerCircumferenceMm).isBiggerThanValue(0),
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _calibrationIdMeta = const VerificationMeta(
    'calibrationId',
  );
  @override
  late final GeneratedColumn<String> calibrationId = GeneratedColumn<String>(
    'calibration_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES calibrations (id)',
    ),
  );
  static const VerificationMeta _algorithmVersionMeta = const VerificationMeta(
    'algorithmVersion',
  );
  @override
  late final GeneratedColumn<String> algorithmVersion = GeneratedColumn<String>(
    'algorithm_version',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _calculatedAtMeta = const VerificationMeta(
    'calculatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> calculatedAt = GeneratedColumn<DateTime>(
    'calculated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sampleId,
    maximumWidthMm,
    minimumWidthMm,
    equivalentDiameterMm,
    outerCircumferenceMm,
    calibrationId,
    algorithmVersion,
    calculatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'measurements';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbMeasurement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sample_id')) {
      context.handle(
        _sampleIdMeta,
        sampleId.isAcceptableOrUnknown(data['sample_id']!, _sampleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sampleIdMeta);
    }
    if (data.containsKey('maximum_width_mm')) {
      context.handle(
        _maximumWidthMmMeta,
        maximumWidthMm.isAcceptableOrUnknown(
          data['maximum_width_mm']!,
          _maximumWidthMmMeta,
        ),
      );
    }
    if (data.containsKey('minimum_width_mm')) {
      context.handle(
        _minimumWidthMmMeta,
        minimumWidthMm.isAcceptableOrUnknown(
          data['minimum_width_mm']!,
          _minimumWidthMmMeta,
        ),
      );
    }
    if (data.containsKey('equivalent_diameter_mm')) {
      context.handle(
        _equivalentDiameterMmMeta,
        equivalentDiameterMm.isAcceptableOrUnknown(
          data['equivalent_diameter_mm']!,
          _equivalentDiameterMmMeta,
        ),
      );
    }
    if (data.containsKey('outer_circumference_mm')) {
      context.handle(
        _outerCircumferenceMmMeta,
        outerCircumferenceMm.isAcceptableOrUnknown(
          data['outer_circumference_mm']!,
          _outerCircumferenceMmMeta,
        ),
      );
    }
    if (data.containsKey('calibration_id')) {
      context.handle(
        _calibrationIdMeta,
        calibrationId.isAcceptableOrUnknown(
          data['calibration_id']!,
          _calibrationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_calibrationIdMeta);
    }
    if (data.containsKey('algorithm_version')) {
      context.handle(
        _algorithmVersionMeta,
        algorithmVersion.isAcceptableOrUnknown(
          data['algorithm_version']!,
          _algorithmVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_algorithmVersionMeta);
    }
    if (data.containsKey('calculated_at')) {
      context.handle(
        _calculatedAtMeta,
        calculatedAt.isAcceptableOrUnknown(
          data['calculated_at']!,
          _calculatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_calculatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbMeasurement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbMeasurement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sampleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sample_id'],
      )!,
      maximumWidthMm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}maximum_width_mm'],
      ),
      minimumWidthMm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}minimum_width_mm'],
      ),
      equivalentDiameterMm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}equivalent_diameter_mm'],
      ),
      outerCircumferenceMm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}outer_circumference_mm'],
      ),
      calibrationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}calibration_id'],
      )!,
      algorithmVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}algorithm_version'],
      )!,
      calculatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}calculated_at'],
      )!,
    );
  }

  @override
  $MeasurementsTable createAlias(String alias) {
    return $MeasurementsTable(attachedDatabase, alias);
  }
}

class DbMeasurement extends DataClass implements Insertable<DbMeasurement> {
  final String id;
  final String sampleId;
  final double? maximumWidthMm;
  final double? minimumWidthMm;
  final double? equivalentDiameterMm;
  final double? outerCircumferenceMm;
  final String calibrationId;
  final String algorithmVersion;
  final DateTime calculatedAt;
  const DbMeasurement({
    required this.id,
    required this.sampleId,
    this.maximumWidthMm,
    this.minimumWidthMm,
    this.equivalentDiameterMm,
    this.outerCircumferenceMm,
    required this.calibrationId,
    required this.algorithmVersion,
    required this.calculatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sample_id'] = Variable<String>(sampleId);
    if (!nullToAbsent || maximumWidthMm != null) {
      map['maximum_width_mm'] = Variable<double>(maximumWidthMm);
    }
    if (!nullToAbsent || minimumWidthMm != null) {
      map['minimum_width_mm'] = Variable<double>(minimumWidthMm);
    }
    if (!nullToAbsent || equivalentDiameterMm != null) {
      map['equivalent_diameter_mm'] = Variable<double>(equivalentDiameterMm);
    }
    if (!nullToAbsent || outerCircumferenceMm != null) {
      map['outer_circumference_mm'] = Variable<double>(outerCircumferenceMm);
    }
    map['calibration_id'] = Variable<String>(calibrationId);
    map['algorithm_version'] = Variable<String>(algorithmVersion);
    map['calculated_at'] = Variable<DateTime>(calculatedAt);
    return map;
  }

  MeasurementsCompanion toCompanion(bool nullToAbsent) {
    return MeasurementsCompanion(
      id: Value(id),
      sampleId: Value(sampleId),
      maximumWidthMm: maximumWidthMm == null && nullToAbsent
          ? const Value.absent()
          : Value(maximumWidthMm),
      minimumWidthMm: minimumWidthMm == null && nullToAbsent
          ? const Value.absent()
          : Value(minimumWidthMm),
      equivalentDiameterMm: equivalentDiameterMm == null && nullToAbsent
          ? const Value.absent()
          : Value(equivalentDiameterMm),
      outerCircumferenceMm: outerCircumferenceMm == null && nullToAbsent
          ? const Value.absent()
          : Value(outerCircumferenceMm),
      calibrationId: Value(calibrationId),
      algorithmVersion: Value(algorithmVersion),
      calculatedAt: Value(calculatedAt),
    );
  }

  factory DbMeasurement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbMeasurement(
      id: serializer.fromJson<String>(json['id']),
      sampleId: serializer.fromJson<String>(json['sampleId']),
      maximumWidthMm: serializer.fromJson<double?>(json['maximumWidthMm']),
      minimumWidthMm: serializer.fromJson<double?>(json['minimumWidthMm']),
      equivalentDiameterMm: serializer.fromJson<double?>(
        json['equivalentDiameterMm'],
      ),
      outerCircumferenceMm: serializer.fromJson<double?>(
        json['outerCircumferenceMm'],
      ),
      calibrationId: serializer.fromJson<String>(json['calibrationId']),
      algorithmVersion: serializer.fromJson<String>(json['algorithmVersion']),
      calculatedAt: serializer.fromJson<DateTime>(json['calculatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sampleId': serializer.toJson<String>(sampleId),
      'maximumWidthMm': serializer.toJson<double?>(maximumWidthMm),
      'minimumWidthMm': serializer.toJson<double?>(minimumWidthMm),
      'equivalentDiameterMm': serializer.toJson<double?>(equivalentDiameterMm),
      'outerCircumferenceMm': serializer.toJson<double?>(outerCircumferenceMm),
      'calibrationId': serializer.toJson<String>(calibrationId),
      'algorithmVersion': serializer.toJson<String>(algorithmVersion),
      'calculatedAt': serializer.toJson<DateTime>(calculatedAt),
    };
  }

  DbMeasurement copyWith({
    String? id,
    String? sampleId,
    Value<double?> maximumWidthMm = const Value.absent(),
    Value<double?> minimumWidthMm = const Value.absent(),
    Value<double?> equivalentDiameterMm = const Value.absent(),
    Value<double?> outerCircumferenceMm = const Value.absent(),
    String? calibrationId,
    String? algorithmVersion,
    DateTime? calculatedAt,
  }) => DbMeasurement(
    id: id ?? this.id,
    sampleId: sampleId ?? this.sampleId,
    maximumWidthMm: maximumWidthMm.present
        ? maximumWidthMm.value
        : this.maximumWidthMm,
    minimumWidthMm: minimumWidthMm.present
        ? minimumWidthMm.value
        : this.minimumWidthMm,
    equivalentDiameterMm: equivalentDiameterMm.present
        ? equivalentDiameterMm.value
        : this.equivalentDiameterMm,
    outerCircumferenceMm: outerCircumferenceMm.present
        ? outerCircumferenceMm.value
        : this.outerCircumferenceMm,
    calibrationId: calibrationId ?? this.calibrationId,
    algorithmVersion: algorithmVersion ?? this.algorithmVersion,
    calculatedAt: calculatedAt ?? this.calculatedAt,
  );
  DbMeasurement copyWithCompanion(MeasurementsCompanion data) {
    return DbMeasurement(
      id: data.id.present ? data.id.value : this.id,
      sampleId: data.sampleId.present ? data.sampleId.value : this.sampleId,
      maximumWidthMm: data.maximumWidthMm.present
          ? data.maximumWidthMm.value
          : this.maximumWidthMm,
      minimumWidthMm: data.minimumWidthMm.present
          ? data.minimumWidthMm.value
          : this.minimumWidthMm,
      equivalentDiameterMm: data.equivalentDiameterMm.present
          ? data.equivalentDiameterMm.value
          : this.equivalentDiameterMm,
      outerCircumferenceMm: data.outerCircumferenceMm.present
          ? data.outerCircumferenceMm.value
          : this.outerCircumferenceMm,
      calibrationId: data.calibrationId.present
          ? data.calibrationId.value
          : this.calibrationId,
      algorithmVersion: data.algorithmVersion.present
          ? data.algorithmVersion.value
          : this.algorithmVersion,
      calculatedAt: data.calculatedAt.present
          ? data.calculatedAt.value
          : this.calculatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbMeasurement(')
          ..write('id: $id, ')
          ..write('sampleId: $sampleId, ')
          ..write('maximumWidthMm: $maximumWidthMm, ')
          ..write('minimumWidthMm: $minimumWidthMm, ')
          ..write('equivalentDiameterMm: $equivalentDiameterMm, ')
          ..write('outerCircumferenceMm: $outerCircumferenceMm, ')
          ..write('calibrationId: $calibrationId, ')
          ..write('algorithmVersion: $algorithmVersion, ')
          ..write('calculatedAt: $calculatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sampleId,
    maximumWidthMm,
    minimumWidthMm,
    equivalentDiameterMm,
    outerCircumferenceMm,
    calibrationId,
    algorithmVersion,
    calculatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbMeasurement &&
          other.id == this.id &&
          other.sampleId == this.sampleId &&
          other.maximumWidthMm == this.maximumWidthMm &&
          other.minimumWidthMm == this.minimumWidthMm &&
          other.equivalentDiameterMm == this.equivalentDiameterMm &&
          other.outerCircumferenceMm == this.outerCircumferenceMm &&
          other.calibrationId == this.calibrationId &&
          other.algorithmVersion == this.algorithmVersion &&
          other.calculatedAt == this.calculatedAt);
}

class MeasurementsCompanion extends UpdateCompanion<DbMeasurement> {
  final Value<String> id;
  final Value<String> sampleId;
  final Value<double?> maximumWidthMm;
  final Value<double?> minimumWidthMm;
  final Value<double?> equivalentDiameterMm;
  final Value<double?> outerCircumferenceMm;
  final Value<String> calibrationId;
  final Value<String> algorithmVersion;
  final Value<DateTime> calculatedAt;
  final Value<int> rowid;
  const MeasurementsCompanion({
    this.id = const Value.absent(),
    this.sampleId = const Value.absent(),
    this.maximumWidthMm = const Value.absent(),
    this.minimumWidthMm = const Value.absent(),
    this.equivalentDiameterMm = const Value.absent(),
    this.outerCircumferenceMm = const Value.absent(),
    this.calibrationId = const Value.absent(),
    this.algorithmVersion = const Value.absent(),
    this.calculatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MeasurementsCompanion.insert({
    this.id = const Value.absent(),
    required String sampleId,
    this.maximumWidthMm = const Value.absent(),
    this.minimumWidthMm = const Value.absent(),
    this.equivalentDiameterMm = const Value.absent(),
    this.outerCircumferenceMm = const Value.absent(),
    required String calibrationId,
    required String algorithmVersion,
    required DateTime calculatedAt,
    this.rowid = const Value.absent(),
  }) : sampleId = Value(sampleId),
       calibrationId = Value(calibrationId),
       algorithmVersion = Value(algorithmVersion),
       calculatedAt = Value(calculatedAt);
  static Insertable<DbMeasurement> custom({
    Expression<String>? id,
    Expression<String>? sampleId,
    Expression<double>? maximumWidthMm,
    Expression<double>? minimumWidthMm,
    Expression<double>? equivalentDiameterMm,
    Expression<double>? outerCircumferenceMm,
    Expression<String>? calibrationId,
    Expression<String>? algorithmVersion,
    Expression<DateTime>? calculatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sampleId != null) 'sample_id': sampleId,
      if (maximumWidthMm != null) 'maximum_width_mm': maximumWidthMm,
      if (minimumWidthMm != null) 'minimum_width_mm': minimumWidthMm,
      if (equivalentDiameterMm != null)
        'equivalent_diameter_mm': equivalentDiameterMm,
      if (outerCircumferenceMm != null)
        'outer_circumference_mm': outerCircumferenceMm,
      if (calibrationId != null) 'calibration_id': calibrationId,
      if (algorithmVersion != null) 'algorithm_version': algorithmVersion,
      if (calculatedAt != null) 'calculated_at': calculatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MeasurementsCompanion copyWith({
    Value<String>? id,
    Value<String>? sampleId,
    Value<double?>? maximumWidthMm,
    Value<double?>? minimumWidthMm,
    Value<double?>? equivalentDiameterMm,
    Value<double?>? outerCircumferenceMm,
    Value<String>? calibrationId,
    Value<String>? algorithmVersion,
    Value<DateTime>? calculatedAt,
    Value<int>? rowid,
  }) {
    return MeasurementsCompanion(
      id: id ?? this.id,
      sampleId: sampleId ?? this.sampleId,
      maximumWidthMm: maximumWidthMm ?? this.maximumWidthMm,
      minimumWidthMm: minimumWidthMm ?? this.minimumWidthMm,
      equivalentDiameterMm: equivalentDiameterMm ?? this.equivalentDiameterMm,
      outerCircumferenceMm: outerCircumferenceMm ?? this.outerCircumferenceMm,
      calibrationId: calibrationId ?? this.calibrationId,
      algorithmVersion: algorithmVersion ?? this.algorithmVersion,
      calculatedAt: calculatedAt ?? this.calculatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sampleId.present) {
      map['sample_id'] = Variable<String>(sampleId.value);
    }
    if (maximumWidthMm.present) {
      map['maximum_width_mm'] = Variable<double>(maximumWidthMm.value);
    }
    if (minimumWidthMm.present) {
      map['minimum_width_mm'] = Variable<double>(minimumWidthMm.value);
    }
    if (equivalentDiameterMm.present) {
      map['equivalent_diameter_mm'] = Variable<double>(
        equivalentDiameterMm.value,
      );
    }
    if (outerCircumferenceMm.present) {
      map['outer_circumference_mm'] = Variable<double>(
        outerCircumferenceMm.value,
      );
    }
    if (calibrationId.present) {
      map['calibration_id'] = Variable<String>(calibrationId.value);
    }
    if (algorithmVersion.present) {
      map['algorithm_version'] = Variable<String>(algorithmVersion.value);
    }
    if (calculatedAt.present) {
      map['calculated_at'] = Variable<DateTime>(calculatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeasurementsCompanion(')
          ..write('id: $id, ')
          ..write('sampleId: $sampleId, ')
          ..write('maximumWidthMm: $maximumWidthMm, ')
          ..write('minimumWidthMm: $minimumWidthMm, ')
          ..write('equivalentDiameterMm: $equivalentDiameterMm, ')
          ..write('outerCircumferenceMm: $outerCircumferenceMm, ')
          ..write('calibrationId: $calibrationId, ')
          ..write('algorithmVersion: $algorithmVersion, ')
          ..write('calculatedAt: $calculatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FinishingResultsTable extends FinishingResults
    with TableInfo<$FinishingResultsTable, DbFinishingResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinishingResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _sampleIdMeta = const VerificationMeta(
    'sampleId',
  );
  @override
  late final GeneratedColumn<String> sampleId = GeneratedColumn<String>(
    'sample_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES samples (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _qualityMeta = const VerificationMeta(
    'quality',
  );
  @override
  late final GeneratedColumn<String> quality = GeneratedColumn<String>(
    'quality',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    true,
    check: () => ComparableExpr(confidence).isBetweenValues(0, 1),
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _modelIdMeta = const VerificationMeta(
    'modelId',
  );
  @override
  late final GeneratedColumn<String> modelId = GeneratedColumn<String>(
    'model_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES model_metadata (id)',
    ),
  );
  static const VerificationMeta _analyzedAtMeta = const VerificationMeta(
    'analyzedAt',
  );
  @override
  late final GeneratedColumn<DateTime> analyzedAt = GeneratedColumn<DateTime>(
    'analyzed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sampleId,
    quality,
    confidence,
    modelId,
    analyzedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'finishing_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbFinishingResult> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sample_id')) {
      context.handle(
        _sampleIdMeta,
        sampleId.isAcceptableOrUnknown(data['sample_id']!, _sampleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sampleIdMeta);
    }
    if (data.containsKey('quality')) {
      context.handle(
        _qualityMeta,
        quality.isAcceptableOrUnknown(data['quality']!, _qualityMeta),
      );
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('model_id')) {
      context.handle(
        _modelIdMeta,
        modelId.isAcceptableOrUnknown(data['model_id']!, _modelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_modelIdMeta);
    }
    if (data.containsKey('analyzed_at')) {
      context.handle(
        _analyzedAtMeta,
        analyzedAt.isAcceptableOrUnknown(data['analyzed_at']!, _analyzedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_analyzedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbFinishingResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbFinishingResult(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sampleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sample_id'],
      )!,
      quality: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quality'],
      ),
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      ),
      modelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_id'],
      )!,
      analyzedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}analyzed_at'],
      )!,
    );
  }

  @override
  $FinishingResultsTable createAlias(String alias) {
    return $FinishingResultsTable(attachedDatabase, alias);
  }
}

class DbFinishingResult extends DataClass
    implements Insertable<DbFinishingResult> {
  final String id;
  final String sampleId;
  final String? quality;
  final double? confidence;
  final String modelId;
  final DateTime analyzedAt;
  const DbFinishingResult({
    required this.id,
    required this.sampleId,
    this.quality,
    this.confidence,
    required this.modelId,
    required this.analyzedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sample_id'] = Variable<String>(sampleId);
    if (!nullToAbsent || quality != null) {
      map['quality'] = Variable<String>(quality);
    }
    if (!nullToAbsent || confidence != null) {
      map['confidence'] = Variable<double>(confidence);
    }
    map['model_id'] = Variable<String>(modelId);
    map['analyzed_at'] = Variable<DateTime>(analyzedAt);
    return map;
  }

  FinishingResultsCompanion toCompanion(bool nullToAbsent) {
    return FinishingResultsCompanion(
      id: Value(id),
      sampleId: Value(sampleId),
      quality: quality == null && nullToAbsent
          ? const Value.absent()
          : Value(quality),
      confidence: confidence == null && nullToAbsent
          ? const Value.absent()
          : Value(confidence),
      modelId: Value(modelId),
      analyzedAt: Value(analyzedAt),
    );
  }

  factory DbFinishingResult.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbFinishingResult(
      id: serializer.fromJson<String>(json['id']),
      sampleId: serializer.fromJson<String>(json['sampleId']),
      quality: serializer.fromJson<String?>(json['quality']),
      confidence: serializer.fromJson<double?>(json['confidence']),
      modelId: serializer.fromJson<String>(json['modelId']),
      analyzedAt: serializer.fromJson<DateTime>(json['analyzedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sampleId': serializer.toJson<String>(sampleId),
      'quality': serializer.toJson<String?>(quality),
      'confidence': serializer.toJson<double?>(confidence),
      'modelId': serializer.toJson<String>(modelId),
      'analyzedAt': serializer.toJson<DateTime>(analyzedAt),
    };
  }

  DbFinishingResult copyWith({
    String? id,
    String? sampleId,
    Value<String?> quality = const Value.absent(),
    Value<double?> confidence = const Value.absent(),
    String? modelId,
    DateTime? analyzedAt,
  }) => DbFinishingResult(
    id: id ?? this.id,
    sampleId: sampleId ?? this.sampleId,
    quality: quality.present ? quality.value : this.quality,
    confidence: confidence.present ? confidence.value : this.confidence,
    modelId: modelId ?? this.modelId,
    analyzedAt: analyzedAt ?? this.analyzedAt,
  );
  DbFinishingResult copyWithCompanion(FinishingResultsCompanion data) {
    return DbFinishingResult(
      id: data.id.present ? data.id.value : this.id,
      sampleId: data.sampleId.present ? data.sampleId.value : this.sampleId,
      quality: data.quality.present ? data.quality.value : this.quality,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      modelId: data.modelId.present ? data.modelId.value : this.modelId,
      analyzedAt: data.analyzedAt.present
          ? data.analyzedAt.value
          : this.analyzedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbFinishingResult(')
          ..write('id: $id, ')
          ..write('sampleId: $sampleId, ')
          ..write('quality: $quality, ')
          ..write('confidence: $confidence, ')
          ..write('modelId: $modelId, ')
          ..write('analyzedAt: $analyzedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sampleId, quality, confidence, modelId, analyzedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbFinishingResult &&
          other.id == this.id &&
          other.sampleId == this.sampleId &&
          other.quality == this.quality &&
          other.confidence == this.confidence &&
          other.modelId == this.modelId &&
          other.analyzedAt == this.analyzedAt);
}

class FinishingResultsCompanion extends UpdateCompanion<DbFinishingResult> {
  final Value<String> id;
  final Value<String> sampleId;
  final Value<String?> quality;
  final Value<double?> confidence;
  final Value<String> modelId;
  final Value<DateTime> analyzedAt;
  final Value<int> rowid;
  const FinishingResultsCompanion({
    this.id = const Value.absent(),
    this.sampleId = const Value.absent(),
    this.quality = const Value.absent(),
    this.confidence = const Value.absent(),
    this.modelId = const Value.absent(),
    this.analyzedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FinishingResultsCompanion.insert({
    this.id = const Value.absent(),
    required String sampleId,
    this.quality = const Value.absent(),
    this.confidence = const Value.absent(),
    required String modelId,
    required DateTime analyzedAt,
    this.rowid = const Value.absent(),
  }) : sampleId = Value(sampleId),
       modelId = Value(modelId),
       analyzedAt = Value(analyzedAt);
  static Insertable<DbFinishingResult> custom({
    Expression<String>? id,
    Expression<String>? sampleId,
    Expression<String>? quality,
    Expression<double>? confidence,
    Expression<String>? modelId,
    Expression<DateTime>? analyzedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sampleId != null) 'sample_id': sampleId,
      if (quality != null) 'quality': quality,
      if (confidence != null) 'confidence': confidence,
      if (modelId != null) 'model_id': modelId,
      if (analyzedAt != null) 'analyzed_at': analyzedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FinishingResultsCompanion copyWith({
    Value<String>? id,
    Value<String>? sampleId,
    Value<String?>? quality,
    Value<double?>? confidence,
    Value<String>? modelId,
    Value<DateTime>? analyzedAt,
    Value<int>? rowid,
  }) {
    return FinishingResultsCompanion(
      id: id ?? this.id,
      sampleId: sampleId ?? this.sampleId,
      quality: quality ?? this.quality,
      confidence: confidence ?? this.confidence,
      modelId: modelId ?? this.modelId,
      analyzedAt: analyzedAt ?? this.analyzedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sampleId.present) {
      map['sample_id'] = Variable<String>(sampleId.value);
    }
    if (quality.present) {
      map['quality'] = Variable<String>(quality.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (modelId.present) {
      map['model_id'] = Variable<String>(modelId.value);
    }
    if (analyzedAt.present) {
      map['analyzed_at'] = Variable<DateTime>(analyzedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinishingResultsCompanion(')
          ..write('id: $id, ')
          ..write('sampleId: $sampleId, ')
          ..write('quality: $quality, ')
          ..write('confidence: $confidence, ')
          ..write('modelId: $modelId, ')
          ..write('analyzedAt: $analyzedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncJobsTable extends SyncJobs
    with TableInfo<$SyncJobsTable, DbSyncJob> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncJobsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _sampleIdMeta = const VerificationMeta(
    'sampleId',
  );
  @override
  late final GeneratedColumn<String> sampleId = GeneratedColumn<String>(
    'sample_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES samples (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    check: () =>
        status.isIn(['pending', 'uploading', 'synced', 'failed', 'conflict']),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    check: () => ComparableExpr(revision).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idempotencyKeyMeta = const VerificationMeta(
    'idempotencyKey',
  );
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
    'idempotency_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    check: () => ComparableExpr(attempts).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextAttemptAtMeta = const VerificationMeta(
    'nextAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextAttemptAt =
      GeneratedColumn<DateTime>(
        'next_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sampleId,
    status,
    revision,
    idempotencyKey,
    attempts,
    createdAt,
    updatedAt,
    lastError,
    nextAttemptAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_jobs';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbSyncJob> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sample_id')) {
      context.handle(
        _sampleIdMeta,
        sampleId.isAcceptableOrUnknown(data['sample_id']!, _sampleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sampleIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionMeta);
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
        _idempotencyKeyMeta,
        idempotencyKey.isAcceptableOrUnknown(
          data['idempotency_key']!,
          _idempotencyKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('next_attempt_at')) {
      context.handle(
        _nextAttemptAtMeta,
        nextAttemptAt.isAcceptableOrUnknown(
          data['next_attempt_at']!,
          _nextAttemptAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbSyncJob map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbSyncJob(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sampleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sample_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      idempotencyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idempotency_key'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      nextAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_attempt_at'],
      ),
    );
  }

  @override
  $SyncJobsTable createAlias(String alias) {
    return $SyncJobsTable(attachedDatabase, alias);
  }
}

class DbSyncJob extends DataClass implements Insertable<DbSyncJob> {
  final String id;
  final String sampleId;
  final String status;
  final int revision;
  final String idempotencyKey;
  final int attempts;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? lastError;
  final DateTime? nextAttemptAt;
  const DbSyncJob({
    required this.id,
    required this.sampleId,
    required this.status,
    required this.revision,
    required this.idempotencyKey,
    required this.attempts,
    required this.createdAt,
    required this.updatedAt,
    this.lastError,
    this.nextAttemptAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sample_id'] = Variable<String>(sampleId);
    map['status'] = Variable<String>(status);
    map['revision'] = Variable<int>(revision);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['attempts'] = Variable<int>(attempts);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    if (!nullToAbsent || nextAttemptAt != null) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt);
    }
    return map;
  }

  SyncJobsCompanion toCompanion(bool nullToAbsent) {
    return SyncJobsCompanion(
      id: Value(id),
      sampleId: Value(sampleId),
      status: Value(status),
      revision: Value(revision),
      idempotencyKey: Value(idempotencyKey),
      attempts: Value(attempts),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      nextAttemptAt: nextAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAttemptAt),
    );
  }

  factory DbSyncJob.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbSyncJob(
      id: serializer.fromJson<String>(json['id']),
      sampleId: serializer.fromJson<String>(json['sampleId']),
      status: serializer.fromJson<String>(json['status']),
      revision: serializer.fromJson<int>(json['revision']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      attempts: serializer.fromJson<int>(json['attempts']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      nextAttemptAt: serializer.fromJson<DateTime?>(json['nextAttemptAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sampleId': serializer.toJson<String>(sampleId),
      'status': serializer.toJson<String>(status),
      'revision': serializer.toJson<int>(revision),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'attempts': serializer.toJson<int>(attempts),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastError': serializer.toJson<String?>(lastError),
      'nextAttemptAt': serializer.toJson<DateTime?>(nextAttemptAt),
    };
  }

  DbSyncJob copyWith({
    String? id,
    String? sampleId,
    String? status,
    int? revision,
    String? idempotencyKey,
    int? attempts,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<String?> lastError = const Value.absent(),
    Value<DateTime?> nextAttemptAt = const Value.absent(),
  }) => DbSyncJob(
    id: id ?? this.id,
    sampleId: sampleId ?? this.sampleId,
    status: status ?? this.status,
    revision: revision ?? this.revision,
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    attempts: attempts ?? this.attempts,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    lastError: lastError.present ? lastError.value : this.lastError,
    nextAttemptAt: nextAttemptAt.present
        ? nextAttemptAt.value
        : this.nextAttemptAt,
  );
  DbSyncJob copyWithCompanion(SyncJobsCompanion data) {
    return DbSyncJob(
      id: data.id.present ? data.id.value : this.id,
      sampleId: data.sampleId.present ? data.sampleId.value : this.sampleId,
      status: data.status.present ? data.status.value : this.status,
      revision: data.revision.present ? data.revision.value : this.revision,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      nextAttemptAt: data.nextAttemptAt.present
          ? data.nextAttemptAt.value
          : this.nextAttemptAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbSyncJob(')
          ..write('id: $id, ')
          ..write('sampleId: $sampleId, ')
          ..write('status: $status, ')
          ..write('revision: $revision, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('attempts: $attempts, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastError: $lastError, ')
          ..write('nextAttemptAt: $nextAttemptAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sampleId,
    status,
    revision,
    idempotencyKey,
    attempts,
    createdAt,
    updatedAt,
    lastError,
    nextAttemptAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbSyncJob &&
          other.id == this.id &&
          other.sampleId == this.sampleId &&
          other.status == this.status &&
          other.revision == this.revision &&
          other.idempotencyKey == this.idempotencyKey &&
          other.attempts == this.attempts &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastError == this.lastError &&
          other.nextAttemptAt == this.nextAttemptAt);
}

class SyncJobsCompanion extends UpdateCompanion<DbSyncJob> {
  final Value<String> id;
  final Value<String> sampleId;
  final Value<String> status;
  final Value<int> revision;
  final Value<String> idempotencyKey;
  final Value<int> attempts;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> lastError;
  final Value<DateTime?> nextAttemptAt;
  final Value<int> rowid;
  const SyncJobsCompanion({
    this.id = const Value.absent(),
    this.sampleId = const Value.absent(),
    this.status = const Value.absent(),
    this.revision = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.attempts = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncJobsCompanion.insert({
    this.id = const Value.absent(),
    required String sampleId,
    this.status = const Value.absent(),
    required int revision,
    required String idempotencyKey,
    this.attempts = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.lastError = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : sampleId = Value(sampleId),
       revision = Value(revision),
       idempotencyKey = Value(idempotencyKey),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<DbSyncJob> custom({
    Expression<String>? id,
    Expression<String>? sampleId,
    Expression<String>? status,
    Expression<int>? revision,
    Expression<String>? idempotencyKey,
    Expression<int>? attempts,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? lastError,
    Expression<DateTime>? nextAttemptAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sampleId != null) 'sample_id': sampleId,
      if (status != null) 'status': status,
      if (revision != null) 'revision': revision,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (attempts != null) 'attempts': attempts,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastError != null) 'last_error': lastError,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncJobsCompanion copyWith({
    Value<String>? id,
    Value<String>? sampleId,
    Value<String>? status,
    Value<int>? revision,
    Value<String>? idempotencyKey,
    Value<int>? attempts,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String?>? lastError,
    Value<DateTime?>? nextAttemptAt,
    Value<int>? rowid,
  }) {
    return SyncJobsCompanion(
      id: id ?? this.id,
      sampleId: sampleId ?? this.sampleId,
      status: status ?? this.status,
      revision: revision ?? this.revision,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      attempts: attempts ?? this.attempts,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastError: lastError ?? this.lastError,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sampleId.present) {
      map['sample_id'] = Variable<String>(sampleId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncJobsCompanion(')
          ..write('id: $id, ')
          ..write('sampleId: $sampleId, ')
          ..write('status: $status, ')
          ..write('revision: $revision, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('attempts: $attempts, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastError: $lastError, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserPreferencesTable extends UserPreferences
    with TableInfo<$UserPreferencesTable, DbUserPreference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbUserPreference> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbUserPreference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbUserPreference(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserPreferencesTable createAlias(String alias) {
    return $UserPreferencesTable(attachedDatabase, alias);
  }
}

class DbUserPreference extends DataClass
    implements Insertable<DbUserPreference> {
  final String id;
  final String key;
  final String value;
  final DateTime updatedAt;
  const DbUserPreference({
    required this.id,
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserPreferencesCompanion toCompanion(bool nullToAbsent) {
    return UserPreferencesCompanion(
      id: Value(id),
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory DbUserPreference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbUserPreference(
      id: serializer.fromJson<String>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DbUserPreference copyWith({
    String? id,
    String? key,
    String? value,
    DateTime? updatedAt,
  }) => DbUserPreference(
    id: id ?? this.id,
    key: key ?? this.key,
    value: value ?? this.value,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DbUserPreference copyWithCompanion(UserPreferencesCompanion data) {
    return DbUserPreference(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbUserPreference(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbUserPreference &&
          other.id == this.id &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class UserPreferencesCompanion extends UpdateCompanion<DbUserPreference> {
  final Value<String> id;
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UserPreferencesCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserPreferencesCompanion.insert({
    this.id = const Value.absent(),
    required String key,
    required String value,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value),
       updatedAt = Value(updatedAt);
  static Insertable<DbUserPreference> custom({
    Expression<String>? id,
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserPreferencesCompanion copyWith({
    Value<String>? id,
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserPreferencesCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserPreferencesCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudyNotesTable extends StudyNotes
    with TableInfo<$StudyNotesTable, DbStudyNote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudyNotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _gradeIdMeta = const VerificationMeta(
    'gradeId',
  );
  @override
  late final GeneratedColumn<String> gradeId = GeneratedColumn<String>(
    'grade_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, gradeId, note, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbStudyNote> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('grade_id')) {
      context.handle(
        _gradeIdMeta,
        gradeId.isAcceptableOrUnknown(data['grade_id']!, _gradeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gradeIdMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    } else if (isInserting) {
      context.missing(_noteMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbStudyNote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbStudyNote(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      gradeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grade_id'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $StudyNotesTable createAlias(String alias) {
    return $StudyNotesTable(attachedDatabase, alias);
  }
}

class DbStudyNote extends DataClass implements Insertable<DbStudyNote> {
  final String id;
  final String gradeId;
  final String note;
  final DateTime updatedAt;
  const DbStudyNote({
    required this.id,
    required this.gradeId,
    required this.note,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['grade_id'] = Variable<String>(gradeId);
    map['note'] = Variable<String>(note);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  StudyNotesCompanion toCompanion(bool nullToAbsent) {
    return StudyNotesCompanion(
      id: Value(id),
      gradeId: Value(gradeId),
      note: Value(note),
      updatedAt: Value(updatedAt),
    );
  }

  factory DbStudyNote.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbStudyNote(
      id: serializer.fromJson<String>(json['id']),
      gradeId: serializer.fromJson<String>(json['gradeId']),
      note: serializer.fromJson<String>(json['note']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'gradeId': serializer.toJson<String>(gradeId),
      'note': serializer.toJson<String>(note),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DbStudyNote copyWith({
    String? id,
    String? gradeId,
    String? note,
    DateTime? updatedAt,
  }) => DbStudyNote(
    id: id ?? this.id,
    gradeId: gradeId ?? this.gradeId,
    note: note ?? this.note,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DbStudyNote copyWithCompanion(StudyNotesCompanion data) {
    return DbStudyNote(
      id: data.id.present ? data.id.value : this.id,
      gradeId: data.gradeId.present ? data.gradeId.value : this.gradeId,
      note: data.note.present ? data.note.value : this.note,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbStudyNote(')
          ..write('id: $id, ')
          ..write('gradeId: $gradeId, ')
          ..write('note: $note, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, gradeId, note, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbStudyNote &&
          other.id == this.id &&
          other.gradeId == this.gradeId &&
          other.note == this.note &&
          other.updatedAt == this.updatedAt);
}

class StudyNotesCompanion extends UpdateCompanion<DbStudyNote> {
  final Value<String> id;
  final Value<String> gradeId;
  final Value<String> note;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const StudyNotesCompanion({
    this.id = const Value.absent(),
    this.gradeId = const Value.absent(),
    this.note = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudyNotesCompanion.insert({
    this.id = const Value.absent(),
    required String gradeId,
    required String note,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : gradeId = Value(gradeId),
       note = Value(note),
       updatedAt = Value(updatedAt);
  static Insertable<DbStudyNote> custom({
    Expression<String>? id,
    Expression<String>? gradeId,
    Expression<String>? note,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gradeId != null) 'grade_id': gradeId,
      if (note != null) 'note': note,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudyNotesCompanion copyWith({
    Value<String>? id,
    Value<String>? gradeId,
    Value<String>? note,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return StudyNotesCompanion(
      id: id ?? this.id,
      gradeId: gradeId ?? this.gradeId,
      note: note ?? this.note,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (gradeId.present) {
      map['grade_id'] = Variable<String>(gradeId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudyNotesCompanion(')
          ..write('id: $id, ')
          ..write('gradeId: $gradeId, ')
          ..write('note: $note, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SamplesTable samples = $SamplesTable(this);
  late final $ModelMetadataTable modelMetadata = $ModelMetadataTable(this);
  late final $SampleImagesTable sampleImages = $SampleImagesTable(this);
  late final $CalibrationsTable calibrations = $CalibrationsTable(this);
  late final $MeasurementsTable measurements = $MeasurementsTable(this);
  late final $FinishingResultsTable finishingResults = $FinishingResultsTable(
    this,
  );
  late final $SyncJobsTable syncJobs = $SyncJobsTable(this);
  late final $UserPreferencesTable userPreferences = $UserPreferencesTable(
    this,
  );
  late final $StudyNotesTable studyNotes = $StudyNotesTable(this);
  late final Index samplesHistory = Index(
    'samples_history',
    'CREATE INDEX samples_history ON samples (deleted_at, captured_at)',
  );
  late final Index samplesSync = Index(
    'samples_sync',
    'CREATE INDEX samples_sync ON samples (deleted_at, sync_status)',
  );
  late final Index syncReady = Index(
    'sync_ready',
    'CREATE INDEX sync_ready ON sync_jobs (status, next_attempt_at, created_at)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    samples,
    modelMetadata,
    sampleImages,
    calibrations,
    measurements,
    finishingResults,
    syncJobs,
    userPreferences,
    studyNotes,
    samplesHistory,
    samplesSync,
    syncReady,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'samples',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sample_images', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'samples',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('measurements', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'samples',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('finishing_results', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'samples',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sync_jobs', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$SamplesTableCreateCompanionBuilder = SamplesCompanion Function({
  Value<String> id,
  required String code,
  Value<String?> batchId,
  required DateTime capturedAt,
  Value<String?> notes,
  Value<String> detectionStatus,
  Value<String> calibrationStatus,
  Value<String> syncStatus,
  Value<int> revision,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$SamplesTableUpdateCompanionBuilder = SamplesCompanion Function({
  Value<String> id,
  Value<String> code,
  Value<String?> batchId,
  Value<DateTime> capturedAt,
  Value<String?> notes,
  Value<String> detectionStatus,
  Value<String> calibrationStatus,
  Value<String> syncStatus,
  Value<int> revision,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

final class $$SamplesTableReferences
    extends BaseReferences<_$AppDatabase, $SamplesTable, DbSample> {
  $$SamplesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SampleImagesTable, List<DbSampleImage>>
  _sampleImagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sampleImages,
    aliasName: 'samples__id__sample_images__sample_id',
  );

  $$SampleImagesTableProcessedTableManager get sampleImagesRefs {
    final manager = $$SampleImagesTableTableManager(
      $_db,
      $_db.sampleImages,
    ).filter((f) => f.sampleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sampleImagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MeasurementsTable, List<DbMeasurement>>
  _measurementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.measurements,
    aliasName: 'samples__id__measurements__sample_id',
  );

  $$MeasurementsTableProcessedTableManager get measurementsRefs {
    final manager = $$MeasurementsTableTableManager(
      $_db,
      $_db.measurements,
    ).filter((f) => f.sampleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_measurementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FinishingResultsTable, List<DbFinishingResult>>
  _finishingResultsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.finishingResults,
    aliasName: 'samples__id__finishing_results__sample_id',
  );

  $$FinishingResultsTableProcessedTableManager get finishingResultsRefs {
    final manager = $$FinishingResultsTableTableManager(
      $_db,
      $_db.finishingResults,
    ).filter((f) => f.sampleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _finishingResultsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SyncJobsTable, List<DbSyncJob>>
  _syncJobsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.syncJobs,
    aliasName: 'samples__id__sync_jobs__sample_id',
  );

  $$SyncJobsTableProcessedTableManager get syncJobsRefs {
    final manager = $$SyncJobsTableTableManager(
      $_db,
      $_db.syncJobs,
    ).filter((f) => f.sampleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_syncJobsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SamplesTableFilterComposer
    extends Composer<_$AppDatabase, $SamplesTable> {
  $$SamplesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get batchId => $composableBuilder(
    column: $table.batchId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detectionStatus => $composableBuilder(
    column: $table.detectionStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get calibrationStatus => $composableBuilder(
    column: $table.calibrationStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> sampleImagesRefs(
    Expression<bool> Function($$SampleImagesTableFilterComposer f) f,
  ) {
    final $$SampleImagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sampleImages,
      getReferencedColumn: (t) => t.sampleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SampleImagesTableFilterComposer(
            $db: $db,
            $table: $db.sampleImages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> measurementsRefs(
    Expression<bool> Function($$MeasurementsTableFilterComposer f) f,
  ) {
    final $$MeasurementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.measurements,
      getReferencedColumn: (t) => t.sampleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeasurementsTableFilterComposer(
            $db: $db,
            $table: $db.measurements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> finishingResultsRefs(
    Expression<bool> Function($$FinishingResultsTableFilterComposer f) f,
  ) {
    final $$FinishingResultsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.finishingResults,
      getReferencedColumn: (t) => t.sampleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinishingResultsTableFilterComposer(
            $db: $db,
            $table: $db.finishingResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> syncJobsRefs(
    Expression<bool> Function($$SyncJobsTableFilterComposer f) f,
  ) {
    final $$SyncJobsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.syncJobs,
      getReferencedColumn: (t) => t.sampleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SyncJobsTableFilterComposer(
            $db: $db,
            $table: $db.syncJobs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SamplesTableOrderingComposer
    extends Composer<_$AppDatabase, $SamplesTable> {
  $$SamplesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get batchId => $composableBuilder(
    column: $table.batchId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detectionStatus => $composableBuilder(
    column: $table.detectionStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get calibrationStatus => $composableBuilder(
    column: $table.calibrationStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SamplesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SamplesTable> {
  $$SamplesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get batchId =>
      $composableBuilder(column: $table.batchId, builder: (column) => column);

  GeneratedColumn<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get detectionStatus => $composableBuilder(
    column: $table.detectionStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get calibrationStatus => $composableBuilder(
    column: $table.calibrationStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  Expression<T> sampleImagesRefs<T extends Object>(
    Expression<T> Function($$SampleImagesTableAnnotationComposer a) f,
  ) {
    final $$SampleImagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sampleImages,
      getReferencedColumn: (t) => t.sampleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SampleImagesTableAnnotationComposer(
            $db: $db,
            $table: $db.sampleImages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> measurementsRefs<T extends Object>(
    Expression<T> Function($$MeasurementsTableAnnotationComposer a) f,
  ) {
    final $$MeasurementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.measurements,
      getReferencedColumn: (t) => t.sampleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeasurementsTableAnnotationComposer(
            $db: $db,
            $table: $db.measurements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> finishingResultsRefs<T extends Object>(
    Expression<T> Function($$FinishingResultsTableAnnotationComposer a) f,
  ) {
    final $$FinishingResultsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.finishingResults,
      getReferencedColumn: (t) => t.sampleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinishingResultsTableAnnotationComposer(
            $db: $db,
            $table: $db.finishingResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> syncJobsRefs<T extends Object>(
    Expression<T> Function($$SyncJobsTableAnnotationComposer a) f,
  ) {
    final $$SyncJobsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.syncJobs,
      getReferencedColumn: (t) => t.sampleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SyncJobsTableAnnotationComposer(
            $db: $db,
            $table: $db.syncJobs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SamplesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SamplesTable,
          DbSample,
          $$SamplesTableFilterComposer,
          $$SamplesTableOrderingComposer,
          $$SamplesTableAnnotationComposer,
          $$SamplesTableCreateCompanionBuilder,
          $$SamplesTableUpdateCompanionBuilder,
          (DbSample, $$SamplesTableReferences),
          DbSample,
          PrefetchHooks Function({
            bool sampleImagesRefs,
            bool measurementsRefs,
            bool finishingResultsRefs,
            bool syncJobsRefs,
          })
        > {
  $$SamplesTableTableManager(_$AppDatabase db, $SamplesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SamplesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SamplesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SamplesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String?> batchId = const Value.absent(),
                Value<DateTime> capturedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> detectionStatus = const Value.absent(),
                Value<String> calibrationStatus = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SamplesCompanion(
                id: id,
                code: code,
                batchId: batchId,
                capturedAt: capturedAt,
                notes: notes,
                detectionStatus: detectionStatus,
                calibrationStatus: calibrationStatus,
                syncStatus: syncStatus,
                revision: revision,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String code,
                Value<String?> batchId = const Value.absent(),
                required DateTime capturedAt,
                Value<String?> notes = const Value.absent(),
                Value<String> detectionStatus = const Value.absent(),
                Value<String> calibrationStatus = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> revision = const Value.absent(),
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SamplesCompanion.insert(
                id: id,
                code: code,
                batchId: batchId,
                capturedAt: capturedAt,
                notes: notes,
                detectionStatus: detectionStatus,
                calibrationStatus: calibrationStatus,
                syncStatus: syncStatus,
                revision: revision,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SamplesTable, DbSample>(table),
                  $$SamplesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                sampleImagesRefs = false,
                measurementsRefs = false,
                finishingResultsRefs = false,
                syncJobsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sampleImagesRefs) db.sampleImages,
                    if (measurementsRefs) db.measurements,
                    if (finishingResultsRefs) db.finishingResults,
                    if (syncJobsRefs) db.syncJobs,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sampleImagesRefs)
                        await $_getPrefetchedDataByColumns<
                          DbSample,
                          $SamplesTable,
                          DbSampleImage,
                          $SampleImagesTable
                        >(
                          currentTable: table,
                          referencedTable: $$SamplesTableReferences
                              ._sampleImagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SamplesTableReferences(
                                db,
                                table,
                                p0,
                              ).sampleImagesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'sample_id',
                          typedResults: items,
                        ),
                      if (measurementsRefs)
                        await $_getPrefetchedDataByColumns<
                          DbSample,
                          $SamplesTable,
                          DbMeasurement,
                          $MeasurementsTable
                        >(
                          currentTable: table,
                          referencedTable: $$SamplesTableReferences
                              ._measurementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SamplesTableReferences(
                                db,
                                table,
                                p0,
                              ).measurementsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'sample_id',
                          typedResults: items,
                        ),
                      if (finishingResultsRefs)
                        await $_getPrefetchedDataByColumns<
                          DbSample,
                          $SamplesTable,
                          DbFinishingResult,
                          $FinishingResultsTable
                        >(
                          currentTable: table,
                          referencedTable: $$SamplesTableReferences
                              ._finishingResultsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SamplesTableReferences(
                                db,
                                table,
                                p0,
                              ).finishingResultsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'sample_id',
                          typedResults: items,
                        ),
                      if (syncJobsRefs)
                        await $_getPrefetchedDataByColumns<
                          DbSample,
                          $SamplesTable,
                          DbSyncJob,
                          $SyncJobsTable
                        >(
                          currentTable: table,
                          referencedTable: $$SamplesTableReferences
                              ._syncJobsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SamplesTableReferences(
                                db,
                                table,
                                p0,
                              ).syncJobsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'sample_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SamplesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SamplesTable,
      DbSample,
      $$SamplesTableFilterComposer,
      $$SamplesTableOrderingComposer,
      $$SamplesTableAnnotationComposer,
      $$SamplesTableCreateCompanionBuilder,
      $$SamplesTableUpdateCompanionBuilder,
      (DbSample, $$SamplesTableReferences),
      DbSample,
      PrefetchHooks Function({
        bool sampleImagesRefs,
        bool measurementsRefs,
        bool finishingResultsRefs,
        bool syncJobsRefs,
      })
    >;
typedef $$ModelMetadataTableCreateCompanionBuilder =
    ModelMetadataCompanion Function({
      Value<String> id,
      required String kind,
      required String version,
      Value<String?> localPath,
      Value<String?> sha256,
      Value<bool> installed,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ModelMetadataTableUpdateCompanionBuilder =
    ModelMetadataCompanion Function({
      Value<String> id,
      Value<String> kind,
      Value<String> version,
      Value<String?> localPath,
      Value<String?> sha256,
      Value<bool> installed,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ModelMetadataTableReferences
    extends
        BaseReferences<_$AppDatabase, $ModelMetadataTable, DbModelMetadata> {
  $$ModelMetadataTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$SampleImagesTable, List<DbSampleImage>>
  _sampleImagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sampleImages,
    aliasName: 'model_metadata__id__sample_images__detector_model_id',
  );

  $$SampleImagesTableProcessedTableManager get sampleImagesRefs {
    final manager = $$SampleImagesTableTableManager($_db, $_db.sampleImages)
        .filter(
          (f) => f.detectorModelId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_sampleImagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FinishingResultsTable, List<DbFinishingResult>>
  _finishingResultsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.finishingResults,
    aliasName: 'model_metadata__id__finishing_results__model_id',
  );

  $$FinishingResultsTableProcessedTableManager get finishingResultsRefs {
    final manager = $$FinishingResultsTableTableManager(
      $_db,
      $_db.finishingResults,
    ).filter((f) => f.modelId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _finishingResultsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ModelMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $ModelMetadataTable> {
  $$ModelMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sha256 => $composableBuilder(
    column: $table.sha256,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get installed => $composableBuilder(
    column: $table.installed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> sampleImagesRefs(
    Expression<bool> Function($$SampleImagesTableFilterComposer f) f,
  ) {
    final $$SampleImagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sampleImages,
      getReferencedColumn: (t) => t.detectorModelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SampleImagesTableFilterComposer(
            $db: $db,
            $table: $db.sampleImages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> finishingResultsRefs(
    Expression<bool> Function($$FinishingResultsTableFilterComposer f) f,
  ) {
    final $$FinishingResultsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.finishingResults,
      getReferencedColumn: (t) => t.modelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinishingResultsTableFilterComposer(
            $db: $db,
            $table: $db.finishingResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ModelMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $ModelMetadataTable> {
  $$ModelMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sha256 => $composableBuilder(
    column: $table.sha256,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get installed => $composableBuilder(
    column: $table.installed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ModelMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $ModelMetadataTable> {
  $$ModelMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get sha256 =>
      $composableBuilder(column: $table.sha256, builder: (column) => column);

  GeneratedColumn<bool> get installed =>
      $composableBuilder(column: $table.installed, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> sampleImagesRefs<T extends Object>(
    Expression<T> Function($$SampleImagesTableAnnotationComposer a) f,
  ) {
    final $$SampleImagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sampleImages,
      getReferencedColumn: (t) => t.detectorModelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SampleImagesTableAnnotationComposer(
            $db: $db,
            $table: $db.sampleImages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> finishingResultsRefs<T extends Object>(
    Expression<T> Function($$FinishingResultsTableAnnotationComposer a) f,
  ) {
    final $$FinishingResultsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.finishingResults,
      getReferencedColumn: (t) => t.modelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinishingResultsTableAnnotationComposer(
            $db: $db,
            $table: $db.finishingResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ModelMetadataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ModelMetadataTable,
          DbModelMetadata,
          $$ModelMetadataTableFilterComposer,
          $$ModelMetadataTableOrderingComposer,
          $$ModelMetadataTableAnnotationComposer,
          $$ModelMetadataTableCreateCompanionBuilder,
          $$ModelMetadataTableUpdateCompanionBuilder,
          (DbModelMetadata, $$ModelMetadataTableReferences),
          DbModelMetadata,
          PrefetchHooks Function({
            bool sampleImagesRefs,
            bool finishingResultsRefs,
          })
        > {
  $$ModelMetadataTableTableManager(_$AppDatabase db, $ModelMetadataTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ModelMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ModelMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ModelMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> version = const Value.absent(),
                Value<String?> localPath = const Value.absent(),
                Value<String?> sha256 = const Value.absent(),
                Value<bool> installed = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ModelMetadataCompanion(
                id: id,
                kind: kind,
                version: version,
                localPath: localPath,
                sha256: sha256,
                installed: installed,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String kind,
                required String version,
                Value<String?> localPath = const Value.absent(),
                Value<String?> sha256 = const Value.absent(),
                Value<bool> installed = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ModelMetadataCompanion.insert(
                id: id,
                kind: kind,
                version: version,
                localPath: localPath,
                sha256: sha256,
                installed: installed,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ModelMetadataTable, DbModelMetadata>(table),
                  $$ModelMetadataTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({sampleImagesRefs = false, finishingResultsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sampleImagesRefs) db.sampleImages,
                    if (finishingResultsRefs) db.finishingResults,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sampleImagesRefs)
                        await $_getPrefetchedDataByColumns<
                          DbModelMetadata,
                          $ModelMetadataTable,
                          DbSampleImage,
                          $SampleImagesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ModelMetadataTableReferences
                              ._sampleImagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ModelMetadataTableReferences(
                                db,
                                table,
                                p0,
                              ).sampleImagesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'detector_model_id',
                          typedResults: items,
                        ),
                      if (finishingResultsRefs)
                        await $_getPrefetchedDataByColumns<
                          DbModelMetadata,
                          $ModelMetadataTable,
                          DbFinishingResult,
                          $FinishingResultsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ModelMetadataTableReferences
                              ._finishingResultsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ModelMetadataTableReferences(
                                db,
                                table,
                                p0,
                              ).finishingResultsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'model_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ModelMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ModelMetadataTable,
      DbModelMetadata,
      $$ModelMetadataTableFilterComposer,
      $$ModelMetadataTableOrderingComposer,
      $$ModelMetadataTableAnnotationComposer,
      $$ModelMetadataTableCreateCompanionBuilder,
      $$ModelMetadataTableUpdateCompanionBuilder,
      (DbModelMetadata, $$ModelMetadataTableReferences),
      DbModelMetadata,
      PrefetchHooks Function({bool sampleImagesRefs, bool finishingResultsRefs})
    >;
typedef $$SampleImagesTableCreateCompanionBuilder =
    SampleImagesCompanion Function({
      Value<String> id,
      required String sampleId,
      required String view,
      required String localPath,
      required int byteCount,
      Value<String?> detectorModelId,
      required DateTime validatedAt,
      Value<int> rowid,
    });
typedef $$SampleImagesTableUpdateCompanionBuilder =
    SampleImagesCompanion Function({
      Value<String> id,
      Value<String> sampleId,
      Value<String> view,
      Value<String> localPath,
      Value<int> byteCount,
      Value<String?> detectorModelId,
      Value<DateTime> validatedAt,
      Value<int> rowid,
    });

final class $$SampleImagesTableReferences
    extends BaseReferences<_$AppDatabase, $SampleImagesTable, DbSampleImage> {
  $$SampleImagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SamplesTable _sampleIdTable(_$AppDatabase db) =>
      db.samples.createAlias('sample_images__sample_id__samples__id');

  $$SamplesTableProcessedTableManager get sampleId {
    final $_column = $_itemColumn<String>('sample_id')!;

    final manager = $$SamplesTableTableManager(
      $_db,
      $_db.samples,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sampleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ModelMetadataTable _detectorModelIdTable(_$AppDatabase db) => db
      .modelMetadata
      .createAlias('sample_images__detector_model_id__model_metadata__id');

  $$ModelMetadataTableProcessedTableManager? get detectorModelId {
    final $_column = $_itemColumn<String>('detector_model_id');
    if ($_column == null) return null;
    final manager = $$ModelMetadataTableTableManager(
      $_db,
      $_db.modelMetadata,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_detectorModelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SampleImagesTableFilterComposer
    extends Composer<_$AppDatabase, $SampleImagesTable> {
  $$SampleImagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get view => $composableBuilder(
    column: $table.view,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get byteCount => $composableBuilder(
    column: $table.byteCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get validatedAt => $composableBuilder(
    column: $table.validatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SamplesTableFilterComposer get sampleId {
    final $$SamplesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sampleId,
      referencedTable: $db.samples,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SamplesTableFilterComposer(
            $db: $db,
            $table: $db.samples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ModelMetadataTableFilterComposer get detectorModelId {
    final $$ModelMetadataTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.detectorModelId,
      referencedTable: $db.modelMetadata,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelMetadataTableFilterComposer(
            $db: $db,
            $table: $db.modelMetadata,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SampleImagesTableOrderingComposer
    extends Composer<_$AppDatabase, $SampleImagesTable> {
  $$SampleImagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get view => $composableBuilder(
    column: $table.view,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get byteCount => $composableBuilder(
    column: $table.byteCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get validatedAt => $composableBuilder(
    column: $table.validatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SamplesTableOrderingComposer get sampleId {
    final $$SamplesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sampleId,
      referencedTable: $db.samples,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SamplesTableOrderingComposer(
            $db: $db,
            $table: $db.samples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ModelMetadataTableOrderingComposer get detectorModelId {
    final $$ModelMetadataTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.detectorModelId,
      referencedTable: $db.modelMetadata,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelMetadataTableOrderingComposer(
            $db: $db,
            $table: $db.modelMetadata,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SampleImagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SampleImagesTable> {
  $$SampleImagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get view =>
      $composableBuilder(column: $table.view, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<int> get byteCount =>
      $composableBuilder(column: $table.byteCount, builder: (column) => column);

  GeneratedColumn<DateTime> get validatedAt => $composableBuilder(
    column: $table.validatedAt,
    builder: (column) => column,
  );

  $$SamplesTableAnnotationComposer get sampleId {
    final $$SamplesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sampleId,
      referencedTable: $db.samples,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SamplesTableAnnotationComposer(
            $db: $db,
            $table: $db.samples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ModelMetadataTableAnnotationComposer get detectorModelId {
    final $$ModelMetadataTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.detectorModelId,
      referencedTable: $db.modelMetadata,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelMetadataTableAnnotationComposer(
            $db: $db,
            $table: $db.modelMetadata,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SampleImagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SampleImagesTable,
          DbSampleImage,
          $$SampleImagesTableFilterComposer,
          $$SampleImagesTableOrderingComposer,
          $$SampleImagesTableAnnotationComposer,
          $$SampleImagesTableCreateCompanionBuilder,
          $$SampleImagesTableUpdateCompanionBuilder,
          (DbSampleImage, $$SampleImagesTableReferences),
          DbSampleImage,
          PrefetchHooks Function({bool sampleId, bool detectorModelId})
        > {
  $$SampleImagesTableTableManager(_$AppDatabase db, $SampleImagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SampleImagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SampleImagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SampleImagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sampleId = const Value.absent(),
                Value<String> view = const Value.absent(),
                Value<String> localPath = const Value.absent(),
                Value<int> byteCount = const Value.absent(),
                Value<String?> detectorModelId = const Value.absent(),
                Value<DateTime> validatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SampleImagesCompanion(
                id: id,
                sampleId: sampleId,
                view: view,
                localPath: localPath,
                byteCount: byteCount,
                detectorModelId: detectorModelId,
                validatedAt: validatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String sampleId,
                required String view,
                required String localPath,
                required int byteCount,
                Value<String?> detectorModelId = const Value.absent(),
                required DateTime validatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SampleImagesCompanion.insert(
                id: id,
                sampleId: sampleId,
                view: view,
                localPath: localPath,
                byteCount: byteCount,
                detectorModelId: detectorModelId,
                validatedAt: validatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SampleImagesTable, DbSampleImage>(table),
                  $$SampleImagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sampleId = false, detectorModelId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sampleId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sampleId,
                        referencedTable: $$SampleImagesTableReferences
                            ._sampleIdTable(db),
                        referencedColumn: $$SampleImagesTableReferences
                            ._sampleIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (detectorModelId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.detectorModelId,
                        referencedTable: $$SampleImagesTableReferences
                            ._detectorModelIdTable(db),
                        referencedColumn: $$SampleImagesTableReferences
                            ._detectorModelIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SampleImagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SampleImagesTable,
      DbSampleImage,
      $$SampleImagesTableFilterComposer,
      $$SampleImagesTableOrderingComposer,
      $$SampleImagesTableAnnotationComposer,
      $$SampleImagesTableCreateCompanionBuilder,
      $$SampleImagesTableUpdateCompanionBuilder,
      (DbSampleImage, $$SampleImagesTableReferences),
      DbSampleImage,
      PrefetchHooks Function({bool sampleId, bool detectorModelId})
    >;
typedef $$CalibrationsTableCreateCompanionBuilder =
    CalibrationsCompanion Function({
      Value<String> id,
      required double markerSizeMm,
      required double pixelsPerMm,
      required String method,
      required DateTime calibratedAt,
      Value<int> rowid,
    });
typedef $$CalibrationsTableUpdateCompanionBuilder =
    CalibrationsCompanion Function({
      Value<String> id,
      Value<double> markerSizeMm,
      Value<double> pixelsPerMm,
      Value<String> method,
      Value<DateTime> calibratedAt,
      Value<int> rowid,
    });

final class $$CalibrationsTableReferences
    extends BaseReferences<_$AppDatabase, $CalibrationsTable, DbCalibration> {
  $$CalibrationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MeasurementsTable, List<DbMeasurement>>
  _measurementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.measurements,
    aliasName: 'calibrations__id__measurements__calibration_id',
  );

  $$MeasurementsTableProcessedTableManager get measurementsRefs {
    final manager = $$MeasurementsTableTableManager(
      $_db,
      $_db.measurements,
    ).filter((f) => f.calibrationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_measurementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CalibrationsTableFilterComposer
    extends Composer<_$AppDatabase, $CalibrationsTable> {
  $$CalibrationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get markerSizeMm => $composableBuilder(
    column: $table.markerSizeMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pixelsPerMm => $composableBuilder(
    column: $table.pixelsPerMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get calibratedAt => $composableBuilder(
    column: $table.calibratedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> measurementsRefs(
    Expression<bool> Function($$MeasurementsTableFilterComposer f) f,
  ) {
    final $$MeasurementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.measurements,
      getReferencedColumn: (t) => t.calibrationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeasurementsTableFilterComposer(
            $db: $db,
            $table: $db.measurements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CalibrationsTableOrderingComposer
    extends Composer<_$AppDatabase, $CalibrationsTable> {
  $$CalibrationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get markerSizeMm => $composableBuilder(
    column: $table.markerSizeMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pixelsPerMm => $composableBuilder(
    column: $table.pixelsPerMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get calibratedAt => $composableBuilder(
    column: $table.calibratedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CalibrationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CalibrationsTable> {
  $$CalibrationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get markerSizeMm => $composableBuilder(
    column: $table.markerSizeMm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get pixelsPerMm => $composableBuilder(
    column: $table.pixelsPerMm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<DateTime> get calibratedAt => $composableBuilder(
    column: $table.calibratedAt,
    builder: (column) => column,
  );

  Expression<T> measurementsRefs<T extends Object>(
    Expression<T> Function($$MeasurementsTableAnnotationComposer a) f,
  ) {
    final $$MeasurementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.measurements,
      getReferencedColumn: (t) => t.calibrationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeasurementsTableAnnotationComposer(
            $db: $db,
            $table: $db.measurements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CalibrationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CalibrationsTable,
          DbCalibration,
          $$CalibrationsTableFilterComposer,
          $$CalibrationsTableOrderingComposer,
          $$CalibrationsTableAnnotationComposer,
          $$CalibrationsTableCreateCompanionBuilder,
          $$CalibrationsTableUpdateCompanionBuilder,
          (DbCalibration, $$CalibrationsTableReferences),
          DbCalibration,
          PrefetchHooks Function({bool measurementsRefs})
        > {
  $$CalibrationsTableTableManager(_$AppDatabase db, $CalibrationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalibrationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CalibrationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CalibrationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<double> markerSizeMm = const Value.absent(),
                Value<double> pixelsPerMm = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<DateTime> calibratedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CalibrationsCompanion(
                id: id,
                markerSizeMm: markerSizeMm,
                pixelsPerMm: pixelsPerMm,
                method: method,
                calibratedAt: calibratedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required double markerSizeMm,
                required double pixelsPerMm,
                required String method,
                required DateTime calibratedAt,
                Value<int> rowid = const Value.absent(),
              }) => CalibrationsCompanion.insert(
                id: id,
                markerSizeMm: markerSizeMm,
                pixelsPerMm: pixelsPerMm,
                method: method,
                calibratedAt: calibratedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CalibrationsTable, DbCalibration>(table),
                  $$CalibrationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({measurementsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (measurementsRefs) db.measurements],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (measurementsRefs)
                    await $_getPrefetchedDataByColumns<
                      DbCalibration,
                      $CalibrationsTable,
                      DbMeasurement,
                      $MeasurementsTable
                    >(
                      currentTable: table,
                      referencedTable: $$CalibrationsTableReferences
                          ._measurementsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CalibrationsTableReferences(
                            db,
                            table,
                            p0,
                          ).measurementsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'calibration_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CalibrationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CalibrationsTable,
      DbCalibration,
      $$CalibrationsTableFilterComposer,
      $$CalibrationsTableOrderingComposer,
      $$CalibrationsTableAnnotationComposer,
      $$CalibrationsTableCreateCompanionBuilder,
      $$CalibrationsTableUpdateCompanionBuilder,
      (DbCalibration, $$CalibrationsTableReferences),
      DbCalibration,
      PrefetchHooks Function({bool measurementsRefs})
    >;
typedef $$MeasurementsTableCreateCompanionBuilder =
    MeasurementsCompanion Function({
      Value<String> id,
      required String sampleId,
      Value<double?> maximumWidthMm,
      Value<double?> minimumWidthMm,
      Value<double?> equivalentDiameterMm,
      Value<double?> outerCircumferenceMm,
      required String calibrationId,
      required String algorithmVersion,
      required DateTime calculatedAt,
      Value<int> rowid,
    });
typedef $$MeasurementsTableUpdateCompanionBuilder =
    MeasurementsCompanion Function({
      Value<String> id,
      Value<String> sampleId,
      Value<double?> maximumWidthMm,
      Value<double?> minimumWidthMm,
      Value<double?> equivalentDiameterMm,
      Value<double?> outerCircumferenceMm,
      Value<String> calibrationId,
      Value<String> algorithmVersion,
      Value<DateTime> calculatedAt,
      Value<int> rowid,
    });

final class $$MeasurementsTableReferences
    extends BaseReferences<_$AppDatabase, $MeasurementsTable, DbMeasurement> {
  $$MeasurementsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SamplesTable _sampleIdTable(_$AppDatabase db) =>
      db.samples.createAlias('measurements__sample_id__samples__id');

  $$SamplesTableProcessedTableManager get sampleId {
    final $_column = $_itemColumn<String>('sample_id')!;

    final manager = $$SamplesTableTableManager(
      $_db,
      $_db.samples,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sampleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CalibrationsTable _calibrationIdTable(_$AppDatabase db) => db
      .calibrations
      .createAlias('measurements__calibration_id__calibrations__id');

  $$CalibrationsTableProcessedTableManager get calibrationId {
    final $_column = $_itemColumn<String>('calibration_id')!;

    final manager = $$CalibrationsTableTableManager(
      $_db,
      $_db.calibrations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_calibrationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MeasurementsTableFilterComposer
    extends Composer<_$AppDatabase, $MeasurementsTable> {
  $$MeasurementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maximumWidthMm => $composableBuilder(
    column: $table.maximumWidthMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get minimumWidthMm => $composableBuilder(
    column: $table.minimumWidthMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get equivalentDiameterMm => $composableBuilder(
    column: $table.equivalentDiameterMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get outerCircumferenceMm => $composableBuilder(
    column: $table.outerCircumferenceMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get algorithmVersion => $composableBuilder(
    column: $table.algorithmVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get calculatedAt => $composableBuilder(
    column: $table.calculatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SamplesTableFilterComposer get sampleId {
    final $$SamplesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sampleId,
      referencedTable: $db.samples,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SamplesTableFilterComposer(
            $db: $db,
            $table: $db.samples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CalibrationsTableFilterComposer get calibrationId {
    final $$CalibrationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.calibrationId,
      referencedTable: $db.calibrations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalibrationsTableFilterComposer(
            $db: $db,
            $table: $db.calibrations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MeasurementsTableOrderingComposer
    extends Composer<_$AppDatabase, $MeasurementsTable> {
  $$MeasurementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maximumWidthMm => $composableBuilder(
    column: $table.maximumWidthMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get minimumWidthMm => $composableBuilder(
    column: $table.minimumWidthMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get equivalentDiameterMm => $composableBuilder(
    column: $table.equivalentDiameterMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get outerCircumferenceMm => $composableBuilder(
    column: $table.outerCircumferenceMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get algorithmVersion => $composableBuilder(
    column: $table.algorithmVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get calculatedAt => $composableBuilder(
    column: $table.calculatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SamplesTableOrderingComposer get sampleId {
    final $$SamplesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sampleId,
      referencedTable: $db.samples,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SamplesTableOrderingComposer(
            $db: $db,
            $table: $db.samples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CalibrationsTableOrderingComposer get calibrationId {
    final $$CalibrationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.calibrationId,
      referencedTable: $db.calibrations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalibrationsTableOrderingComposer(
            $db: $db,
            $table: $db.calibrations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MeasurementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MeasurementsTable> {
  $$MeasurementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get maximumWidthMm => $composableBuilder(
    column: $table.maximumWidthMm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get minimumWidthMm => $composableBuilder(
    column: $table.minimumWidthMm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get equivalentDiameterMm => $composableBuilder(
    column: $table.equivalentDiameterMm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get outerCircumferenceMm => $composableBuilder(
    column: $table.outerCircumferenceMm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get algorithmVersion => $composableBuilder(
    column: $table.algorithmVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get calculatedAt => $composableBuilder(
    column: $table.calculatedAt,
    builder: (column) => column,
  );

  $$SamplesTableAnnotationComposer get sampleId {
    final $$SamplesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sampleId,
      referencedTable: $db.samples,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SamplesTableAnnotationComposer(
            $db: $db,
            $table: $db.samples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CalibrationsTableAnnotationComposer get calibrationId {
    final $$CalibrationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.calibrationId,
      referencedTable: $db.calibrations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalibrationsTableAnnotationComposer(
            $db: $db,
            $table: $db.calibrations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MeasurementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MeasurementsTable,
          DbMeasurement,
          $$MeasurementsTableFilterComposer,
          $$MeasurementsTableOrderingComposer,
          $$MeasurementsTableAnnotationComposer,
          $$MeasurementsTableCreateCompanionBuilder,
          $$MeasurementsTableUpdateCompanionBuilder,
          (DbMeasurement, $$MeasurementsTableReferences),
          DbMeasurement,
          PrefetchHooks Function({bool sampleId, bool calibrationId})
        > {
  $$MeasurementsTableTableManager(_$AppDatabase db, $MeasurementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MeasurementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MeasurementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MeasurementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sampleId = const Value.absent(),
                Value<double?> maximumWidthMm = const Value.absent(),
                Value<double?> minimumWidthMm = const Value.absent(),
                Value<double?> equivalentDiameterMm = const Value.absent(),
                Value<double?> outerCircumferenceMm = const Value.absent(),
                Value<String> calibrationId = const Value.absent(),
                Value<String> algorithmVersion = const Value.absent(),
                Value<DateTime> calculatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MeasurementsCompanion(
                id: id,
                sampleId: sampleId,
                maximumWidthMm: maximumWidthMm,
                minimumWidthMm: minimumWidthMm,
                equivalentDiameterMm: equivalentDiameterMm,
                outerCircumferenceMm: outerCircumferenceMm,
                calibrationId: calibrationId,
                algorithmVersion: algorithmVersion,
                calculatedAt: calculatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String sampleId,
                Value<double?> maximumWidthMm = const Value.absent(),
                Value<double?> minimumWidthMm = const Value.absent(),
                Value<double?> equivalentDiameterMm = const Value.absent(),
                Value<double?> outerCircumferenceMm = const Value.absent(),
                required String calibrationId,
                required String algorithmVersion,
                required DateTime calculatedAt,
                Value<int> rowid = const Value.absent(),
              }) => MeasurementsCompanion.insert(
                id: id,
                sampleId: sampleId,
                maximumWidthMm: maximumWidthMm,
                minimumWidthMm: minimumWidthMm,
                equivalentDiameterMm: equivalentDiameterMm,
                outerCircumferenceMm: outerCircumferenceMm,
                calibrationId: calibrationId,
                algorithmVersion: algorithmVersion,
                calculatedAt: calculatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MeasurementsTable, DbMeasurement>(table),
                  $$MeasurementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sampleId = false, calibrationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sampleId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sampleId,
                        referencedTable: $$MeasurementsTableReferences
                            ._sampleIdTable(db),
                        referencedColumn: $$MeasurementsTableReferences
                            ._sampleIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (calibrationId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.calibrationId,
                        referencedTable: $$MeasurementsTableReferences
                            ._calibrationIdTable(db),
                        referencedColumn: $$MeasurementsTableReferences
                            ._calibrationIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MeasurementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MeasurementsTable,
      DbMeasurement,
      $$MeasurementsTableFilterComposer,
      $$MeasurementsTableOrderingComposer,
      $$MeasurementsTableAnnotationComposer,
      $$MeasurementsTableCreateCompanionBuilder,
      $$MeasurementsTableUpdateCompanionBuilder,
      (DbMeasurement, $$MeasurementsTableReferences),
      DbMeasurement,
      PrefetchHooks Function({bool sampleId, bool calibrationId})
    >;
typedef $$FinishingResultsTableCreateCompanionBuilder =
    FinishingResultsCompanion Function({
      Value<String> id,
      required String sampleId,
      Value<String?> quality,
      Value<double?> confidence,
      required String modelId,
      required DateTime analyzedAt,
      Value<int> rowid,
    });
typedef $$FinishingResultsTableUpdateCompanionBuilder =
    FinishingResultsCompanion Function({
      Value<String> id,
      Value<String> sampleId,
      Value<String?> quality,
      Value<double?> confidence,
      Value<String> modelId,
      Value<DateTime> analyzedAt,
      Value<int> rowid,
    });

final class $$FinishingResultsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $FinishingResultsTable,
          DbFinishingResult
        > {
  $$FinishingResultsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SamplesTable _sampleIdTable(_$AppDatabase db) =>
      db.samples.createAlias('finishing_results__sample_id__samples__id');

  $$SamplesTableProcessedTableManager get sampleId {
    final $_column = $_itemColumn<String>('sample_id')!;

    final manager = $$SamplesTableTableManager(
      $_db,
      $_db.samples,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sampleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ModelMetadataTable _modelIdTable(_$AppDatabase db) => db.modelMetadata
      .createAlias('finishing_results__model_id__model_metadata__id');

  $$ModelMetadataTableProcessedTableManager get modelId {
    final $_column = $_itemColumn<String>('model_id')!;

    final manager = $$ModelMetadataTableTableManager(
      $_db,
      $_db.modelMetadata,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_modelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FinishingResultsTableFilterComposer
    extends Composer<_$AppDatabase, $FinishingResultsTable> {
  $$FinishingResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get analyzedAt => $composableBuilder(
    column: $table.analyzedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SamplesTableFilterComposer get sampleId {
    final $$SamplesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sampleId,
      referencedTable: $db.samples,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SamplesTableFilterComposer(
            $db: $db,
            $table: $db.samples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ModelMetadataTableFilterComposer get modelId {
    final $$ModelMetadataTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modelId,
      referencedTable: $db.modelMetadata,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelMetadataTableFilterComposer(
            $db: $db,
            $table: $db.modelMetadata,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FinishingResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $FinishingResultsTable> {
  $$FinishingResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get analyzedAt => $composableBuilder(
    column: $table.analyzedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SamplesTableOrderingComposer get sampleId {
    final $$SamplesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sampleId,
      referencedTable: $db.samples,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SamplesTableOrderingComposer(
            $db: $db,
            $table: $db.samples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ModelMetadataTableOrderingComposer get modelId {
    final $$ModelMetadataTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modelId,
      referencedTable: $db.modelMetadata,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelMetadataTableOrderingComposer(
            $db: $db,
            $table: $db.modelMetadata,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FinishingResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FinishingResultsTable> {
  $$FinishingResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get quality =>
      $composableBuilder(column: $table.quality, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get analyzedAt => $composableBuilder(
    column: $table.analyzedAt,
    builder: (column) => column,
  );

  $$SamplesTableAnnotationComposer get sampleId {
    final $$SamplesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sampleId,
      referencedTable: $db.samples,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SamplesTableAnnotationComposer(
            $db: $db,
            $table: $db.samples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ModelMetadataTableAnnotationComposer get modelId {
    final $$ModelMetadataTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modelId,
      referencedTable: $db.modelMetadata,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelMetadataTableAnnotationComposer(
            $db: $db,
            $table: $db.modelMetadata,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FinishingResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FinishingResultsTable,
          DbFinishingResult,
          $$FinishingResultsTableFilterComposer,
          $$FinishingResultsTableOrderingComposer,
          $$FinishingResultsTableAnnotationComposer,
          $$FinishingResultsTableCreateCompanionBuilder,
          $$FinishingResultsTableUpdateCompanionBuilder,
          (DbFinishingResult, $$FinishingResultsTableReferences),
          DbFinishingResult,
          PrefetchHooks Function({bool sampleId, bool modelId})
        > {
  $$FinishingResultsTableTableManager(
    _$AppDatabase db,
    $FinishingResultsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinishingResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FinishingResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FinishingResultsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sampleId = const Value.absent(),
                Value<String?> quality = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                Value<String> modelId = const Value.absent(),
                Value<DateTime> analyzedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FinishingResultsCompanion(
                id: id,
                sampleId: sampleId,
                quality: quality,
                confidence: confidence,
                modelId: modelId,
                analyzedAt: analyzedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String sampleId,
                Value<String?> quality = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                required String modelId,
                required DateTime analyzedAt,
                Value<int> rowid = const Value.absent(),
              }) => FinishingResultsCompanion.insert(
                id: id,
                sampleId: sampleId,
                quality: quality,
                confidence: confidence,
                modelId: modelId,
                analyzedAt: analyzedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FinishingResultsTable, DbFinishingResult>(table),
                  $$FinishingResultsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sampleId = false, modelId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sampleId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sampleId,
                        referencedTable: $$FinishingResultsTableReferences
                            ._sampleIdTable(db),
                        referencedColumn: $$FinishingResultsTableReferences
                            ._sampleIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (modelId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.modelId,
                        referencedTable: $$FinishingResultsTableReferences
                            ._modelIdTable(db),
                        referencedColumn: $$FinishingResultsTableReferences
                            ._modelIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FinishingResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FinishingResultsTable,
      DbFinishingResult,
      $$FinishingResultsTableFilterComposer,
      $$FinishingResultsTableOrderingComposer,
      $$FinishingResultsTableAnnotationComposer,
      $$FinishingResultsTableCreateCompanionBuilder,
      $$FinishingResultsTableUpdateCompanionBuilder,
      (DbFinishingResult, $$FinishingResultsTableReferences),
      DbFinishingResult,
      PrefetchHooks Function({bool sampleId, bool modelId})
    >;
typedef $$SyncJobsTableCreateCompanionBuilder = SyncJobsCompanion Function({
  Value<String> id,
  required String sampleId,
  Value<String> status,
  required int revision,
  required String idempotencyKey,
  Value<int> attempts,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<String?> lastError,
  Value<DateTime?> nextAttemptAt,
  Value<int> rowid,
});
typedef $$SyncJobsTableUpdateCompanionBuilder = SyncJobsCompanion Function({
  Value<String> id,
  Value<String> sampleId,
  Value<String> status,
  Value<int> revision,
  Value<String> idempotencyKey,
  Value<int> attempts,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String?> lastError,
  Value<DateTime?> nextAttemptAt,
  Value<int> rowid,
});

final class $$SyncJobsTableReferences
    extends BaseReferences<_$AppDatabase, $SyncJobsTable, DbSyncJob> {
  $$SyncJobsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SamplesTable _sampleIdTable(_$AppDatabase db) =>
      db.samples.createAlias('sync_jobs__sample_id__samples__id');

  $$SamplesTableProcessedTableManager get sampleId {
    final $_column = $_itemColumn<String>('sample_id')!;

    final manager = $$SamplesTableTableManager(
      $_db,
      $_db.samples,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sampleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SyncJobsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncJobsTable> {
  $$SyncJobsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SamplesTableFilterComposer get sampleId {
    final $$SamplesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sampleId,
      referencedTable: $db.samples,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SamplesTableFilterComposer(
            $db: $db,
            $table: $db.samples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SyncJobsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncJobsTable> {
  $$SyncJobsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SamplesTableOrderingComposer get sampleId {
    final $$SamplesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sampleId,
      referencedTable: $db.samples,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SamplesTableOrderingComposer(
            $db: $db,
            $table: $db.samples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SyncJobsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncJobsTable> {
  $$SyncJobsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => column,
  );

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => column,
  );

  $$SamplesTableAnnotationComposer get sampleId {
    final $$SamplesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sampleId,
      referencedTable: $db.samples,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SamplesTableAnnotationComposer(
            $db: $db,
            $table: $db.samples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SyncJobsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncJobsTable,
          DbSyncJob,
          $$SyncJobsTableFilterComposer,
          $$SyncJobsTableOrderingComposer,
          $$SyncJobsTableAnnotationComposer,
          $$SyncJobsTableCreateCompanionBuilder,
          $$SyncJobsTableUpdateCompanionBuilder,
          (DbSyncJob, $$SyncJobsTableReferences),
          DbSyncJob,
          PrefetchHooks Function({bool sampleId})
        > {
  $$SyncJobsTableTableManager(_$AppDatabase db, $SyncJobsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncJobsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncJobsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncJobsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sampleId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<String> idempotencyKey = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime?> nextAttemptAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncJobsCompanion(
                id: id,
                sampleId: sampleId,
                status: status,
                revision: revision,
                idempotencyKey: idempotencyKey,
                attempts: attempts,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastError: lastError,
                nextAttemptAt: nextAttemptAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String sampleId,
                Value<String> status = const Value.absent(),
                required int revision,
                required String idempotencyKey,
                Value<int> attempts = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<String?> lastError = const Value.absent(),
                Value<DateTime?> nextAttemptAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncJobsCompanion.insert(
                id: id,
                sampleId: sampleId,
                status: status,
                revision: revision,
                idempotencyKey: idempotencyKey,
                attempts: attempts,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastError: lastError,
                nextAttemptAt: nextAttemptAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncJobsTable, DbSyncJob>(table),
                  $$SyncJobsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sampleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sampleId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sampleId,
                        referencedTable: $$SyncJobsTableReferences
                            ._sampleIdTable(db),
                        referencedColumn: $$SyncJobsTableReferences
                            ._sampleIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SyncJobsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncJobsTable,
      DbSyncJob,
      $$SyncJobsTableFilterComposer,
      $$SyncJobsTableOrderingComposer,
      $$SyncJobsTableAnnotationComposer,
      $$SyncJobsTableCreateCompanionBuilder,
      $$SyncJobsTableUpdateCompanionBuilder,
      (DbSyncJob, $$SyncJobsTableReferences),
      DbSyncJob,
      PrefetchHooks Function({bool sampleId})
    >;
typedef $$UserPreferencesTableCreateCompanionBuilder =
    UserPreferencesCompanion Function({
      Value<String> id,
      required String key,
      required String value,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$UserPreferencesTableUpdateCompanionBuilder =
    UserPreferencesCompanion Function({
      Value<String> id,
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$UserPreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $UserPreferencesTable> {
  $$UserPreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserPreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserPreferencesTable> {
  $$UserPreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserPreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserPreferencesTable> {
  $$UserPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserPreferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserPreferencesTable,
          DbUserPreference,
          $$UserPreferencesTableFilterComposer,
          $$UserPreferencesTableOrderingComposer,
          $$UserPreferencesTableAnnotationComposer,
          $$UserPreferencesTableCreateCompanionBuilder,
          $$UserPreferencesTableUpdateCompanionBuilder,
          (
            DbUserPreference,
            BaseReferences<
              _$AppDatabase,
              $UserPreferencesTable,
              DbUserPreference
            >,
          ),
          DbUserPreference,
          PrefetchHooks Function()
        > {
  $$UserPreferencesTableTableManager(
    _$AppDatabase db,
    $UserPreferencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserPreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserPreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserPreferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserPreferencesCompanion(
                id: id,
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String key,
                required String value,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => UserPreferencesCompanion.insert(
                id: id,
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UserPreferencesTable, DbUserPreference>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $UserPreferencesTable,
                    DbUserPreference
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserPreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserPreferencesTable,
      DbUserPreference,
      $$UserPreferencesTableFilterComposer,
      $$UserPreferencesTableOrderingComposer,
      $$UserPreferencesTableAnnotationComposer,
      $$UserPreferencesTableCreateCompanionBuilder,
      $$UserPreferencesTableUpdateCompanionBuilder,
      (
        DbUserPreference,
        BaseReferences<_$AppDatabase, $UserPreferencesTable, DbUserPreference>,
      ),
      DbUserPreference,
      PrefetchHooks Function()
    >;
typedef $$StudyNotesTableCreateCompanionBuilder = StudyNotesCompanion Function({
  Value<String> id,
  required String gradeId,
  required String note,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$StudyNotesTableUpdateCompanionBuilder = StudyNotesCompanion Function({
  Value<String> id,
  Value<String> gradeId,
  Value<String> note,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$StudyNotesTableFilterComposer
    extends Composer<_$AppDatabase, $StudyNotesTable> {
  $$StudyNotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gradeId => $composableBuilder(
    column: $table.gradeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StudyNotesTableOrderingComposer
    extends Composer<_$AppDatabase, $StudyNotesTable> {
  $$StudyNotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gradeId => $composableBuilder(
    column: $table.gradeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StudyNotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudyNotesTable> {
  $$StudyNotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get gradeId =>
      $composableBuilder(column: $table.gradeId, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$StudyNotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudyNotesTable,
          DbStudyNote,
          $$StudyNotesTableFilterComposer,
          $$StudyNotesTableOrderingComposer,
          $$StudyNotesTableAnnotationComposer,
          $$StudyNotesTableCreateCompanionBuilder,
          $$StudyNotesTableUpdateCompanionBuilder,
          (
            DbStudyNote,
            BaseReferences<_$AppDatabase, $StudyNotesTable, DbStudyNote>,
          ),
          DbStudyNote,
          PrefetchHooks Function()
        > {
  $$StudyNotesTableTableManager(_$AppDatabase db, $StudyNotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudyNotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudyNotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudyNotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> gradeId = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyNotesCompanion(
                id: id,
                gradeId: gradeId,
                note: note,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String gradeId,
                required String note,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => StudyNotesCompanion.insert(
                id: id,
                gradeId: gradeId,
                note: note,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StudyNotesTable, DbStudyNote>(table),
                  BaseReferences<_$AppDatabase, $StudyNotesTable, DbStudyNote>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StudyNotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudyNotesTable,
      DbStudyNote,
      $$StudyNotesTableFilterComposer,
      $$StudyNotesTableOrderingComposer,
      $$StudyNotesTableAnnotationComposer,
      $$StudyNotesTableCreateCompanionBuilder,
      $$StudyNotesTableUpdateCompanionBuilder,
      (
        DbStudyNote,
        BaseReferences<_$AppDatabase, $StudyNotesTable, DbStudyNote>,
      ),
      DbStudyNote,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SamplesTableTableManager get samples =>
      $$SamplesTableTableManager(_db, _db.samples);
  $$ModelMetadataTableTableManager get modelMetadata =>
      $$ModelMetadataTableTableManager(_db, _db.modelMetadata);
  $$SampleImagesTableTableManager get sampleImages =>
      $$SampleImagesTableTableManager(_db, _db.sampleImages);
  $$CalibrationsTableTableManager get calibrations =>
      $$CalibrationsTableTableManager(_db, _db.calibrations);
  $$MeasurementsTableTableManager get measurements =>
      $$MeasurementsTableTableManager(_db, _db.measurements);
  $$FinishingResultsTableTableManager get finishingResults =>
      $$FinishingResultsTableTableManager(_db, _db.finishingResults);
  $$SyncJobsTableTableManager get syncJobs =>
      $$SyncJobsTableTableManager(_db, _db.syncJobs);
  $$UserPreferencesTableTableManager get userPreferences =>
      $$UserPreferencesTableTableManager(_db, _db.userPreferences);
  $$StudyNotesTableTableManager get studyNotes =>
      $$StudyNotesTableTableManager(_db, _db.studyNotes);
}

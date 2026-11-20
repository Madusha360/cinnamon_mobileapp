// Drift's table DSL references column getters to generate SQL CHECK constraints.
// These declarations are compiled by drift_dev, not evaluated recursively.
// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

String newId() => const Uuid().v4();

abstract class UuidTable extends Table {
  TextColumn get id =>
      text().withLength(min: 36, max: 36).clientDefault(newId)();
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DbSample')
@TableIndex(name: 'samples_history', columns: {#deletedAt, #capturedAt})
@TableIndex(name: 'samples_sync', columns: {#deletedAt, #syncStatus})
class Samples extends UuidTable {
  TextColumn get code => text().customConstraint(
    'NOT NULL COLLATE NOCASE UNIQUE CHECK(length(trim(code)) > 0)',
  )();
  TextColumn get batchId => text().nullable()();
  DateTimeColumn get capturedAt => dateTime()();
  TextColumn get notes => text().nullable()();
  TextColumn get detectionStatus => text()
      .withDefault(const Constant('not_validated'))
      .check(
        detectionStatus.isIn(['not_validated', 'validated', 'rejected']),
      )();
  TextColumn get calibrationStatus => text()
      .withDefault(const Constant('not_calibrated'))
      .check(
        calibrationStatus.isIn(['not_calibrated', 'calibrated', 'invalid']),
      )();
  TextColumn get syncStatus => text()
      .withDefault(const Constant('pending'))
      .check(
        syncStatus.isIn([
          'pending',
          'uploading',
          'synced',
          'failed',
          'conflict',
        ]),
      )();
  IntColumn get revision => integer()
      .withDefault(const Constant(1))
      .check(revision.isBiggerThanValue(0))();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

@DataClassName('DbSampleImage')
class SampleImages extends UuidTable {
  TextColumn get sampleId =>
      text().references(Samples, #id, onDelete: KeyAction.cascade)();
  TextColumn get view => text().check(view.isIn(['end', 'side']))();
  TextColumn get localPath => text().unique()();
  IntColumn get byteCount => integer().check(byteCount.isBiggerThanValue(0))();
  TextColumn get detectorModelId =>
      text().nullable().references(ModelMetadata, #id)();
  DateTimeColumn get validatedAt => dateTime()();
  @override
  List<Set<Column>> get uniqueKeys => [
    {sampleId, view},
  ];
}

@DataClassName('DbMeasurement')
class Measurements extends UuidTable {
  TextColumn get sampleId =>
      text().unique().references(Samples, #id, onDelete: KeyAction.cascade)();
  RealColumn get maximumWidthMm =>
      real().nullable().check(maximumWidthMm.isBiggerThanValue(0))();
  RealColumn get minimumWidthMm =>
      real().nullable().check(minimumWidthMm.isBiggerThanValue(0))();
  RealColumn get equivalentDiameterMm =>
      real().nullable().check(equivalentDiameterMm.isBiggerThanValue(0))();
  RealColumn get outerCircumferenceMm =>
      real().nullable().check(outerCircumferenceMm.isBiggerThanValue(0))();
  TextColumn get calibrationId => text().references(Calibrations, #id)();
  TextColumn get algorithmVersion => text().withLength(min: 1, max: 200)();
  DateTimeColumn get calculatedAt => dateTime()();
  @override
  List<String> get customConstraints => [
    'CHECK(maximum_width_mm IS NULL OR minimum_width_mm IS NULL OR maximum_width_mm >= minimum_width_mm)',
  ];
}

@DataClassName('DbFinishingResult')
class FinishingResults extends UuidTable {
  TextColumn get sampleId =>
      text().unique().references(Samples, #id, onDelete: KeyAction.cascade)();
  TextColumn get quality => text().nullable()();
  RealColumn get confidence =>
      real().nullable().check(confidence.isBetweenValues(0, 1))();
  TextColumn get modelId => text().references(ModelMetadata, #id)();
  DateTimeColumn get analyzedAt => dateTime()();
}

@DataClassName('DbCalibration')
class Calibrations extends UuidTable {
  RealColumn get markerSizeMm =>
      real().check(markerSizeMm.isBiggerThanValue(0))();
  RealColumn get pixelsPerMm =>
      real().check(pixelsPerMm.isBiggerThanValue(0))();
  TextColumn get method => text()();
  DateTimeColumn get calibratedAt => dateTime()();
}

@DataClassName('DbSyncJob')
@TableIndex(name: 'sync_ready', columns: {#status, #nextAttemptAt, #createdAt})
class SyncJobs extends UuidTable {
  TextColumn get sampleId =>
      text().unique().references(Samples, #id, onDelete: KeyAction.cascade)();
  TextColumn get status => text()
      .withDefault(const Constant('pending'))
      .check(
        status.isIn(['pending', 'uploading', 'synced', 'failed', 'conflict']),
      )();
  IntColumn get revision => integer().check(revision.isBiggerThanValue(0))();
  TextColumn get idempotencyKey => text().unique()();
  IntColumn get attempts => integer()
      .withDefault(const Constant(0))
      .check(attempts.isBiggerOrEqualValue(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get nextAttemptAt => dateTime().nullable()();
}

@DataClassName('DbUserPreference')
class UserPreferences extends UuidTable {
  TextColumn get key => text().unique()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime()();
}

@DataClassName('DbStudyNote')
class StudyNotes extends UuidTable {
  TextColumn get gradeId => text().unique()();
  TextColumn get note => text()();
  DateTimeColumn get updatedAt => dateTime()();
}

@DataClassName('DbModelMetadata')
class ModelMetadata extends UuidTable {
  TextColumn get kind => text().check(kind.isIn(['detection', 'finishing']))();
  TextColumn get version => text()();
  TextColumn get localPath => text().nullable()();
  TextColumn get sha256 => text().nullable()();
  BoolColumn get installed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  List<Set<Column>> get uniqueKeys => [
    {kind, version},
  ];
}

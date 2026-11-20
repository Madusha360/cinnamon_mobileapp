import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:quillgrade_mobile/core/database/app_database.dart';
import 'package:quillgrade_mobile/core/storage/image_storage_service.dart';
import 'package:quillgrade_mobile/features/samples/data/local_sample_repository.dart';
import 'package:quillgrade_mobile/features/samples/domain/sample.dart';
import 'package:quillgrade_mobile/features/sync/data/local_sync_queue.dart';

/// Test-only detector stand-in. Never imported by lib/ or bundled as app assets.
class FixtureValidationGate implements CaptureValidationGate {
  const FixtureValidationGate();
  @override
  Future<CaptureValidationEvidence> validate(File end, File side) async =>
      CaptureValidationEvidence(
        modelId: StorageFixture.detectorId,
        validatedAt: StorageFixture.time,
      );
}

class StorageFixture {
  StorageFixture._(this.directory, this.db, this.end, this.side) {
    images = ImageStorageService(
      temporaryDirectory: () async => Directory(p.join(directory.path, 'camera_cache')),
      root: () async => Directory(p.join(directory.path, 'originals')),
    );
    clock = time;
    queue = LocalSyncQueue(db, now: () => clock);
    repository = LocalSampleRepository(
      db,
      images,
      queue,
      validation: const FixtureValidationGate(),
      now: () => clock,
    );
  }
  static final time = DateTime.utc(2026, 11, 20, 10);
  static const detectorId = '10000000-0000-4000-8000-000000000001';
  static const finishingId = '10000000-0000-4000-8000-000000000002';
  static const calibrationId = '10000000-0000-4000-8000-000000000003';
  final Directory directory;
  final AppDatabase db;
  final File end;
  final File side;
  late final ImageStorageService images;
  late final LocalSyncQueue queue;
  late final LocalSampleRepository repository;
  late DateTime clock;

  static Future<StorageFixture> create({bool persistent = false}) async {
    final directory = await Directory.systemTemp.createTemp('quillgrade_test_');
    final db = AppDatabase(
      DatabaseConnection(
        persistent
            ? NativeDatabase(File(p.join(directory.path, 'fixture.sqlite')))
            : NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    final bytes = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+jRZkAAAAASUVORK5CYII=',
    );
    final end = await File(p.join(directory.path, 'source_end.png'))
        .writeAsBytes(bytes, flush: true);
    final side = await File(p.join(directory.path, 'source_side.png'))
        .writeAsBytes(bytes, flush: true);
    final fixture = StorageFixture._(directory, db, end, side);
    for (final item in [
      (detectorId, 'detection'),
      (finishingId, 'finishing'),
    ]) {
      await db
          .into(db.modelMetadata)
          .insert(
            ModelMetadataCompanion.insert(
              id: Value(item.$1),
              kind: item.$2,
              version: 'isolated-test-fixture',
              installed: const Value(true),
              updatedAt: time,
            ),
          );
    }
    await db
        .into(db.calibrations)
        .insert(
          CalibrationsCompanion.insert(
            id: const Value(calibrationId),
            markerSizeMm: 20,
            pixelsPerMm: 4,
            method: 'isolated-test-fixture',
            calibratedAt: time,
          ),
        );
    return fixture;
  }

  NewSample input({
    String code = 'FIXTURE-001',
    DateTime? capturedAt,
    String? batchId,
    String? notes,
  }) => NewSample(
    code: code,
    capturedAt: capturedAt ?? time,
    endPhoto: end,
    sidePhoto: side,
    batchId: batchId,
    notes: notes,
  );

  Future<void> dispose({bool databaseClosed = false}) async {
    if (!databaseClosed) await db.close();
    final resolved = await directory.resolveSymbolicLinks();
    final temp = await Directory.systemTemp.resolveSymbolicLinks();
    if (!p.isWithin(temp, resolved) ||
        !p.basename(resolved).startsWith('quillgrade_test_')) {
      throw StateError('Unsafe test cleanup');
    }
    await directory.delete(recursive: true);
  }
}

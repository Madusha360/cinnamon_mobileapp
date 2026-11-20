import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/storage/image_storage_service.dart';
import '../../sync/data/local_sync_queue.dart';
import '../domain/sample.dart';

class LocalSampleRepository {
  LocalSampleRepository(
    this.db,
    this.images,
    this.queue, {
    this.validation = const UnavailableCaptureValidationGate(),
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;
  final AppDatabase db;
  final ImageStorageService images;
  final LocalSyncQueue queue;
  final CaptureValidationGate validation;
  final DateTime Function() _now;

  Future<String> createSample(NewSample input) async {
    final code = _code(input.code);
    // Fail closed before touching files. Only isolated tests inject a fixture gate.
    final evidence = await validation.validate(input.endPhoto, input.sidePhoto);
    final detector = await (db.select(
      db.modelMetadata,
    )..where((t) => t.id.equals(evidence.modelId))).getSingleOrNull();
    if (detector == null ||
        detector.kind != 'detection' ||
        !detector.installed) {
      throw StateError('Validated detector metadata is required');
    }
    final id = const Uuid().v4();
    final pair = await images.saveOriginals(
      id,
      end: input.endPhoto,
      side: input.sidePhoto,
    );
    try {
      await db.transaction(() async {
        await db
            .into(db.samples)
            .insert(
              SamplesCompanion.insert(
                id: Value(id),
                code: code,
                capturedAt: input.capturedAt.toUtc(),
                updatedAt: _now().toUtc(),
                batchId: Value(_optional(input.batchId)),
                notes: Value(_optional(input.notes)),
                detectionStatus: const Value('validated'),
              ),
            );
        for (final item in [('end', pair.end), ('side', pair.side)]) {
          await db
              .into(db.sampleImages)
              .insert(
                SampleImagesCompanion.insert(
                  sampleId: id,
                  view: item.$1,
                  localPath: item.$2.localPath,
                  byteCount: item.$2.byteCount,
                  detectorModelId: Value(evidence.modelId),
                  validatedAt: evidence.validatedAt.toUtc(),
                ),
              );
        }
        await queue.enqueue(id, 1);
      });
    } catch (_) {
      // A cleanup failure leaves only an unreferenced private directory. Never
      // remove source photos or hide the original database error.
      try {
        await images.discardUncommitted(id);
      } catch (_) {
        /* Retain for recovery. */
      }
      rethrow;
    }
    return id;
  }

  Future<void> updateSample(
    String id, {
    required String code,
    String? batchId,
    String? notes,
  }) => db.transaction(() async {
    final sample = await _active(id);
    await (db.update(db.samples)..where((t) => t.id.equals(id))).write(
      SamplesCompanion(
        code: Value(_code(code)),
        batchId: Value(_optional(batchId)),
        notes: Value(_optional(notes)),
      ),
    );
    await _changed(sample);
  });

  /// Tombstone keeps original evidence intact; no cloud deletion is implied.
  Future<void> deleteSample(String id) => db.transaction(() async {
    await _active(id);
    await (db.update(db.samples)..where((t) => t.id.equals(id))).write(
      SamplesCompanion(
        deletedAt: Value(_now().toUtc()),
        updatedAt: Value(_now().toUtc()),
      ),
    );
    await (db.delete(db.syncJobs)..where((t) => t.sampleId.equals(id))).go();
  });

  Future<void> saveMeasurements(
    String id,
    MeasurementInput result,
  ) => db.transaction(() async {
    final sample = await _active(id);
    _validated(sample);
    for (final value in [
      result.maximumWidthMm,
      result.minimumWidthMm,
      result.equivalentDiameterMm,
      result.outerCircumferenceMm,
    ]) {
      if (value != null && (!value.isFinite || value <= 0)) {
        throw ArgumentError('Measurements must be finite positive millimeters');
      }
    }
    if (result.maximumWidthMm != null &&
        result.minimumWidthMm != null &&
        result.maximumWidthMm! < result.minimumWidthMm!) {
      throw ArgumentError('Maximum width is below minimum width');
    }
    final calibration = await (db.select(
      db.calibrations,
    )..where((t) => t.id.equals(result.calibrationId))).getSingle();
    if (!calibration.markerSizeMm.isFinite ||
        !calibration.pixelsPerMm.isFinite) {
      throw StateError('Invalid calibration');
    }
    final existing = await (db.select(
      db.measurements,
    )..where((t) => t.sampleId.equals(id))).getSingleOrNull();
    await db
        .into(db.measurements)
        .insertOnConflictUpdate(
          MeasurementsCompanion.insert(
            id: existing == null ? const Value.absent() : Value(existing.id),
            sampleId: id,
            maximumWidthMm: Value(result.maximumWidthMm),
            minimumWidthMm: Value(result.minimumWidthMm),
            equivalentDiameterMm: Value(result.equivalentDiameterMm),
            outerCircumferenceMm: Value(result.outerCircumferenceMm),
            calibrationId: result.calibrationId,
            algorithmVersion: result.algorithmVersion,
            calculatedAt: result.calculatedAt.toUtc(),
          ),
        );
    await (db.update(db.samples)..where((t) => t.id.equals(id))).write(
      const SamplesCompanion(calibrationStatus: Value('calibrated')),
    );
    await _changed(sample);
  });

  Future<void> saveFinishingResult(String id, FinishingInput result) =>
      db.transaction(() async {
        final sample = await _active(id);
        _validated(sample);
        if (result.confidence != null &&
            (!result.confidence!.isFinite ||
                result.confidence! < 0 ||
                result.confidence! > 1)) {
          throw ArgumentError('Confidence must be between zero and one');
        }
        final model = await (db.select(
          db.modelMetadata,
        )..where((t) => t.id.equals(result.modelId))).getSingle();
        if (model.kind != 'finishing' || !model.installed) {
          throw StateError('Installed finishing model metadata is required');
        }
        final existing = await (db.select(
          db.finishingResults,
        )..where((t) => t.sampleId.equals(id))).getSingleOrNull();
        await db
            .into(db.finishingResults)
            .insertOnConflictUpdate(
              FinishingResultsCompanion.insert(
                id: existing == null
                    ? const Value.absent()
                    : Value(existing.id),
                sampleId: id,
                quality: Value(_optional(result.quality)),
                confidence: Value(result.confidence),
                modelId: result.modelId,
                analyzedAt: result.analyzedAt.toUtc(),
              ),
            );
        await _changed(sample);
      });

  Future<DbSample> _active(String id) async {
    final sample = await (db.select(
      db.samples,
    )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingleOrNull();
    if (sample == null) throw StateError('Sample not found');
    return sample;
  }

  void _validated(DbSample sample) {
    if (sample.detectionStatus != 'validated') {
      throw StateError('Unvalidated sample cannot be graded');
    }
  }

  Future<void> _changed(DbSample sample) async {
    final revision = sample.revision + 1;
    await (db.update(db.samples)..where((t) => t.id.equals(sample.id))).write(
      SamplesCompanion(
        revision: Value(revision),
        syncStatus: const Value('pending'),
        updatedAt: Value(_now().toUtc()),
      ),
    );
    await queue.enqueue(sample.id, revision);
  }

  String _code(String code) {
    if (code.trim().isEmpty) throw ArgumentError('Sample code is required');
    return code.trim();
  }

  String? _optional(String? text) =>
      text == null || text.trim().isEmpty ? null : text.trim();

  Future<SampleRecord?> readSample(String id) async =>
      (await _select(const SampleQuery(), id: id).getSingleOrNull());
  Stream<SampleRecord?> watchSample(String id) =>
      _select(const SampleQuery(), id: id).watchSingleOrNull();
  Future<List<SampleRecord>> getAllSamples([
    SampleQuery query = const SampleQuery(),
  ]) => _select(query).get();
  Future<List<SampleRecord>> getRecentSamples({int limit = 5}) =>
      getAllSamples(SampleQuery(limit: limit));
  Stream<List<SampleRecord>> watchSamples([
    SampleQuery query = const SampleQuery(),
  ]) => _select(query).watch();

  Selectable<SampleRecord> _select(SampleQuery query, {String? id}) {
    final conditions = ['s.deleted_at IS NULL'];
    final variables = <Variable>[];
    if (id != null) {
      conditions.add('s.id = ?');
      variables.add(Variable(id));
    }
    if (query.status != null) {
      conditions.add('s.sync_status = ?');
      variables.add(Variable(query.status!.name));
    }
    if (query.search.trim().isNotEmpty) {
      final escaped = query.search
          .trim()
          .replaceAll('\\', '\\\\')
          .replaceAll('%', '\\%')
          .replaceAll('_', '\\_');
      conditions.add(
        "(s.code LIKE ? ESCAPE '\\' OR s.batch_id LIKE ? ESCAPE '\\' OR s.notes LIKE ? ESCAPE '\\')",
      );
      variables.addAll(List.generate(3, (_) => Variable('%$escaped%')));
    }
    final order = switch (query.sort) {
      SampleSort.newest => 's.captured_at DESC, s.id',
      SampleSort.oldest => 's.captured_at ASC, s.id',
      SampleSort.code => 's.code COLLATE NOCASE, s.id',
    };
    if (query.limit != null && query.limit! < 1) {
      throw ArgumentError('Limit must be positive');
    }
    return db
        .customSelect(
          '''
      SELECT s.*, e.local_path AS end_path, i.local_path AS side_path,
      m.maximum_width_mm, m.minimum_width_mm, m.equivalent_diameter_mm, m.outer_circumference_mm,
      f.quality, f.confidence
      FROM samples s
      LEFT JOIN sample_images e ON e.sample_id = s.id AND e.view = 'end'
      LEFT JOIN sample_images i ON i.sample_id = s.id AND i.view = 'side'
      LEFT JOIN measurements m ON m.sample_id = s.id
      LEFT JOIN finishing_results f ON f.sample_id = s.id
      WHERE ${conditions.join(' AND ')} ORDER BY $order ${query.limit == null ? '' : 'LIMIT ${query.limit}'}
    ''',
          variables: variables,
          readsFrom: {
            db.samples,
            db.sampleImages,
            db.measurements,
            db.finishingResults,
          },
        )
        .map(
          (row) => SampleRecord(
            id: row.read<String>('id'),
            code: row.read<String>('code'),
            capturedAt: row.read<DateTime>('captured_at'),
            batchId: row.readNullable<String>('batch_id'),
            notes: row.readNullable<String>('notes'),
            detectionStatus: row.read<String>('detection_status'),
            calibrationStatus: row.read<String>('calibration_status'),
            syncStatus: SyncStatus.values.byName(
              row.read<String>('sync_status'),
            ),
            revision: row.read<int>('revision'),
            endImagePath: row.readNullable<String>('end_path'),
            sideImagePath: row.readNullable<String>('side_path'),
            maximumWidthMm: row.readNullable<double>('maximum_width_mm'),
            minimumWidthMm: row.readNullable<double>('minimum_width_mm'),
            equivalentDiameterMm: row.readNullable<double>(
              'equivalent_diameter_mm',
            ),
            outerCircumferenceMm: row.readNullable<double>(
              'outer_circumference_mm',
            ),
            finishingQuality: row.readNullable<String>('quality'),
            finishingConfidence: row.readNullable<double>('confidence'),
          ),
        );
  }

  Selectable<LocalStatistics> _statistics() => db
      .customSelect(
        '''
    SELECT COUNT(*) AS total,
    COALESCE(SUM(sync_status != 'synced'), 0) AS pending,
    COALESCE(SUM(sync_status = 'synced'), 0) AS synced,
    COALESCE(SUM(captured_at >= ? AND captured_at <= ?), 0) AS recent,
    COALESCE(SUM(sync_status = 'uploading'), 0) AS uploading,
    COALESCE(SUM(sync_status = 'failed'), 0) AS failed,
    COALESCE(SUM(sync_status = 'conflict'), 0) AS conflict
    FROM samples WHERE deleted_at IS NULL
  ''',
        variables: [
          Variable(_now().toUtc().subtract(const Duration(days: 7))),
          Variable(_now().toUtc()),
        ],
        readsFrom: {db.samples},
      )
      .map(
        (r) => LocalStatistics(
          total: r.read<int>('total'),
          pending: r.read<int>('pending'),
          synced: r.read<int>('synced'),
          recent: r.read<int>('recent'),
          uploading: r.read<int>('uploading'),
          failed: r.read<int>('failed'),
          conflict: r.read<int>('conflict'),
        ),
      );
  Future<LocalStatistics> getStatistics() => _statistics().getSingle();
  // Re-evaluate the time window after each committed sample change, rather
  // than capturing a seven-day cutoff for the lifetime of the subscription.
  Stream<LocalStatistics> watchStatistics() => db
      .customSelect('SELECT 1', readsFrom: {db.samples})
      .watch()
      .asyncMap((_) => getStatistics());
}

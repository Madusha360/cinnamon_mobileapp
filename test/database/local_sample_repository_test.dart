import 'dart:async';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:quillgrade_mobile/core/database/app_database.dart';
import 'package:quillgrade_mobile/features/samples/data/local_sample_repository.dart';
import 'package:quillgrade_mobile/features/samples/domain/sample.dart';
import 'package:quillgrade_mobile/features/sync/data/local_sync_queue.dart';

import '../support/storage_fixture.dart';

void main() {
  late StorageFixture f;
  setUp(() async => f = await StorageFixture.create());
  tearDown(() => f.dispose());

  test(
    'initialization creates all nine tables, foreign keys and real zero counts',
    () async {
      expect(f.db.allTables.length, 9);
      expect(
        (await f.db.customSelect('PRAGMA foreign_keys').getSingle()).read<int>(
          'foreign_keys',
        ),
        1,
      );
      expect(
        (await f.db.customSelect('PRAGMA user_version').getSingle()).read<int>(
          'user_version',
        ),
        2,
      );
      expect((await f.repository.getStatistics()).total, 0);
      expect(await f.repository.getAllSamples(), isEmpty);
      expect(await f.db.select(f.db.studyNotes).get(), isEmpty);
    },
  );

  test('CRUD keeps UUID identity, two originals, nullable outputs and one queue job', () async {
    final id = await f.repository.createSample(
      f.input(batchId: 'B-7', notes: 'Original note'),
    );
    expect(RegExp(r'^[0-9a-f-]{36}$').hasMatch(id), isTrue);
    var sample = (await f.repository.readSample(id))!;
    expect(sample.code, 'FIXTURE-001');
    expect(sample.batchId, 'B-7');
    expect(sample.capturedAt.toUtc(), StorageFixture.time);
    expect(sample.maximumWidthMm, isNull);
    expect(sample.minimumWidthMm, isNull);
    expect(sample.equivalentDiameterMm, isNull);
    expect(sample.outerCircumferenceMm, isNull);
    expect(sample.finishingQuality, isNull);
    expect(sample.calibrationStatus, 'not_calibrated');
    expect(sample.detectionStatus, 'validated');
    expect(sample.syncStatus, SyncStatus.pending);
    expect((await f.db.select(f.db.sampleImages).get()).length, 2);
    expect((await f.db.select(f.db.syncJobs).get()).length, 1);
    await f.repository.updateSample(id, code: 'CHANGED', notes: 'New note');
    sample = (await f.repository.readSample(id))!;
    expect(sample.revision, 2);
    expect(sample.batchId, isNull);
    expect(sample.notes, 'New note');
    expect((await f.db.select(f.db.syncJobs).getSingle()).revision, 2);
    await f.repository.deleteSample(id);
    expect(await f.repository.readSample(id), isNull);
    expect(await f.repository.getAllSamples(), isEmpty);
    expect((await f.repository.getStatistics()).total, 0);
    expect(await f.db.select(f.db.syncJobs).get(), isEmpty);
    expect((await f.db.select(f.db.samples).getSingle()).deletedAt, isNotNull);
    expect(await f.images.resolve(sample.endImagePath!), isNotNull);
    expect(await f.images.resolve(sample.sideImagePath!), isNotNull);
    await expectLater(
      f.repository.updateSample(id, code: 'RESTORE'),
      throwsStateError,
    );
  });

  test('production validation gate blocks even when fixture metadata says installed', () async {
    final production = LocalSampleRepository(f.db, f.images, f.queue);
    await expectLater(production.createSample(f.input()), throwsStateError);
    expect(await production.getAllSamples(), isEmpty);
    expect(await f.db.select(f.db.sampleImages).get(), isEmpty);
    expect(await f.db.select(f.db.syncJobs).get(), isEmpty);
  });

  test(
    'duplicate codes roll back rows and clean only the newly copied images',
    () async {
      final id = await f.repository.createSample(f.input());
      final original = (await f.repository.readSample(id))!;
      await expectLater(
        f.repository.createSample(f.input(code: 'fixture-001')),
        throwsA(isA<SqliteException>()),
      );
      expect((await f.repository.getAllSamples()).length, 1);
      expect((await f.db.select(f.db.sampleImages).get()).length, 2);
      expect((await f.db.select(f.db.syncJobs).get()).length, 1);
      expect(
        (await Directory(
          p.join(f.directory.path, 'originals'),
        ).list().toList()).length,
        1,
      );
      expect(await f.images.resolve(original.endImagePath!), isNotNull);
    },
  );

  test(
    'missing second image leaves no sample, queue job or half-saved pair',
    () async {
      await f.side.delete();
      await expectLater(f.repository.createSample(f.input()), throwsException);
      expect(await f.repository.getAllSamples(), isEmpty);
      expect(await f.db.select(f.db.syncJobs).get(), isEmpty);
      expect(
        await Directory(p.join(f.directory.path, 'originals')).list().toList(),
        isEmpty,
      );
      expect(await f.end.exists(), isTrue);
    },
  );

  test(
    'foreign keys, per-view uniqueness and transaction rollback are enforced',
    () async {
      final id = await f.repository.createSample(f.input());
      await expectLater(
        f.db
            .into(f.db.sampleImages)
            .insert(
              SampleImagesCompanion.insert(
                sampleId: 'missing',
                view: 'end',
                localPath: 'bad',
                byteCount: 1,
                validatedAt: StorageFixture.time,
              ),
            ),
        throwsA(isA<SqliteException>()),
      );
      await expectLater(
        f.db
            .into(f.db.sampleImages)
            .insert(
              SampleImagesCompanion.insert(
                sampleId: id,
                view: 'end',
                localPath: 'duplicate-view',
                byteCount: 1,
                validatedAt: StorageFixture.time,
              ),
            ),
        throwsA(isA<SqliteException>()),
      );
      await expectLater(
        f.db.transaction(() async {
          await f.db
              .into(f.db.studyNotes)
              .insert(
                StudyNotesCompanion.insert(
                  gradeId: 'alba',
                  note: 'Must roll back',
                  updatedAt: StorageFixture.time,
                ),
              );
          await (f.db.delete(
            f.db.modelMetadata,
          )..where((t) => t.id.equals(StorageFixture.detectorId))).go();
        }),
        throwsA(isA<SqliteException>()),
      );
      expect(await f.db.select(f.db.studyNotes).get(), isEmpty);
      expect(
        await f.db.customSelect('PRAGMA foreign_key_check').get(),
        isEmpty,
      );
    },
  );

  test('measurement and finishing saves preserve provenance and invalidate sync atomically', () async {
    final id = await f.repository.createSample(f.input());
    await f.repository.saveMeasurements(
      id,
      MeasurementInput(
        calibrationId: StorageFixture.calibrationId,
        algorithmVersion: 'test-only-v1',
        calculatedAt: StorageFixture.time,
        maximumWidthMm: 12,
        minimumWidthMm: 10,
      ),
    );
    await f.repository.saveFinishingResult(
      id,
      FinishingInput(
        modelId: StorageFixture.finishingId,
        analyzedAt: StorageFixture.time,
        quality: 'test-only-label',
        confidence: 0.8,
      ),
    );
    final sample = (await f.repository.readSample(id))!;
    expect(sample.maximumWidthMm, 12);
    expect(sample.minimumWidthMm, 10);
    expect(sample.equivalentDiameterMm, isNull);
    expect(sample.outerCircumferenceMm, isNull);
    expect(sample.finishingQuality, 'test-only-label');
    expect(sample.finishingConfidence, 0.8);
    expect(sample.calibrationStatus, 'calibrated');
    expect(sample.revision, 3);
    expect((await f.db.select(f.db.syncJobs).getSingle()).revision, 3);
    await f.repository.saveMeasurements(
      id,
      MeasurementInput(
        calibrationId: StorageFixture.calibrationId,
        algorithmVersion: 'test-only-v2',
        calculatedAt: StorageFixture.time,
        equivalentDiameterMm: 11,
        outerCircumferenceMm: 35,
      ),
    );
    expect((await f.db.select(f.db.measurements).get()).length, 1);
    expect((await f.repository.readSample(id))!.maximumWidthMm, isNull);
  });

  test('invalid measurements, missing calibration and wrong model cannot change records', () async {
    final id = await f.repository.createSample(f.input());
    for (final value in [-1.0, 0.0, double.nan, double.infinity]) {
      await expectLater(
        f.repository.saveMeasurements(
          id,
          MeasurementInput(
            calibrationId: StorageFixture.calibrationId,
            algorithmVersion: 'test',
            calculatedAt: StorageFixture.time,
            maximumWidthMm: value,
          ),
        ),
        throwsArgumentError,
      );
    }
    await expectLater(
      f.repository.saveMeasurements(
        id,
        MeasurementInput(
          calibrationId: 'missing',
          algorithmVersion: 'test',
          calculatedAt: StorageFixture.time,
          maximumWidthMm: 10,
        ),
      ),
      throwsStateError,
    );
    await expectLater(
      f.repository.saveFinishingResult(
        id,
        FinishingInput(
          modelId: StorageFixture.detectorId,
          analyzedAt: StorageFixture.time,
          quality: 'incorrect',
        ),
      ),
      throwsStateError,
    );
    expect((await f.repository.readSample(id))!.revision, 1);
    expect(await f.db.select(f.db.measurements).get(), isEmpty);
    expect(await f.db.select(f.db.finishingResults).get(), isEmpty);
  });

  test(
    'search is literal, intersects filters, sorts and limits real records',
    () async {
      final older = await f.repository.createSample(
        f.input(
          code: 'Z-OLD',
          capturedAt: StorageFixture.time.subtract(const Duration(days: 10)),
          batchId: 'LOT-1',
        ),
      );
      await f.repository.createSample(
        f.input(code: 'A-NEW', notes: "100%_done O'Brien"),
      );
      expect((await f.repository.getAllSamples()).first.code, 'A-NEW');
      expect(
        (await f.repository.getAllSamples(
          const SampleQuery(sort: SampleSort.oldest),
        )).first.id,
        older,
      );
      expect(
        (await f.repository.getAllSamples(
          const SampleQuery(sort: SampleSort.code),
        )).first.code,
        'A-NEW',
      );
      expect(
        (await f.repository.getRecentSamples(limit: 1)).single.code,
        'A-NEW',
      );
      expect(
        (await f.repository.getAllSamples(const SampleQuery(search: 'lot-1')))
            .single
            .id,
        older,
      );
      expect(
        (await f.repository.getAllSamples(const SampleQuery(search: '%_')))
            .single
            .code,
        'A-NEW',
      );
      expect(
        (await f.repository.getAllSamples(const SampleQuery(search: "O'Brien")))
            .single
            .code,
        'A-NEW',
      );
      expect(
        await f.repository.getAllSamples(
          const SampleQuery(search: 'A-NEW', status: SyncStatus.synced),
        ),
        isEmpty,
      );
      final stats = await f.repository.getStatistics();
      expect(stats.total, 2);
      expect(stats.pending, 2);
      expect(stats.synced, 0);
      expect(stats.recent, 1);
    },
  );

  test(
    'reactive lists and statistics emit committed changes and deletion',
    () async {
      final lists = StreamIterator(f.repository.watchSamples());
      final counts = StreamIterator(f.repository.watchStatistics());
      await lists.moveNext();
      await counts.moveNext();
      expect(lists.current, isEmpty);
      expect(counts.current.total, 0);
      final id = await f.repository.createSample(f.input());
      await lists.moveNext();
      await counts.moveNext();
      expect(lists.current.single.id, id);
      expect(counts.current.total, 1);
      await f.repository.deleteSample(id);
      await lists.moveNext();
      await counts.moveNext();
      expect(lists.current, isEmpty);
      expect(counts.current.total, 0);
      await lists.cancel();
      await counts.cancel();
    },
  );

  test(
    'file database survives close/reopen and recovers an interrupted upload',
    () async {
      final disk = await StorageFixture.create(persistent: true);
      final id = await disk.repository.createSample(
        disk.input(notes: 'Survives reopen'),
      );
      await disk.db
          .into(disk.db.studyNotes)
          .insert(
            StudyNotesCompanion.insert(
              gradeId: 'alba',
              note: 'Offline note',
              updatedAt: StorageFixture.time,
            ),
          );
      await disk.queue.claimNext();
      await disk.db.close();
      final reopened = AppDatabase(
        NativeDatabase(File(p.join(disk.directory.path, 'fixture.sqlite'))),
      );
      try {
        final queue = LocalSyncQueue(reopened);
        final repository = LocalSampleRepository(reopened, disk.images, queue);
        final sample = (await repository.readSample(id))!;
        expect(sample.notes, 'Survives reopen');
        expect(sample.syncStatus, SyncStatus.pending);
        final job = await reopened.select(reopened.syncJobs).getSingle();
        expect(job.status, 'pending');
        expect(job.attempts, 1);
        expect(
          (await reopened.select(reopened.studyNotes).getSingle()).note,
          'Offline note',
        );
        expect(await disk.images.resolve(sample.endImagePath!), isNotNull);
        expect(
          await reopened.customSelect('PRAGMA foreign_key_check').get(),
          isEmpty,
        );
      } finally {
        await reopened.close();
        await disk.dispose(databaseClosed: true);
      }
    },
  );
}

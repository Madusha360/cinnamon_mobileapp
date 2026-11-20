import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Samples,
    SampleImages,
    Measurements,
    FinishingResults,
    Calibrations,
    SyncJobs,
    UserPreferences,
    StudyNotes,
    ModelMetadata,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _open());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from != 1 || to != 2) {
        throw StateError('Unsupported database migration: $from to $to');
      }
      await transaction(() async {
        await m.addColumn(syncJobs, syncJobs.lastError);
        await m.addColumn(syncJobs, syncJobs.nextAttemptAt);
        await _indexes();
      });
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      final violations = await customSelect('PRAGMA foreign_key_check').get();
      if (violations.isNotEmpty) {
        throw StateError('Database integrity check failed');
      }
      // There is no worker in Phase 2. Interrupted future uploads are eligible
      // for an explicit retry, never marked synced on startup.
      await transaction(() async {
        await customStatement(
          "UPDATE sync_jobs SET status = 'pending' WHERE status = 'uploading'",
        );
        await customStatement(
          "UPDATE samples SET sync_status = 'pending' WHERE sync_status = 'uploading'",
        );
      });
    },
  );

  Future<void> _indexes() async {
    await customStatement(
      'CREATE INDEX samples_history ON samples(deleted_at, captured_at)',
    );
    await customStatement(
      'CREATE INDEX samples_sync ON samples(deleted_at, sync_status)',
    );
    await customStatement(
      'CREATE INDEX sync_ready ON sync_jobs(status, next_attempt_at, created_at)',
    );
  }

  static QueryExecutor _open() => LazyDatabase(() async {
    final support = await getApplicationSupportDirectory();
    final directory = Directory(p.join(support.path, 'quillgrade'));
    await directory.create(recursive: true);
    return NativeDatabase.createInBackground(
      File(p.join(directory.path, 'quillgrade.sqlite')),
    );
  });
}

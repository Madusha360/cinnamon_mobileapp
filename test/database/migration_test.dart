import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quillgrade_mobile/core/database/app_database.dart';

import 'generated/schema.dart';

void main() {
  test(
    'v1 to v2 preserves records and adds nullable retry fields and indexes',
    () async {
      final verifier = SchemaVerifier(GeneratedHelper());
      final schema = await verifier.schemaAt(1);
      const sampleId = '10000000-0000-4000-8000-000000000010';
      const jobId = '10000000-0000-4000-8000-000000000011';
      schema.rawDatabase.execute(
        "INSERT INTO samples (id, code, captured_at, updated_at, notes) VALUES (?, 'LEGACY-FIXTURE', 100, 100, 'keep this')",
        [sampleId],
      );
      schema.rawDatabase.execute(
        "INSERT INTO sync_jobs (id, sample_id, revision, idempotency_key, created_at, updated_at) VALUES (?, ?, 1, 'legacy-key', 100, 100)",
        [jobId, sampleId],
      );
      final db = AppDatabase(schema.newConnection());
      try {
        await verifier.migrateAndValidate(db, 2);
        final sample = await db.select(db.samples).getSingle();
        expect(sample.id, sampleId);
        expect(sample.notes, 'keep this');
        final job = await db.select(db.syncJobs).getSingle();
        expect(job.idempotencyKey, 'legacy-key');
        expect(job.lastError, isNull);
        expect(job.nextAttemptAt, isNull);
        expect(
          await db.customSelect('PRAGMA foreign_key_check').get(),
          isEmpty,
        );
        expect(
          (await db
                  .customSelect(
                    "SELECT name FROM sqlite_master WHERE type = 'index' AND name = 'sync_ready'",
                  )
                  .get())
              .length,
          1,
        );
      } finally {
        await db.close();
      }
    },
  );
}

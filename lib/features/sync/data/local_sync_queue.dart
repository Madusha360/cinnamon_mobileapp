import 'dart:math' as math;

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../samples/domain/sample.dart';

class SyncLease {
  const SyncLease({
    required this.jobId,
    required this.sampleId,
    required this.revision,
    required this.attempt,
    required this.idempotencyKey,
  });
  final String jobId;
  final String sampleId;
  final int revision;
  final int attempt;
  final String idempotencyKey;
}

/// An acknowledgement from a future transport, never synthesized by the UI.
class SyncReceipt {
  const SyncReceipt({
    required this.sampleId,
    required this.revision,
    required this.idempotencyKey,
    required this.recordConfirmed,
    required this.endImageConfirmed,
    required this.sideImageConfirmed,
  });
  final String sampleId;
  final int revision;
  final String idempotencyKey;
  final bool recordConfirmed;
  final bool endImageConfirmed;
  final bool sideImageConfirmed;
}

/// Local state machine only. No HTTP client, scheduler or upload worker exists.
class LocalSyncQueue {
  LocalSyncQueue(this.db, {DateTime Function()? now})
    : _now = now ?? DateTime.now;
  final AppDatabase db;
  final DateTime Function() _now;

  Stream<List<DbSyncJob>> watchJobs() => (db.select(
    db.syncJobs,
  )..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])).watch();
  Stream<DateTime?> watchLastSyncedAt() => db
      .customSelect(
        "SELECT MAX(updated_at) AS last_sync FROM sync_jobs WHERE status = 'synced'",
        readsFrom: {db.syncJobs},
      )
      .map((r) => r.readNullable<DateTime>('last_sync'))
      .watchSingle();

  /// Called inside the same transaction as each sample mutation.
  Future<void> enqueue(String sampleId, int revision) async {
    final existing = await (db.select(
      db.syncJobs,
    )..where((t) => t.sampleId.equals(sampleId))).getSingleOrNull();
    final time = _now().toUtc();
    final row = SyncJobsCompanion.insert(
      sampleId: sampleId,
      revision: revision,
      idempotencyKey: '$sampleId:$revision',
      createdAt: time,
      updatedAt: time,
    );
    if (existing == null) {
      await db.into(db.syncJobs).insert(row);
    } else {
      await (db.update(
        db.syncJobs,
      )..where((t) => t.id.equals(existing.id))).write(
        SyncJobsCompanion(
          status: const Value('pending'),
          revision: Value(revision),
          idempotencyKey: Value('$sampleId:$revision'),
          attempts: const Value(0),
          lastError: const Value(null),
          nextAttemptAt: const Value(null),
          updatedAt: Value(time),
        ),
      );
    }
  }

  Future<SyncLease?> claimNext() => db.transaction(() async {
    final time = _now().toUtc();
    final query = db.select(db.syncJobs)
      ..where(
        (t) =>
            t.status.equals('pending') &
            (t.nextAttemptAt.isNull() |
                t.nextAttemptAt.isSmallerOrEqualValue(time)),
      )
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
      ..limit(1);
    final job = await query.getSingleOrNull();
    if (job == null) return null;
    await (db.update(db.syncJobs)..where((t) => t.id.equals(job.id))).write(
      SyncJobsCompanion(
        status: const Value('uploading'),
        attempts: Value(job.attempts + 1),
        updatedAt: Value(time),
        lastError: const Value(null),
      ),
    );
    await _sampleStatus(job.sampleId, SyncStatus.uploading);
    return SyncLease(
      jobId: job.id,
      sampleId: job.sampleId,
      revision: job.revision,
      attempt: job.attempts + 1,
      idempotencyKey: job.idempotencyKey,
    );
  });

  Future<void> acknowledge(SyncLease lease, SyncReceipt receipt) =>
      db.transaction(() async {
        await _checkLease(lease);
        if (receipt.sampleId != lease.sampleId ||
            receipt.revision != lease.revision ||
            receipt.idempotencyKey != lease.idempotencyKey ||
            !receipt.recordConfirmed ||
            !receipt.endImageConfirmed ||
            !receipt.sideImageConfirmed) {
          throw StateError(
            'The complete sample and both images must be confirmed for this revision',
          );
        }
        await _transition(lease, SyncStatus.synced);
      });

  Future<void> fail(
    SyncLease lease, {
    required String reason,
    bool conflict = false,
  }) => db.transaction(() async {
    await _checkLease(lease);
    final seconds = math
        .min(21600, 30 * math.pow(2, math.min(lease.attempt - 1, 10)))
        .toInt();
    await _transition(
      lease,
      conflict ? SyncStatus.conflict : SyncStatus.failed,
      reason: reason,
      nextAttempt: conflict
          ? null
          : _now().toUtc().add(Duration(seconds: seconds)),
    );
  });

  /// Explicit retry only; conflict resolution belongs to the future sync UI.
  Future<void> retry(String jobId) => db.transaction(() async {
    final job = await (db.select(
      db.syncJobs,
    )..where((t) => t.id.equals(jobId))).getSingle();
    if (job.status != 'failed' && job.status != 'conflict') {
      throw StateError('Only failed or conflicting jobs can be retried');
    }
    await (db.update(db.syncJobs)..where((t) => t.id.equals(jobId))).write(
      SyncJobsCompanion(
        status: const Value('pending'),
        updatedAt: Value(_now().toUtc()),
      ),
    );
    await _sampleStatus(job.sampleId, SyncStatus.pending);
  });

  Future<void> _checkLease(SyncLease lease) async {
    final job = await (db.select(
      db.syncJobs,
    )..where((t) => t.id.equals(lease.jobId))).getSingleOrNull();
    final sample = await (db.select(
      db.samples,
    )..where((t) => t.id.equals(lease.sampleId))).getSingleOrNull();
    if (job == null ||
        sample == null ||
        sample.deletedAt != null ||
        job.status != 'uploading' ||
        job.sampleId != lease.sampleId ||
        job.revision != lease.revision ||
        sample.revision != lease.revision ||
        job.attempts != lease.attempt ||
        job.idempotencyKey != lease.idempotencyKey) {
      throw StateError('Stale or inactive upload attempt');
    }
  }

  Future<void> _transition(
    SyncLease lease,
    SyncStatus status, {
    String? reason,
    DateTime? nextAttempt,
  }) async {
    await (db.update(
      db.syncJobs,
    )..where((t) => t.id.equals(lease.jobId))).write(
      SyncJobsCompanion(
        status: Value(status.name),
        updatedAt: Value(_now().toUtc()),
        lastError: Value(reason),
        nextAttemptAt: Value(nextAttempt),
      ),
    );
    await _sampleStatus(lease.sampleId, status);
  }

  Future<void> _sampleStatus(String id, SyncStatus status) =>
      (db.update(db.samples)..where((t) => t.id.equals(id))).write(
        SamplesCompanion(syncStatus: Value(status.name)),
      );
}

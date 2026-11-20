import 'package:flutter_test/flutter_test.dart';
import 'package:quillgrade_mobile/features/samples/domain/sample.dart';
import 'package:quillgrade_mobile/features/sync/data/local_sync_queue.dart';

import '../support/storage_fixture.dart';

SyncReceipt receipt(SyncLease lease, {bool side = true}) => SyncReceipt(
  sampleId: lease.sampleId,
  revision: lease.revision,
  idempotencyKey: lease.idempotencyKey,
  recordConfirmed: true,
  endImageConfirmed: true,
  sideImageConfirmed: side,
);

void main() {
  late StorageFixture f;
  setUp(() async => f = await StorageFixture.create());
  tearDown(() => f.dispose());

  test(
    'pending to uploading to synced requires complete matching acknowledgement',
    () async {
      final id = await f.repository.createSample(f.input());
      final lease = (await f.queue.claimNext())!;
      expect(lease.idempotencyKey, '$id:1');
      expect(lease.attempt, 1);
      expect(
        (await f.repository.readSample(id))!.syncStatus,
        SyncStatus.uploading,
      );
      expect(await f.queue.claimNext(), isNull);
      await expectLater(
        f.queue.acknowledge(lease, receipt(lease, side: false)),
        throwsStateError,
      );
      expect(
        (await f.repository.readSample(id))!.syncStatus,
        SyncStatus.uploading,
      );
      await f.queue.acknowledge(lease, receipt(lease));
      expect(
        (await f.repository.readSample(id))!.syncStatus,
        SyncStatus.synced,
      );
      final stats = await f.repository.getStatistics();
      expect(stats.synced, 1);
      expect(stats.pending, 0);
      expect(
        (await f.queue.watchLastSyncedAt().first)?.toUtc(),
        StorageFixture.time,
      );
      await expectLater(
        f.queue.acknowledge(lease, receipt(lease)),
        throwsStateError,
      );
    },
  );

  test(
    'failed jobs retain errors, bounded backoff and stable retry identity',
    () async {
      await f.repository.createSample(f.input());
      final lease = (await f.queue.claimNext())!;
      await f.queue.fail(lease, reason: 'Isolated simulated failure');
      final job = await f.db.select(f.db.syncJobs).getSingle();
      expect(job.status, 'failed');
      expect(job.lastError, 'Isolated simulated failure');
      expect(
        job.nextAttemptAt!.toUtc(),
        StorageFixture.time.add(const Duration(seconds: 30)),
      );
      await f.queue.retry(job.id);
      expect(await f.queue.claimNext(), isNull);
      f.clock = f.clock.add(const Duration(minutes: 1));
      final retry = (await f.queue.claimNext())!;
      expect(retry.idempotencyKey, lease.idempotencyKey);
      expect(retry.attempt, 2);
      await expectLater(
        f.queue.fail(lease, reason: 'Late callback'),
        throwsStateError,
      );
      await f.queue.acknowledge(retry, receipt(retry));
    },
  );

  test(
    'conflicts need explicit retry and local revisions reject stale completion',
    () async {
      final id = await f.repository.createSample(f.input());
      final first = (await f.queue.claimNext())!;
      await f.queue.fail(first, reason: 'Conflict fixture', conflict: true);
      expect((await f.repository.getStatistics()).conflict, 1);
      expect(await f.queue.claimNext(), isNull);
      await f.queue.retry(first.jobId);
      final second = (await f.queue.claimNext())!;
      await f.repository.updateSample(
        id,
        code: 'EDITED',
        notes: 'Changed during upload',
      );
      await expectLater(
        f.queue.acknowledge(second, receipt(second)),
        throwsStateError,
      );
      final third = (await f.queue.claimNext())!;
      expect(third.revision, 2);
      expect(third.idempotencyKey, '$id:2');
      await f.queue.acknowledge(third, receipt(third));
      expect(
        (await f.repository.readSample(id))!.syncStatus,
        SyncStatus.synced,
      );
    },
  );

  test(
    'deleting a sample cancels queued work and rejects delayed callbacks',
    () async {
      final id = await f.repository.createSample(f.input());
      final lease = (await f.queue.claimNext())!;
      await f.repository.deleteSample(id);
      expect(await f.queue.watchJobs().first, isEmpty);
      await expectLater(
        f.queue.acknowledge(lease, receipt(lease)),
        throwsStateError,
      );
      expect(await f.queue.claimNext(), isNull);
    },
  );
}

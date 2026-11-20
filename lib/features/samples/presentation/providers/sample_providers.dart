import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../../sync/data/local_sync_queue.dart';
import '../../data/local_sample_repository.dart';
import '../../domain/sample.dart';

final localSyncQueueProvider = Provider<LocalSyncQueue>(
  (ref) => LocalSyncQueue(ref.watch(appDatabaseProvider)),
);
final lastSyncedAtProvider = StreamProvider<DateTime?>(
  (ref) => ref.watch(localSyncQueueProvider).watchLastSyncedAt(),
);
final sampleRepositoryProvider = Provider<LocalSampleRepository>(
  (ref) => LocalSampleRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(imageStorageProvider),
    ref.watch(localSyncQueueProvider),
  ),
);
final localStatisticsProvider = StreamProvider<LocalStatistics>((ref) {
  // Refresh the rolling date window even when no records are edited.
  final timer = Timer.periodic(
    const Duration(minutes: 1),
    (_) => ref.invalidateSelf(),
  );
  ref.onDispose(timer.cancel);
  return ref.watch(sampleRepositoryProvider).watchStatistics();
});
final sampleListProvider = StreamProvider.autoDispose
    .family<List<SampleRecord>, SampleQuery>(
      (ref, query) => ref.watch(sampleRepositoryProvider).watchSamples(query),
    );
final sampleDetailProvider = StreamProvider.autoDispose
    .family<SampleRecord?, String>(
      (ref, id) => ref.watch(sampleRepositoryProvider).watchSample(id),
    );

final sampleImageProvider = FutureProvider.autoDispose.family<File?, String>(
  (ref, path) => ref.watch(imageStorageProvider).resolve(path),
);

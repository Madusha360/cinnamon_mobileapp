import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/widgets/status_indicator.dart';
import '../../domain/sample.dart';
import '../providers/sample_providers.dart';

String syncStatusLabel(BuildContext context, SyncStatus status) =>
    switch (status) {
      SyncStatus.pending => context.l10n.pending,
      SyncStatus.uploading => context.l10n.uploading,
      SyncStatus.synced => context.l10n.synced,
      SyncStatus.failed => context.l10n.failed,
      SyncStatus.conflict => context.l10n.conflict,
    };

class SampleSyncIndicator extends StatelessWidget {
  const SampleSyncIndicator(this.status, {super.key});
  final SyncStatus status;
  @override
  Widget build(BuildContext context) => StatusIndicator(
    label: syncStatusLabel(context, status),
    tone: switch (status) {
      SyncStatus.synced => StatusTone.positive,
      SyncStatus.failed => StatusTone.negative,
      SyncStatus.conflict => StatusTone.uncertain,
      _ => StatusTone.neutral,
    },
    icon: status == SyncStatus.synced
        ? Icons.cloud_done_outlined
        : Icons.cloud_upload_outlined,
  );
}

class SamplePhoto extends ConsumerWidget {
  const SamplePhoto({
    super.key,
    required this.path,
    required this.label,
    this.height = 120,
  });
  final String? path;
  final String label;
  final double height;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget missing() => Tooltip(
      message: context.l10n.missingImageBody,
      child: Semantics(
        label: '$label. ${context.l10n.missingImage}',
        child: Container(
          height: height,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          alignment: Alignment.center,
          child: const Icon(Icons.broken_image_outlined),
        ),
      ),
    );
    if (path == null) return missing();
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: ref
          .watch(sampleImageProvider(path!))
          .when(
            loading: () => SizedBox(
              height: height,
              child: const Center(child: Icon(Icons.photo_outlined)),
            ),
            error: (_, _) => missing(),
            data: (file) => file == null
                ? missing()
                : Image.file(
                    file,
                    height: height,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    semanticLabel: label,
                    cacheWidth: 800,
                    errorBuilder: (_, _, _) => missing(),
                  ),
          ),
    );
  }
}

class SampleCard extends StatelessWidget {
  const SampleCard(this.sample, {super.key});
  final SampleRecord sample;
  @override
  Widget build(BuildContext context) => Card(
    child: InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => context.push(RouteNames.sampleDetail(sample.id)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 64,
                  child: SamplePhoto(
                    path: sample.endImagePath,
                    label: context.l10n.endViewCapture,
                    height: 64,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sample.code,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        DateFormat.yMMMd().add_jm().format(
                          sample.capturedAt.toLocal(),
                        ),
                      ),
                      if (sample.batchId != null)
                        Text('${context.l10n.batchId}: ${sample.batchId}'),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              sample.maximumWidthMm == null
                  ? context.l10n.notMeasured
                  : '${context.l10n.maximumWidth}: ${sample.maximumWidthMm!.toStringAsFixed(2)} mm',
            ),
            Text(sample.finishingQuality ?? context.l10n.notAnalyzed),
            const SizedBox(height: 10),
            SampleSyncIndicator(sample.syncStatus),
          ],
        ),
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_page.dart';
import '../../../../core/widgets/status_indicator.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../samples/presentation/providers/sample_providers.dart';

class SyncPage extends ConsumerWidget {
  const SyncPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = context.l10n;
    final statistics = ref.watch(localStatisticsProvider);
    final counts = statistics.asData?.value;
    final lastSync = ref.watch(lastSyncedAtProvider);
    return AppPage(
      title: text.sync,
      subtitle: text.syncSubtitle,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: StatusIndicator(
            label: text.cloudNotConnected,
            icon: Icons.cloud_off_outlined,
          ),
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text.manualSync,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                Text(text.manualSyncBody),
                const SizedBox(height: 20),
                Text(
                  text.cloudNotConnectedBody,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: text.syncUnavailable,
                  icon: Icons.sync_rounded,
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.push(RouteNames.profile),
                  child: Text(text.accountOptions),
                ),
              ],
            ),
          ),
        ),
        SectionHeading(text.workspaceOverview),
        Text(text.localQueueNote),
        if (statistics.hasError)
          ErrorView(
            title: text.localDataError,
            message: text.localDataErrorBody,
            retryLabel: text.retry,
            onRetry: () => ref.invalidate(localStatisticsProvider),
          ),
        Card(
          child: Column(
            children: [
              for (final item in [
                (
                  text.pendingSync,
                  Icons.cloud_upload_outlined,
                  counts?.pending,
                ),
                (text.syncedSamples, Icons.cloud_done_outlined, counts?.synced),
                (text.uploading, Icons.sync_outlined, counts?.uploading),
                (text.failed, Icons.error_outline_rounded, counts?.failed),
                (text.conflict, Icons.compare_arrows, counts?.conflict),
              ])
                ListTile(
                  leading: Icon(
                    item.$2,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(item.$1),
                  trailing: Semantics(
                    label: '${item.$1}: ${item.$3 ?? text.localDataLoading}',
                    child: Text(item.$3?.toString() ?? '—'),
                  ),
                ),
              const Divider(indent: 20, endIndent: 20),
              ListTile(
                title: Text(text.lastSync),
                subtitle: Text(
                  lastSync.when(
                    data: (date) => date == null
                        ? text.neverSynced
                        : DateFormat.yMMMd().add_jm().format(date.toLocal()),
                    loading: () => text.localDataLoading,
                    error: (_, _) => text.localDataError,
                  ),
                ),
              ),
            ],
          ),
        ),
        SectionHeading(text.syncPreferences),
        Card(
          child: SwitchListTile(
            value: false,
            onChanged: null,
            title: Text(text.automaticSync),
            subtitle: Text(text.automaticSyncDescription),
          ),
        ),
        SectionHeading(text.syncFlowTitle),
        for (final item in [
          (1, text.syncStepOne),
          (2, text.syncStepTwo),
          (3, text.syncStepThree),
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primaryContainer,
                  child: Text(
                    '${item.$1}',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(child: Text(item.$2)),
              ],
            ),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_page.dart';
import '../../../../core/widgets/brand_logo.dart';
import '../../../../core/widgets/status_indicator.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../samples/presentation/providers/sample_providers.dart';
import '../../../../shared/widgets/quill_illustration.dart';
import '../widgets/recent_samples_card.dart';
import '../widgets/stats_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = context.l10n;
    final colors = Theme.of(context).colorScheme;
    final statistics = ref.watch(localStatisticsProvider);
    final counts = statistics.asData?.value;
    return AppPage(
      title: text.appName,
      subtitle: text.homeSubtitle,
      heading: text.greeting,
      titleWidget: Row(
        children: [
          const BrandLogo(size: 40),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text.appName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: text.settings,
          onPressed: () => context.push(RouteNames.settings),
          icon: const Icon(Icons.tune_rounded),
        ),
        IconButton(
          tooltip: text.profile,
          onPressed: () => context.push(RouteNames.profile),
          icon: const Icon(Icons.account_circle_outlined),
        ),
      ],
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: StatusIndicator(
            label: text.localMode,
            icon: Icons.offline_bolt_outlined,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.forest,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text.inspectionEyebrow,
                style: Theme.of(context).textTheme.labelSmall
                    ?.copyWith(color: AppColors.darkOrange, letterSpacing: 1.3),
              ),
              const SizedBox(height: 16),
              Text(
                text.inspectionTitle,
                style: Theme.of(context).textTheme.headlineLarge
                    ?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                text.inspectionBody,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: const Color(0xFFE0E9DE)),
              ),
              const QuillIllustration(height: 135),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.forest,
                  ),
                  onPressed: () => context.go(RouteNames.capture),
                  icon: const Icon(Icons.center_focus_strong_rounded),
                  label: Text(text.prepareCapture),
                ),
              ),
            ],
          ),
        ),
        SectionHeading(text.workspaceOverview),
        LayoutBuilder(
          builder: (context, constraints) {
            final count =
                constraints.maxWidth < 300 ||
                    MediaQuery.textScalerOf(context).scale(1) > 1.4
                ? 1
                : 2;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final item in [
                  (
                    text.totalSamples,
                    Icons.inventory_2_outlined,
                    counts?.total,
                  ),
                  (
                    text.pendingSync,
                    Icons.cloud_upload_outlined,
                    counts?.pending,
                  ),
                  (
                    text.syncedSamples,
                    Icons.cloud_done_outlined,
                    counts?.synced,
                  ),
                  (
                    text.recentSampleCount,
                    Icons.history_rounded,
                    counts?.recent,
                  ),
                ])
                  SizedBox(
                    width: (constraints.maxWidth - 12 * (count - 1)) / count,
                    child: StatsCard(
                      label: item.$1,
                      icon: item.$2,
                      unavailableLabel: statistics.hasError
                          ? text.statisticsUnavailable
                          : text.localDataLoading,
                      value: item.$3,
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 10),
        Text(
          text.statisticsNote,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: colors.onSurfaceVariant),
        ),
        SectionHeading(text.quickActions),
        if (statistics.hasError)
          ErrorView(
            title: text.localDataError,
            message: text.localDataErrorBody,
            retryLabel: text.retry,
            onRetry: () => ref.invalidate(localStatisticsProvider),
          ),
        LayoutBuilder(
          builder: (context, constraints) {
            final count =
                constraints.maxWidth > 550 &&
                    MediaQuery.textScalerOf(context).scale(1) <= 1.4
                ? 4
                : 2;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final item in [
                  (text.capture, Icons.camera_alt_outlined, RouteNames.capture),
                  (text.history, Icons.history_rounded, RouteNames.history),
                  (text.sync, Icons.cloud_sync_outlined, RouteNames.sync),
                  (
                    text.calibration,
                    Icons.straighten_rounded,
                    RouteNames.calibration,
                  ),
                ])
                  SizedBox(
                    width: (constraints.maxWidth - 12 * (count - 1)) / count,
                    child: Card(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () {
                          if (item.$3 == RouteNames.calibration) {
                            context.push(item.$3);
                          } else {
                            context.go(item.$3);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(item.$2, color: colors.primary),
                              const SizedBox(height: 12),
                              Text(
                                item.$1,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        SectionHeading(
          text.recentActivity,
          action: IconButton(
            tooltip: text.viewHistory,
            onPressed: () => context.go(RouteNames.history),
            icon: const Icon(Icons.arrow_forward_rounded),
          ),
        ),
        const RecentSamplesCard(),
        const SizedBox(height: 20),
        Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(20),
            leading: Icon(Icons.menu_book_outlined, color: colors.secondary),
            title: Text(text.captureGuide),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(text.captureGuideBody),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go(RouteNames.study),
          ),
        ),
      ],
    );
  }
}

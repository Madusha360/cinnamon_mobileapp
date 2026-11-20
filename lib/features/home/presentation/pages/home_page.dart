import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_page.dart';
import '../../../../shared/widgets/quill_illustration.dart';
import '../widgets/recent_samples_card.dart';
import '../widgets/stats_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final text = context.l10n;
    return AppPage(
      title: text.appName,
      subtitle: text.homeSubtitle,
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
        const SizedBox(width: 8),
      ],
      children: [
        Row(
          children: [
            Icon(
              Icons.offline_bolt_outlined,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              text.localMode,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                letterSpacing: 1.6,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
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
                text.inspectionTitle,
                style: Theme.of(context).textTheme.headlineLarge
                    ?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                text.inspectionBody,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: const Color(0xFFDBE8DE)),
              ),
              const QuillIllustration(height: 175),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.cream,
                    foregroundColor: AppColors.forest,
                  ),
                  onPressed: () => context.go(RouteNames.capture),
                  icon: const Icon(Icons.add_a_photo_outlined, size: 20),
                  label: Text(text.prepareCapture),
                ),
              ),
            ],
          ),
        ),
        SectionHeading(text.workspaceOverview),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns =
                constraints.maxWidth < 330 ||
                    MediaQuery.textScalerOf(context).scale(1) > 1.4
                ? 1
                : 3;
            final items = [
              (text.totalSamples, Icons.inventory_2_outlined),
              (text.pendingSync, Icons.cloud_upload_outlined),
              (text.syncedSamples, Icons.cloud_done_outlined),
            ];
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final item in items)
                  SizedBox(
                    width:
                        (constraints.maxWidth - 12 * (columns - 1)) / columns,
                    child: StatsCard(
                      label: item.$1,
                      icon: item.$2,
                      unavailableLabel: text.statisticsUnavailable,
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 10),
        Text(
          text.statisticsUnavailable,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        SectionHeading(
          text.recentSamples,
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
            leading: Icon(
              Icons.auto_stories_outlined,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text(text.captureGuide),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(text.captureGuideBody),
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.go(RouteNames.study),
          ),
        ),
      ],
    );
  }
}

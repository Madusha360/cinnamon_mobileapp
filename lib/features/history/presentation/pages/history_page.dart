import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/widgets/app_page.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/status_card.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) => AppPage(
    title: context.l10n.history,
    subtitle: context.l10n.historySubtitle,
    actions: [
      IconButton(
        tooltip: context.l10n.reports,
        onPressed: () => context.push(RouteNames.reports),
        icon: const Icon(Icons.ios_share_rounded),
      ),
      const SizedBox(width: 8),
    ],
    children: [
      EmptyState(
        title: context.l10n.historyUnavailable,
        message: context.l10n.historyUnavailableBody,
        icon: Icons.history_rounded,
        action: OutlinedButton.icon(
          onPressed: () => context.go(RouteNames.capture),
          icon: const Icon(Icons.add_a_photo_outlined),
          label: Text(context.l10n.exploreCapture),
        ),
      ),
      const SizedBox(height: 20),
      StatusCard(
        title: context.l10n.historyStorageTitle,
        message: context.l10n.historyStorageBody,
        icon: Icons.storage_rounded,
      ),
    ],
  );
}

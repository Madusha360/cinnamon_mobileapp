import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_page.dart';
import '../../../../core/widgets/status_card.dart';

class SyncPage extends StatelessWidget {
  const SyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    final text = context.l10n;
    return AppPage(
      title: text.sync,
      subtitle: text.syncSubtitle,
      children: [
        StatusCard(
          title: text.manualSync,
          message: text.manualSyncBody,
          icon: Icons.touch_app_outlined,
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(
                  Icons.cloud_off_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 48,
                ),
                const SizedBox(height: 20),
                Text(
                  text.cloudNotConnected,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(text.cloudNotConnectedBody, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                AppButton(
                  label: text.syncUnavailable,
                  icon: Icons.sync_rounded,
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => context.push(RouteNames.profile),
                  child: Text(text.accountOptions),
                ),
              ],
            ),
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

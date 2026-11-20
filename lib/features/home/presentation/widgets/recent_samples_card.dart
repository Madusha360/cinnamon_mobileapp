import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/widgets/empty_state.dart';

class RecentSamplesCard extends StatelessWidget {
  const RecentSamplesCard({super.key});

  @override
  Widget build(BuildContext context) => EmptyState(
    title: context.l10n.historyUnavailable,
    message: context.l10n.historyUnavailableBody,
    icon: Icons.document_scanner_outlined,
    action: OutlinedButton(
      onPressed: () => context.go(RouteNames.capture),
      child: Text(context.l10n.exploreCapture),
    ),
  );
}

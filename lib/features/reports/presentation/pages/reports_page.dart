import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/widgets/app_page.dart';
import '../../../../core/widgets/empty_state.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});
  @override
  Widget build(BuildContext context) => AppPage(
    title: context.l10n.reports,
    subtitle: context.l10n.reportsSubtitle,
    children: [
      EmptyState(
        title: context.l10n.reportsUnavailable,
        message: context.l10n.reportsBody,
        icon: Icons.description_outlined,
        action: OutlinedButton(
          onPressed: () => context.go(RouteNames.history),
          child: Text(context.l10n.viewHistory),
        ),
      ),
    ],
  );
}

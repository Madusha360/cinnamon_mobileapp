import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_page.dart';
import '../../../../core/widgets/status_card.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) => AppPage(
    title: context.l10n.login,
    subtitle: context.l10n.loginSubtitle,
    children: [
      StatusCard(
        title: context.l10n.authUnavailable,
        message: context.l10n.authUnavailableBody,
        icon: Icons.lock_outline_rounded,
      ),
      const SizedBox(height: 24),
      AppButton(
        label: context.l10n.returnToWorkspace,
        onPressed: () => context.go(RouteNames.home),
      ),
      const SizedBox(height: 12),
      TextButton(
        onPressed: () => context.push(RouteNames.register),
        child: Text(context.l10n.register),
      ),
    ],
  );
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_page.dart';
import '../../../../core/widgets/status_card.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});
  @override
  Widget build(BuildContext context) => AppPage(
    title: context.l10n.register,
    subtitle: context.l10n.registerSubtitle,
    children: [
      StatusCard(
        title: context.l10n.authUnavailable,
        message: context.l10n.authUnavailableBody,
        icon: Icons.person_add_outlined,
      ),
      const SizedBox(height: 24),
      AppButton(
        label: context.l10n.returnToWorkspace,
        onPressed: () => context.go(RouteNames.home),
      ),
    ],
  );
}

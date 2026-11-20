import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/widgets/app_page.dart';
import '../../../../core/widgets/brand_logo.dart';
import '../../../../core/widgets/status_card.dart';
import '../../../../core/widgets/status_indicator.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    final text = context.l10n;
    return AppPage(
      title: text.profile,
      subtitle: text.profileSubtitle,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                const BrandLogo(size: 88),
                const SizedBox(height: 20),
                Text(
                  text.localGuest,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                StatusIndicator(
                  label: text.offlineWorkspace,
                  icon: Icons.offline_bolt_outlined,
                ),
                const SizedBox(height: 18),
                Text(text.guestBody, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        StatusCard(
          title: text.cloudAccount,
          message: text.cloudAccountBody,
          icon: Icons.cloud_outlined,
        ),
        const SizedBox(height: 24),
        OutlinedButton(
          onPressed: () => context.push(RouteNames.login),
          child: Text(text.login),
        ),
        TextButton(
          onPressed: () => context.push(RouteNames.register),
          child: Text(text.register),
        ),
        SectionHeading(text.settings),
        Card(
          child: ListTile(
            leading: const Icon(Icons.tune_rounded),
            title: Text(text.settingsSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(RouteNames.settings),
          ),
        ),
        SectionHeading(text.aboutTitle),
        Text(text.aboutBody),
      ],
    );
  }
}

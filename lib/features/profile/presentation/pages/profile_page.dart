import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/widgets/app_page.dart';
import '../../../../core/widgets/status_card.dart';

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
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primaryContainer,
                  child: Icon(
                    Icons.person_outline_rounded,
                    size: 38,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  text.localGuest,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
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
        const SizedBox(height: 10),
        TextButton(
          onPressed: () => context.push(RouteNames.register),
          child: Text(text.register),
        ),
      ],
    );
  }
}

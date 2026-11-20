import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/storage/app_preferences_store.dart';
import '../../../../core/widgets/app_page.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/status_card.dart';
import '../providers/preferences_provider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});
  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _saving = false;

  Future<void> _setTheme(ThemePreference theme) async {
    setState(() => _saving = true);
    try {
      await ref.read(preferencesProvider.notifier).setTheme(theme);
    } catch (_) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.l10n.saveError)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = context.l10n;
    final preferences = ref.watch(preferencesProvider);
    return AppPage(
      title: text.settings,
      subtitle: text.settingsSubtitle,
      children: [
        Text(text.appearance, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        preferences.when(
          loading: () => LoadingView(label: text.openingWorkspace),
          error: (_, _) => ErrorView(
            title: text.startupError,
            message: text.startupErrorBody,
            retryLabel: text.retry,
            onRetry: () => ref.invalidate(preferencesProvider),
          ),
          data: (value) => Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  for (final item in [
                    (
                      ThemePreference.system,
                      text.systemTheme,
                      Icons.brightness_auto_outlined,
                    ),
                    (
                      ThemePreference.light,
                      text.lightTheme,
                      Icons.light_mode_outlined,
                    ),
                    (
                      ThemePreference.dark,
                      text.darkTheme,
                      Icons.dark_mode_outlined,
                    ),
                  ])
                    ListTile(
                      enabled: !_saving,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      selected: item.$1 == value.theme,
                      selectedTileColor: Theme.of(context).colorScheme.primary
                          .withValues(alpha: 0.07),
                      leading: Icon(item.$3),
                      title: Text(item.$2),
                      trailing: Icon(
                        item.$1 == value.theme
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                      ),
                      onTap: () => _setTheme(item.$1),
                    ),
                ],
              ),
            ),
          ),
        ),
        SectionHeading(text.language),
        StatusCard(
          title: text.languageValue,
          message: text.languageBody,
          icon: Icons.translate_rounded,
        ),
        SectionHeading(text.workspaceSection),
        Card(
          child: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                leading: const Icon(Icons.straighten_rounded),
                title: Text(text.calibrationSettings),
                subtitle: Text(text.calibrationSettingsBody),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(RouteNames.calibration),
              ),
              const Divider(indent: 20, endIndent: 20),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                leading: const Icon(Icons.account_circle_outlined),
                title: Text(text.accountSettings),
                subtitle: Text(text.accountSettingsBody),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(RouteNames.profile),
              ),
              const Divider(indent: 20, endIndent: 20),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                leading: const Icon(Icons.explore_outlined),
                title: Text(text.replayOnboarding),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(RouteNames.onboarding),
              ),
            ],
          ),
        ),
        SectionHeading(text.modelStatus),
        StatusCard(
          title: text.detectorStatus,
          message: text.finishingStatus,
          icon: Icons.model_training_rounded,
          warning: true,
        ),
        SectionHeading(text.storageTitle),
        StatusCard(
          title: text.reports,
          message: text.storageBody,
          icon: Icons.folder_outlined,
          child: OutlinedButton(
            onPressed: () => context.push(RouteNames.reports),
            child: Text(text.reports),
          ),
        ),
        SectionHeading(text.aboutTitle),
        Text(text.aboutBody, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

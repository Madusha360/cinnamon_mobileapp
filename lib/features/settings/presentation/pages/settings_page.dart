import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/storage/app_preferences_store.dart';
import '../../../../core/widgets/app_page.dart';
import '../../../../core/widgets/brand_logo.dart';
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
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.l10n.saveError)));
      }
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
              padding: const EdgeInsets.all(10),
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
                      selected: value.theme == item.$1,
                      selectedTileColor: Theme.of(context)
                          .colorScheme
                          .primaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      leading: Icon(item.$3),
                      title: Text(item.$2),
                      trailing: Icon(
                        value.theme == item.$1
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
        SectionHeading(text.cameraSettings),
        Card(
          child: ListTile(
            leading: const Icon(Icons.camera_alt_outlined),
            title: Text(text.cameraPreferences),
            subtitle: Text(text.cameraPreferencesBody),
            trailing: const Icon(Icons.lock_outline_rounded),
          ),
        ),
        SectionHeading(text.measurementSettings),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.qr_code_2_rounded),
                title: Text(text.calibrationSettings),
                subtitle: Text(text.millimeters20),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(RouteNames.calibration),
              ),
              const Divider(indent: 20, endIndent: 20),
              ListTile(
                leading: const Icon(Icons.straighten_rounded),
                title: Text(text.displayUnits),
                subtitle: Text(text.displayUnitsBody),
              ),
            ],
          ),
        ),
        SectionHeading(text.dataSettings),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.cloud_sync_outlined),
                title: Text(text.syncPreferences),
                subtitle: Text(text.manualSync),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go(RouteNames.sync),
              ),
              const Divider(indent: 20, endIndent: 20),
              ListTile(
                leading: const Icon(Icons.storage_outlined),
                title: Text(text.storagePreferences),
                subtitle: Text(text.storagePreferencesBody),
              ),
              const Divider(indent: 20, endIndent: 20),
              ListTile(
                leading: const Icon(Icons.ios_share_outlined),
                title: Text(text.reports),
                subtitle: Text(text.storageBody),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(RouteNames.reports),
              ),
            ],
          ),
        ),
        SectionHeading(text.accountSettings),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.account_circle_outlined),
                title: Text(text.profile),
                subtitle: Text(text.localGuest),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(RouteNames.profile),
              ),
              const Divider(indent: 20, endIndent: 20),
              ListTile(
                enabled: false,
                leading: const Icon(Icons.logout_rounded),
                title: Text(text.logout),
                subtitle: Text(text.logoutGuest),
              ),
            ],
          ),
        ),
        SectionHeading(text.modelStatus),
        StatusCard(
          title: text.detectorStatus,
          message: text.finishingStatus,
          icon: Icons.model_training_outlined,
        ),
        SectionHeading(text.aboutTitle),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BrandLogo(size: 72),
                const SizedBox(height: 16),
                Text(
                  text.appName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(text.aboutBody),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => context.push(RouteNames.onboarding),
                  icon: const Icon(Icons.explore_outlined),
                  label: Text(text.replayOnboarding),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

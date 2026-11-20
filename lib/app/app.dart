import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/app_config.dart';
import '../core/storage/app_preferences_store.dart';
import '../features/settings/presentation/providers/preferences_provider.dart';
import 'l10n/generated/app_localizations.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class QuillGradeApp extends ConsumerWidget {
  const QuillGradeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(preferencesProvider).asData?.value;
    return MaterialApp.router(
      title: AppConfig.name,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: switch (preferences?.theme ?? ThemePreference.system) {
        ThemePreference.system => ThemeMode.system,
        ThemePreference.light => ThemeMode.light,
        ThemePreference.dark => ThemeMode.dark,
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}

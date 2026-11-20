import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../settings/presentation/providers/preferences_provider.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(preferencesProvider);
    final value = preferences.asData?.value;
    if (value != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted &&
            GoRouterState.of(context).uri.path == RouteNames.splash) {
          context.go(
            value.onboardingComplete ? RouteNames.home : RouteNames.onboarding,
          );
        }
      });
    }
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: preferences.hasError
                  ? ErrorView(
                      title: context.l10n.startupError,
                      message: context.l10n.startupErrorBody,
                      retryLabel: context.l10n.retry,
                      onRetry: () => ref.invalidate(preferencesProvider),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.spa_rounded,
                          size: 64,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          context.l10n.appName,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 32),
                        LoadingView(label: context.l10n.openingWorkspace),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

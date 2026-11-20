import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/brand_logo.dart';
import '../../../../shared/widgets/quill_illustration.dart';
import '../../../settings/presentation/providers/preferences_provider.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});
  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  int _step = 0;
  bool _saving = false;
  Future<void> _finish() async {
    setState(() => _saving = true);
    try {
      await ref.read(preferencesProvider.notifier).completeOnboarding();
      if (mounted) context.go(RouteNames.home);
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
    final steps = [
      (text.welcome, text.welcomeBody, text.detectCinnamon),
      (text.onboardingEndTitle, text.onboardingEndBody, text.measureQuill),
      (
        text.onboardingSideTitle,
        text.onboardingSideBody,
        text.analyzeFinishing,
      ),
      (
        text.onboardingOfflineTitle,
        text.onboardingOfflineBody,
        text.saveOffline,
      ),
    ];
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Row(
                  children: [
                    const BrandLogo(size: 48),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        text.appName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    TextButton(
                      onPressed: _saving ? null : _finish,
                      child: Text(text.skip),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.forest,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      QuillIllustration(endView: _step == 1, height: 200),
                      Text(
                        steps[_step].$3,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  text.tagline,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                AnimatedSwitcher(
                  duration: AppTokens.motion(context),
                  child: Column(
                    key: ValueKey(_step),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        steps[_step].$1,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        steps[_step].$2,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    for (var i = 0; i < steps.length; i++)
                      AnimatedContainer(
                        duration: AppTokens.motion(context),
                        width: i == _step ? 28 : 8,
                        height: 6,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          color: i == _step
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '${_step + 1} / ${steps.length}',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: _step == steps.length - 1 || _step == 0
                      ? text.getStarted
                      : text.next,
                  busy: _saving,
                  onPressed: () {
                    if (_step == steps.length - 1) {
                      _finish();
                    } else {
                      setState(() => _step++);
                    }
                  },
                ),
                TextButton(
                  onPressed: _saving ? null : _finish,
                  child: Text(text.continueAsGuest),
                ),
                if (_step > 0)
                  TextButton(
                    onPressed: _saving ? null : () => setState(() => _step--),
                    child: Text(text.back),
                  ),
                const SizedBox(height: 8),
                Text(
                  text.onboardingFootnote,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

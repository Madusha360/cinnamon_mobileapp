import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
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
      (text.welcome, text.welcomeBody),
      (text.onboardingEndTitle, text.onboardingEndBody),
      (text.onboardingSideTitle, text.onboardingSideBody),
      (text.onboardingOfflineTitle, text.onboardingOfflineBody),
    ];
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.all(28),
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.spa_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        text.appName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.forest,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: QuillIllustration(endView: _step == 1, height: 240),
                ),
                const SizedBox(height: 32),
                Text(
                  text.tagline,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    letterSpacing: 2,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 14),
                AnimatedSwitcher(
                  duration: MediaQuery.disableAnimationsOf(context)
                      ? Duration.zero
                      : const Duration(milliseconds: 250),
                  child: Column(
                    key: ValueKey(_step),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        steps[_step].$1,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        steps[_step].$2,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: List.generate(
                    steps.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 7),
                      width: index == _step ? 28 : 8,
                      height: 7,
                      decoration: BoxDecoration(
                        color: index == _step
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_step + 1} / ${steps.length}',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 28),
                AppButton(
                  label: _step == steps.length - 1
                      ? text.continueAsGuest
                      : (_step == 0 ? text.getStarted : text.next),
                  busy: _saving,
                  onPressed: () {
                    if (_step == steps.length - 1) {
                      _finish();
                    } else {
                      setState(() => _step++);
                    }
                  },
                ),
                const SizedBox(height: 8),
                if (_step > 0)
                  TextButton(
                    onPressed: _saving ? null : () => setState(() => _step--),
                    child: Text(text.back),
                  )
                else
                  TextButton(
                    onPressed: _saving ? null : _finish,
                    child: Text(text.continueAsGuest),
                  ),
                const SizedBox(height: 12),
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

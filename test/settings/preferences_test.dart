import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quillgrade_mobile/core/storage/app_preferences_store.dart';
import 'package:quillgrade_mobile/features/settings/presentation/providers/preferences_provider.dart';

import '../support/test_app.dart';

void main() {
  test('preferences round trip and unknown themes use the system default', () {
    const original = AppPreferences(
      onboardingComplete: true,
      theme: ThemePreference.dark,
    );
    final restored = AppPreferences.fromJson(original.toJson());
    expect(restored.onboardingComplete, isTrue);
    expect(restored.theme, ThemePreference.dark);
    expect(
      AppPreferences.fromJson({'theme': 'future'}).theme,
      ThemePreference.system,
    );
  });

  test('overlapping preference updates preserve both changes', () async {
    final store = MemoryPreferencesStore();
    final container = ProviderContainer(
      overrides: [preferencesStoreProvider.overrideWithValue(store)],
    );
    addTearDown(container.dispose);
    await container.read(preferencesProvider.future);
    final controller = container.read(preferencesProvider.notifier);
    await Future.wait([
      controller.completeOnboarding(),
      controller.setTheme(ThemePreference.dark),
    ]);
    expect(store.value.onboardingComplete, isTrue);
    expect(store.value.theme, ThemePreference.dark);
  });

  test(
    'a failed write preserves prior values and allows a later retry',
    () async {
      final store = MemoryPreferencesStore()..failWrite = true;
      final container = ProviderContainer(
        overrides: [preferencesStoreProvider.overrideWithValue(store)],
      );
      addTearDown(container.dispose);
      await container.read(preferencesProvider.future);
      final controller = container.read(preferencesProvider.notifier);
      await expectLater(
        controller.setTheme(ThemePreference.dark),
        throwsStateError,
      );
      expect(
        container.read(preferencesProvider).requireValue.theme,
        ThemePreference.system,
      );
      store.failWrite = false;
      await controller.setTheme(ThemePreference.light);
      expect(store.value.theme, ThemePreference.light);
    },
  );
}

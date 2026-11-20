import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/storage/app_preferences_store.dart';

final preferencesStoreProvider = Provider<AppPreferencesStore>(
  (ref) => LocalAppPreferencesStore(SharedPreferencesAsync()),
);
final preferencesProvider =
    AsyncNotifierProvider<PreferencesController, AppPreferences>(
      PreferencesController.new,
    );

class PreferencesController extends AsyncNotifier<AppPreferences> {
  Future<void> _pending = Future.value();

  @override
  Future<AppPreferences> build() => ref.read(preferencesStoreProvider).read();

  Future<void> completeOnboarding() =>
      _update((current) => current.copyWith(onboardingComplete: true));
  Future<void> setTheme(ThemePreference theme) =>
      _update((current) => current.copyWith(theme: theme));

  Future<void> _update(AppPreferences Function(AppPreferences) change) {
    final operation = _pending.then((_) async {
      final current = await future;
      final updated = change(current);
      await ref.read(preferencesStoreProvider).write(updated);
      if (ref.mounted) state = AsyncData(updated);
    });
    // A failed write must not prevent later retries or discard earlier settings.
    _pending = operation.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    return operation;
  }
}

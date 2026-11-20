import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum ThemePreference { system, light, dark }

class AppPreferences {
  const AppPreferences({
    this.onboardingComplete = false,
    this.theme = ThemePreference.system,
  });
  final bool onboardingComplete;
  final ThemePreference theme;

  AppPreferences copyWith({bool? onboardingComplete, ThemePreference? theme}) =>
      AppPreferences(
        onboardingComplete: onboardingComplete ?? this.onboardingComplete,
        theme: theme ?? this.theme,
      );

  Map<String, Object> toJson() => {
    'onboardingComplete': onboardingComplete,
    'theme': theme.name,
  };

  factory AppPreferences.fromJson(Map<String, dynamic> json) => AppPreferences(
    onboardingComplete: json['onboardingComplete'] == true,
    theme: ThemePreference.values.firstWhere(
      (value) => value.name == json['theme'],
      orElse: () => ThemePreference.system,
    ),
  );
}

abstract interface class AppPreferencesStore {
  Future<AppPreferences> read();
  Future<void> write(AppPreferences preferences);
}

// Only non-critical UI preferences belong here. Samples will use Drift.
class LocalAppPreferencesStore implements AppPreferencesStore {
  LocalAppPreferencesStore(this._preferences);
  final SharedPreferencesAsync _preferences;
  static const _key = 'quillgrade.ui_preferences.v1';

  @override
  Future<AppPreferences> read() async {
    final value = await _preferences.getString(_key);
    if (value == null) return const AppPreferences();
    return AppPreferences.fromJson(jsonDecode(value) as Map<String, dynamic>);
  }

  @override
  Future<void> write(AppPreferences preferences) =>
      _preferences.setString(_key, jsonEncode(preferences.toJson()));
}

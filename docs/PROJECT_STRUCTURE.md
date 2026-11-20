# Project structure

This Git root is a standalone Flutter mobile workspace, originally named `cinnamon_mobileapp`. It is not nested in a MERN repository. Keep this root in place; do not create a second nested Flutter project or add frontend/backend code.

```text
pubspec.yaml / pubspec.lock    App manifest and reproducible dependencies
android/                      Native Android host, future OpenCV implementation
ios/                          Native iOS host (build on macOS)
assets/data/                  Capture preparation requirements
lib/
  main.dart                   Flutter and ProviderScope bootstrap
  app/                        App composition, theme, router, localization
  core/                       Configuration, UI preference storage, common widgets
  features/                   Feature-owned presentation and settings provider
  shared/widgets/             Reusable navigation shell and vector illustration
test/                         Isolated widget and preference tests
integration_test/             Native-device guest navigation smoke test
docs/                         Scope, ownership, contracts and implementation guides
```

Only Phase 1 files are present. Create domain/data layers when implementing their real behavior; do not prefill the approved structure with empty files. Future `assets/images`, `assets/icons` and `assets/models` directories should be created when actual assets exist. A decorative `CustomPainter` currently needs no raster images or model files.

Presentation owns pages, providers and UI state. Domain will own sample entities, validated detection/measurement results and repository/engine interfaces. Data will implement Drift, camera, inference, native vision and REST adapters. SQL, networking and inference must stay out of widgets.

Two small infrastructure additions serve this phase: `core/storage/app_preferences_store.dart` isolates persistent non-critical UI preferences, and `features/settings/presentation/providers/preferences_provider.dart` owns their asynchronous state. They do not implement a substitute sample database.

`lib/app/l10n/app_en.arb` is the English source of truth. `flutter gen-l10n` generates ignored Dart files in `lib/app/l10n/generated/`; never edit generated output. Add a complete, reviewed `app_si.arb` to introduce Sinhala. Widgets use wrapping layouts and locale-independent navigation paths. No fonts are fetched at runtime.

The single `StatefulShellRoute.indexedStack` retains Home, Capture, History, Sync and Study branches. Secondary screens use GoRouter on the root stack. No account redirect blocks the local workspace. Unrecognized routes offer a Home recovery action. Capture preparation subroutes retain the shell and have a safe back action.

App preferences are versioned JSON in one namespaced native preference key. Updates are serialized; failed writes retain the previous state and permit retry. Startup loading/errors are visible. SQLite, sample identities and ownership are deliberately deferred to Phase 2.

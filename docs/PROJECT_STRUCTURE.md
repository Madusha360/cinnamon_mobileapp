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
  core/database/              Drift tables, generated schema, migration, connection
  core/storage/               Private original images, SQLite preference import
  core/widgets/               Shared UI and brand widgets
  features/samples/           Sample domain, transactional repository, providers
  features/history/           Existing library and saved-sample details UI
  features/sync/              Persistent local queue and disconnected sync UI
  features/                   Other existing feature-owned data/presentation
  shared/widgets/             Reusable navigation shell and vector illustration
test/                         Isolated widget and preference tests
integration_test/             Native-device guest navigation smoke test
docs/                         Scope, ownership, contracts and implementation guides
```

Phase 1, the UI / offline Study enhancement and Phase 2 persistence are present. Study retains its bundled reference repository. Samples now has domain/data/presentation layers, History reads that repository, and Sync owns its persistent queue. The original logo is in `assets/images/branding/`. Add grade photos, icons and models only when actual authorized assets exist. Decorative `CustomPainter` illustrations never serve as grade evidence.

Presentation owns pages, providers and UI state. Domain will own sample entities, validated detection/measurement results and repository/engine interfaces. Data will implement Drift, camera, inference, native vision and REST adapters. SQL, networking and inference must stay out of widgets.

`core/database/app_database.dart` opens one app-scoped native SQLite database through Riverpod. Its tables live in `core/database/tables.dart`. `core/storage/image_storage_service.dart` stores originals privately, while `sqlite_preferences_store.dart` imports existing UI preferences. Repository and queue methods own database transactions; widgets never execute SQL.

`lib/app/l10n/app_en.arb` is the English source of truth. `flutter gen-l10n` generates ignored Dart files in `lib/app/l10n/generated/`; never edit generated output. Add a complete, reviewed `app_si.arb` to introduce Sinhala. Widgets use wrapping layouts and locale-independent navigation paths. No fonts are fetched at runtime.

The single `StatefulShellRoute.indexedStack` retains Home, Capture, History, Sync and Study branches. Secondary screens use GoRouter on the root stack. No account redirect blocks the local workspace. Unrecognized routes offer a Home recovery action. Capture preparation subroutes retain the shell and have a safe back action.

Study owns nested `/study/grades/:gradeId` and `/study/compare` routes within its existing shell branch. Search/category state survives tab switching and detail navigation. Comparison starts with Alba and C5 Special, or the grade passed in the optional `first` query parameter. Invalid grade identities show a recovery action. `/results` is a root review layout with no accepted sample and disabled saving.

## Offline Study ownership

`assets/data/cinnamon_grades.json` → `study/data/cinnamon_grade_data_source.dart` → `study/data/cinnamon_grade_repository.dart` → Riverpod providers → catalogue, detail and comparison pages. Typed grades, groups and source metadata live in `study/domain/cinnamon_grade.dart`. The source is bundled, with no account/network/database dependency. Search intersects normalized name terms with the selected group. There is no measurement-to-grade assignment function.

Shared branding lives in `core/widgets/brand_logo.dart`; the widget uses the supplied original PNG with `BoxFit.contain` and white backing. `app/theme/app_tokens.dart` centralizes reusable dimensions and reduced-motion durations. Existing buttons, cards, page scaffolds and navigation were extended instead of introducing a second design system. Flutter/platform typography is retained for dependable offline display.

The auth pages share `auth/presentation/widgets/account_form.dart`. Input controllers are screen-local and disposed with the screen. Buttons cannot submit before a real auth adapter exists. Guest access and existing preference values are preserved. History search/filters/sorting are connected to SQLite. Automatic sync, camera preferences and capture saving remain unavailable.

See [UI_STUDY_GUIDE.md](UI_STUDY_GUIDE.md) for reference data and provenance, and [PHASE_2_STORAGE.md](PHASE_2_STORAGE.md) for SQLite ownership and verification. `/history/samples/:sampleId` opens the saved-record review within the existing History tab.

App preferences remain versioned JSON, now in a uniquely keyed `user_preferences` row. Updates are serialized; failed writes retain the previous state and permit retry. Startup loading/errors remain visible. There is no cloud ownership or authentication model yet; records belong to this local installation.

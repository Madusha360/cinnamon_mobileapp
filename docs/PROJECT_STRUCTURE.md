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
  core/storage/               Private originals, temporary capture cache, preferences
  core/widgets/               Shared UI and brand widgets
  features/samples/           Sample domain, transactional repository, providers
  features/history/           Existing library and saved-sample details UI
  features/sync/              Persistent local queue and disconnected sync UI
  features/capture/           Native camera adapter, session domain, providers/UI
  features/cinnamon_detection/ Detection contracts, preprocessing, policy and UI
  features/                   Other existing feature-owned data/presentation
  shared/widgets/             Reusable navigation shell and vector illustration
test/                         Isolated database, storage, camera and widget tests
integration_test/             Native-device guest navigation smoke test
docs/                         Scope, ownership, contracts and implementation guides
ml/cinnamon_detection/        Dataset/training/export/evaluation tools outside Flutter
```

Phase 1, the UI / offline Study enhancement, Phase 2 persistence and Phase 3 camera infrastructure are present. Study retains its bundled reference repository. Samples has domain/data/presentation layers, History reads that repository, and Sync owns its persistent queue. Capture owns the camera adapter, quality checks, temporary session and lifecycle state. The original logo is in `assets/images/branding/`. Add grade photos, icons and models only when actual authorized assets exist. Decorative `CustomPainter` illustrations never serve as grade evidence.

Presentation owns pages, providers and UI state. Domain owns sample entities, capture sessions, typed result inputs and validation/frame interfaces. Data implements Drift repositories and the camera adapter; inference, native vision and REST adapters remain future work. SQL, native camera calls, networking and inference stay out of widgets.

`core/database/app_database.dart` opens one app-scoped native SQLite database through Riverpod. Its tables live in `core/database/tables.dart`. `core/storage/image_storage_service.dart` stores originals privately, while `sqlite_preferences_store.dart` imports existing UI preferences. Repository and queue methods own database transactions; widgets never execute SQL.

`lib/app/l10n/app_en.arb` is the English source of truth. `flutter gen-l10n` generates ignored Dart files in `lib/app/l10n/generated/`; never edit generated output. Add a complete, reviewed `app_si.arb` to introduce Sinhala. Widgets use wrapping layouts and locale-independent navigation paths. No fonts are fetched at runtime.

The single `StatefulShellRoute.indexedStack` retains Home, Capture, History, Sync and Study branches. Secondary screens use GoRouter on the root stack. No account redirect blocks the local workspace. Unrecognized routes offer a Home recovery action. Capture preparation subroutes retain the shell and have a safe back action.

Debug camera routes `/camera/end` and `/camera/side` sit on the root stack; each has a nested `review` route. Their camera widgets track exact route visibility, so a review screen never leaves a hidden native camera running. Backgrounding closes the camera; foregrounding reopens it only on an active camera route. Both UI and controller enforce `kDebugMode`. Release/profile builds retain blocked capture instructions even on direct sandbox routes.

`capture/data/camera_service.dart` is the only device camera adapter. `capture_provider.dart` serializes its operations and invalidates late permission/capture results. `core/storage/image_storage_service.dart` moves native temporary files into a UUID sandbox directory and refuses to promote those files. Capture imports no sample repository or sync queue. `frame_processor.dart` is the Phase 4 integration seam; its provider is null, so no image stream or inference runs now.

Study owns nested `/study/grades/:gradeId` and `/study/compare` routes within its existing shell branch. Search/category state survives tab switching and detail navigation. Comparison starts with Alba and C5 Special, or the grade passed in the optional `first` query parameter. Invalid grade identities show a recovery action. `/results` is a root review layout with no accepted sample and disabled saving.

## Offline Study ownership

`assets/data/cinnamon_grades.json` → `study/data/cinnamon_grade_data_source.dart` → `study/data/cinnamon_grade_repository.dart` → Riverpod providers → catalogue, detail and comparison pages. Typed grades, groups and source metadata live in `study/domain/cinnamon_grade.dart`. The source is bundled, with no account/network/database dependency. Search intersects normalized name terms with the selected group. There is no measurement-to-grade assignment function.

Shared branding lives in `core/widgets/brand_logo.dart`; the widget uses the supplied original PNG with `BoxFit.contain` and white backing. `app/theme/app_tokens.dart` centralizes reusable dimensions and reduced-motion durations. Existing buttons, cards, page scaffolds and navigation were extended instead of introducing a second design system. Flutter/platform typography is retained for dependable offline display.

The auth pages share `auth/presentation/widgets/account_form.dart`. Input controllers are screen-local and disposed with the screen. Buttons cannot submit before a real auth adapter exists. Guest access and existing preference values are preserved. History search/filters/sorting are connected to SQLite. Automatic sync, camera preferences and capture saving remain unavailable.

See [UI_STUDY_GUIDE.md](UI_STUDY_GUIDE.md) for reference data and provenance, and [PHASE_2_STORAGE.md](PHASE_2_STORAGE.md) for SQLite ownership and verification. `/history/samples/:sampleId` opens the saved-record review within the existing History tab.

See [PHASE_3_CAMERA.md](PHASE_3_CAMERA.md) for dependencies, temporary-photo ownership, quality thresholds, native-device testing and the future validated-promotion contract.

Phase 4 adds model-independent detection infrastructure under `features/cinnamon_detection/`. Domain owns detector/result/status/policy contracts. Data owns model integrity and tensor adapters, isolate-based preprocessing, quality rejection and frame/still coordination. Presentation owns conditional Riverpod integration and status/box overlays. Capture still owns the sole native camera service. Its processor provider awaits the detection coordinator and starts a stream only when a compatible model, native runner and explicit evaluated policy are present; none is installed now. `detectionProvider` exposes unavailable state without fabricated predictions. The debug sandbox remains unvalidated and production grading stays blocked.

Training and dataset operations live under `ml/cinnamon_detection/`, with raw data/experiments ignored. SQLite's existing model metadata is unchanged; adding a metadata row does not install or authorize a model. See [DATASET_AUDIT.md](DATASET_AUDIT.md), [AI_MODEL_GUIDE.md](AI_MODEL_GUIDE.md) and [PHASE_4_DETECTION.md](PHASE_4_DETECTION.md) for the unavailable dataset, contract boundaries and verification.

App preferences remain versioned JSON, now in a uniquely keyed `user_preferences` row. Updates are serialized; failed writes retain the previous state and permit retry. Startup loading/errors remain visible. There is no cloud ownership or authentication model yet; records belong to this local installation.

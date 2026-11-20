# QuillGrade — Smart Cinnamon Grading

An independent Flutter mobile app for inspecting two views of the **same physical cinnamon quill**. End View is for width, actual outer perimeter and area; Side View is for finishing. **Quill length is never measured.**

This repository is the standalone mobile project. Its existing directory name, `cinnamon_mobileapp`, is retained; it serves as the requested `QuillGrade-Mobile/` root. `pubspec.yaml`, `lib/`, `android/`, `ios/`, `assets/`, `test/` and `integration_test/` are directly here. No web dashboard or backend is included or accessed.

## Phase 1

Implemented: Material 3 light/dark/system themes, persistent onboarding and appearance preferences, Riverpod state, GoRouter navigation with five retained tab stacks, responsive navigation rail, offline guest workspace, and English localization resources ready for Sinhala translation.

Screens: introduction, Home, Capture preparation, End/Side positioning guides, History, Sync, Study, Settings, Profile, Login/Register availability, Calibration guidance and Reports availability. The vector cinnamon illustrations are decorative, not camera images, training examples or detection results.

The app deliberately reports unavailable capabilities:

- SQLite is Phase 2. Dashboard counts show `—`; no sample statistics or history are fabricated.
- Camera capture is Phase 3. No camera permissions are requested yet.
- A trained cinnamon detector and validated thresholds are required for accepted capture (Phase 4).
- OpenCV, ArUco, calibration and actual measurements are Phase 5.
- Finishing weights/classes are Phase 6. No predicted labels or scores exist in this build.
- Authentication and synchronization are Phase 7. No credentials are collected, no requests are made, and automatic uploads are off.
- Reports and accuracy validation are Phase 8. Results, sample detail and image/measurement/finishing review screens are deferred until they have real data.
- Sinhala translation and native-speaker review remain outstanding. All app copy is centralized in `lib/app/l10n/app_en.arb`.

## Run

Validated development SDK: Flutter **3.47.5**, Dart **3.13.4**. Android and iOS project scaffolds are included; iOS builds require macOS/Xcode. Android currently uses the generated SDK configuration. Release signing must be configured before distribution.

```sh
flutter pub get
flutter gen-l10n
flutter run -d <android-device-id>
```

No account, API URL or model download is necessary to explore Phase 1. UI preferences use `SharedPreferencesAsync`; this store must never hold samples, passwords or tokens. Samples will use Drift and app-private images in Phase 2.

```sh
dart format lib test integration_test
flutter analyze
flutter test
flutter build apk --debug
flutter test integration_test/app_test.dart -d <android-device-id>
```

The integration test exercises real preference storage and guest navigation; it may complete onboarding on the test device. Run on a test installation. Unit/widget tests use an isolated in-memory preference store and require no network or device. See [Phase 1 validation](docs/PHASE_1_VALIDATION.md) for actual results and environmental limits.

## Architecture and handoff

- [Project structure](docs/PROJECT_STRUCTURE.md) and [file map](docs/FILE_MAP.md)
- [Proposed mobile API contract](docs/API_CONTRACT.md)
- [Dataset and model requirements](docs/DATASET_GUIDE.md)
- [Measurement requirements](docs/MEASUREMENT_GUIDE.md)
- [Offline synchronization plan](docs/OFFLINE_SYNC.md)

Dependency APIs were checked against the publisher documentation for [Riverpod](https://pub.dev/packages/flutter_riverpod), [GoRouter](https://pub.dev/documentation/go_router/latest/go_router/StatefulShellRoute-class.html), [shared preferences](https://pub.dev/packages/shared_preferences) and [Flutter localization](https://docs.flutter.dev/ui/internationalization). `pubspec.lock` records the resolved versions. Only dependencies used by this phase are installed.

Next: **Phase 2 — Drift schema, migrations, transactional sample repository, app-private image storage, real dashboard statistics and local history.** No changes have been committed or pushed.

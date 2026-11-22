# QuillGrade — Smart Cinnamon Grading

An independent Flutter mobile app for inspecting two views of the **same physical cinnamon quill**. End View is for width, actual outer perimeter and area; Side View is for finishing. **Quill length is never measured.**

This repository is the standalone mobile project. Its existing directory name, `cinnamon_mobileapp`, is retained; it serves as the requested `QuillGrade-Mobile/` root. `pubspec.yaml`, `lib/`, `android/`, `ios/`, `assets/`, `test/` and `integration_test/` are directly here. No web dashboard or backend is included or accessed.

## Phase 4 — detection infrastructure, model unavailable

The existing camera now has conditional integration for typed detection states, isolate-based preprocessing, bounding-box mapping, consecutive-frame validation and final-photo revalidation. Production capture remains blocked. No cinnamon dataset could be inspected: the supplied Drive folder returned a sign-in page, and the workspace contains only branding/platform images. **No model has been trained, exported, installed or accuracy-tested.** No native inference runner is installed and no inference stream runs without one. See [Phase 4 status and verification](docs/PHASE_4_DETECTION.md), [dataset audit](docs/DATASET_AUDIT.md) and [annotation/training tooling](ml/cinnamon_detection/README.md).

## Phase 3 — real camera infrastructure

The End/Side camera sandbox uses the real rear camera, runtime permission handling, supported flash/focus controls, lifecycle management and original-quality temporary photographs. Review supports zoom, EXIF orientation, quality warnings, retake and discard. It is available only in debug builds from Capture → End/Side instructions → **Open camera sandbox**. Temporary photographs never become grading samples or sync jobs. Physical-device verification is separate from mocked automated tests; see [Phase 3 camera verification and device instructions](docs/PHASE_3_CAMERA.md).

## Phase 2 — offline persistence

Drift/SQLite now stores samples, private image references, nullable measurement/finishing results, calibrations, local sync jobs, preferences, study notes and model metadata. Home and History read real reactive local data. No production records are seeded. Sample capture still requires a real detector and remains blocked.

History supports code/batch/note search, sync filters, sorting, details, original-photo previews, metadata editing and confirmed local removal. Original photos are retained in private storage after removal. The persistent queue has no network worker. See [Phase 2 storage and verification](docs/PHASE_2_STORAGE.md).

## Existing UI and Study features

Implemented: Material 3 light/dark/system themes, persistent onboarding and appearance preferences, Riverpod state, GoRouter navigation with five retained tab stacks, responsive navigation rail, offline guest workspace, and English localization resources ready for Sinhala translation.

The visual enhancement adds the supplied QuillGrade logo, a centralized orange/green/cream brand system, polished account forms with disabled server submission, a six-step capture overview, grouped settings, and an honest Results layout. Native/Flutter typography is retained for reliable offline rendering; no fonts are downloaded at runtime.

**Cinnamon Quill Guide:** browse all 13 grades in Alba, Continental, Mexican and Hamburg; search names; filter groups; open grade details and related grades; compare two references. Bundled `assets/data/cinnamon_grades.json` supplies the published diameters and verified quills-per-kilogram / foxing figures from the [Department of Cinnamon Development, Table 1.1](https://cinnamon.gov.lk/about-cinnamon/post-harvest-technology/). This reference guide works offline without an account. Diameter alone never assigns a final sample grade.

The original logo at `assets/images/branding/quillgrade_logo.png` is registered and displayed unchanged on white backing, including in dark mode. No grade-specific reference photographs or individual finishing descriptions were supplied; the guide explicitly marks them unavailable. See [UI and Study implementation](docs/UI_STUDY_GUIDE.md) for data ownership, image attribution rules, new/modified files and validation.

Screens: introduction, Home, Capture preparation, End/Side positioning guides, History, Sync, Study catalogue, grade details, grade comparison, Settings, Profile, Login/Register forms, Calibration guidance, Results layout and Reports availability. The vector cinnamon illustrations are decorative, not camera images, training examples or detection results; none are presented as grade-reference photographs.

The app deliberately reports unavailable capabilities:

- SQLite is connected. A fresh workspace shows real zero counts; missing result values remain Not Measured / Not Analyzed.
- Camera permission is requested only when opening the debug camera sandbox. Accepted production capture remains blocked.
- A trained cinnamon detector and validated thresholds are required for accepted capture (Phase 4).
- OpenCV, ArUco, calibration and actual measurements are Phase 5.
- Finishing weights/classes are Phase 6. No predicted labels or scores exist in this build.
- Authentication and synchronization are Phase 7. Account fields hold temporary screen state only; submission is disabled, nothing is persisted or sent, and automatic uploads are off.
- Reports and accuracy validation are Phase 8. The capture Results preview remains blocked; saved-record review is available through History.
- Sinhala translation and native-speaker review remain outstanding. All app copy is centralized in `lib/app/l10n/app_en.arb`.

## Run

Validated development SDK: Flutter **3.47.5**, Dart **3.13.4**. Install Android SDK 37 for compilation; Android devices require API 24 or newer. The iOS target is 15.0; iOS builds require macOS/Xcode. Release signing must be configured before distribution.

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter run -d <android-device-id>
```

No account, API URL or model download is necessary to browse the offline app. Existing theme/onboarding preferences are imported once from `SharedPreferencesAsync` into SQLite; the legacy key is retained as a recovery copy. No passwords or tokens are persisted.

```sh
dart format .
flutter analyze
flutter test
flutter build apk --debug
flutter test integration_test/app_test.dart -d <android-device-id>
```

The integration test exercises native startup and guest navigation; it may complete onboarding on the test device. Run on a test installation. Unit/widget tests use isolated SQLite, temporary images, test-only camera/detector adapters and the real bundled grade JSON. Current verification: **122 Flutter tests and 6 Python tooling tests passed**, with all 93 Phase 1–3 tests retained. Analysis is clean and the Android debug APK builds. See [Phase 4 verification](docs/PHASE_4_DETECTION.md) for results and the Windows formatting-path workaround, [Phase 3](docs/PHASE_3_CAMERA.md) for camera history and [Phase 2](docs/PHASE_2_STORAGE.md) for storage. Automated fixtures do not verify a real cinnamon model or physical camera.

## Architecture and handoff

- [Project structure](docs/PROJECT_STRUCTURE.md) and [file map](docs/FILE_MAP.md)
- [Proposed mobile API contract](docs/API_CONTRACT.md)
- [Dataset and model requirements](docs/DATASET_GUIDE.md)
- [Measurement requirements](docs/MEASUREMENT_GUIDE.md)
- [Offline storage and synchronization](docs/OFFLINE_SYNC.md)

Dependency APIs were checked against the publisher documentation for [Riverpod](https://pub.dev/packages/flutter_riverpod), [GoRouter](https://pub.dev/documentation/go_router/latest/go_router/StatefulShellRoute-class.html), [shared preferences](https://pub.dev/packages/shared_preferences) and [Flutter localization](https://docs.flutter.dev/ui/internationalization). `pubspec.lock` records the resolved versions. Only dependencies used by this phase are installed.

Next: authorize dataset access, audit/annotate real images, train/evaluate a detector and verify an actual exported model/runtime before enabling validated temporary capture. The repository validation gate and later-phase grading requirements remain in force. No Git branches, commits, pushes or merges are changed by this implementation task.

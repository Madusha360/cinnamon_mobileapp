# Premium UI and offline Cinnamon Quill Guide

Implemented in the existing standalone Flutter application on **20 November 2026**. The Phase 1 architecture, five retained navigation branches, guest entry, onboarding completion, preference storage and capture restrictions are preserved. This task does not implement SQLite, inference, measurement, authentication or cloud synchronization. No separate MERN project was accessed, and this task did not commit, push, merge or switch branches.

## Screens and visual system

- Splash and onboarding use the original logo. The four introduction topics explain detection, width/circumference, finishing and future offline saving/sync. Skip and guest entry persist completion; failure remains retryable.
- Login and registration share a branded email/password form with a visibility toggle. Fields have screen-local controllers; no credentials are stored or transmitted. Submission remains disabled. Continue Offline and account navigation work.
- Home has original branding, greeting, explicit local operating mode, Scan Cinnamon action, four unavailable statistics, quick actions and an honest empty activity state. Local mode is not a claim about measured network connectivity.
- Capture presents the exact six-step workflow overview, positioning guides and model requirements. Accepted capture remains disabled. The new Results layout shows no accepted images, Not Measured, Not Analyzed, uncalibrated/unsaved status and disabled saving.
- History has visibly unavailable search/filter controls and “No cinnamon samples yet.” No sample identities, thumbnails or results are invented.
- Sync displays manual mode, unavailable queue counts, no previous synchronization and disabled automatic uploads. No sync engine is included.
- Settings groups Appearance, Language, Camera, Measurement, Data, Account, Model Status and About. Appearance persistence is unchanged. Unimplemented settings are read-only; logout is disabled for the guest workspace.
- Profile uses original branding, guest status, settings and About information. Calibration, Reports, End/Side guidance and other existing screens inherit the updated shared page, card, button, spacing and color styles.
- Study is now a dedicated catalogue with details and comparison. Source numbers are explicitly reference values, not measurements.

Colors are centralized in `app_colors.dart`: orange `#C9540D`, green `#286D32`, forest `#20352A`, cream `#F8F6F0`, white and muted neutral tones. Dark mode has independent dark surfaces and adjusted readable accents. `app_tokens.dart` centralizes dimensions and reduced-motion timing. Existing text styles and Flutter/platform typography (Roboto on Android) are retained for reliable offline rendering; no new font service or dependency is added. Forms, cards, buttons, navigation and status indicators share the existing design system.

## Original logo

The user-supplied `assets/images/branding/quillgrade_logo.png` existed at inspection and is now explicitly registered in `pubspec.yaml`. `BrandLogo` displays it unchanged with `BoxFit.contain`, original proportions/colors, an accessible image label and white backing in both themes. It is used on Splash, Onboarding, Login, Registration, Home, Profile and Settings/About.

SHA-256 before and after implementation:

```text
A2A056C80E75659C648D1A3B3BDF0D79EC54C002B76986509898464DDB1AD2E5
```

The original 139×139 PNG was not recolored, cropped, regenerated, resampled or replaced by a generic icon. Existing platform launcher assets remain unchanged; integration here concerns the requested in-app logo placements.

## Grade data and source

Source: Department of Cinnamon Development, Sri Lanka, [Post Harvest Technology — Table 1.1: Cinnamon Grades](https://cinnamon.gov.lk/about-cinnamon/post-harvest-technology/).

The supplied diameters were checked against the indexed official page on 20 November 2026. The same indexed table supplied the quill counts and foxing percentages below. A direct fetch initially returned 404; the indexed official content was retrievable. The application never depends on loading that website.

| Group | Grade | Reference diameter (mm) | 42-inch quills/kg | Surface foxing (%) |
| --- | --- | ---: | ---: | ---: |
| Alba | Alba | 6 | 45 | 10 |
| Continental | C5 Extra Special | 8 | 33 | 10 |
| Continental | C5 Special | 10 | 30 | 10 |
| Continental | C5 | 12 | 27 | 15 |
| Continental | C4 | 16 | 22 | 15 |
| Continental | C3 | 18 | 20 | 20 |
| Mexican | M5 Special | 16 | 22 | 60 |
| Mexican | M5 | 18 | 20 | 60 |
| Mexican | M4 | 21 | 15 | 60 |
| Hamburg | H1 | 23 | 10 | 25 |
| Hamburg | H2 Special | 25 | 9 | 40 |
| Hamburg | H2 | 32 | 7 | 55 |
| Hamburg | H3 | 38 | 6 | 65 |

The official page groups Alba/C as Heen Kurundu (smooth cinnamon), and M/H as Gorosu Kurundu (coarse cinnamon). The UI identifies this as a **group-level type**, not an individual grade's finishing description. The quill-count column retains its source basis of 42-inch reference quills. The app does not calculate length. Foxing values are labeled as published percentages without inventing an unverified minimum/maximum interpretation or additional certification criteria.

Diameter alone never determines a final grade or ranks a physical sample. Appearance and finishing descriptions for individual grades remain null because verified descriptions were not supplied. Group descriptions summarize only the group members and reference diameter range.

## Offline schema and ownership

`assets/data/cinnamon_grades.json` has:

- `schemaVersion`: currently 1.
- `source`: title, HTTPS URL and checked-at date shared by all entries.
- `groups`: stable group ID, display name, neutral description and verified group-level type name.
- `grades`: stable ID, name, group, `referenceDiameterMm`, description, nullable appearance/finishing/image/attribution, `quillsPerKg` and `foxingPercent`.

The data source loads through an injectable Flutter `AssetBundle`. A reusable repository supplies the typed catalogue to Riverpod. Models validate schema version, duplicate identities, group membership, finite positive diameters, positive quill counts, percentage bounds and reference-image paths/attribution. Catalogue collections are unmodifiable. Unsupported/malformed data surfaces a retryable loading error.

Filtering combines the selected group with case-insensitive name terms, normalizing whitespace and hyphens. Filter state is retained across shell tab changes and detail navigation. No internet, login, Firebase, database or backend is involved.

Routes are `/study`, `/study/grades/:gradeId` and `/study/compare`. Unknown grade IDs offer a return to the catalogue. Details show group, diameter, photograph availability, appearance/finishing availability, published criteria, source, related grades and back navigation. Related entries come from the same group; Alba uses the next three catalogue entries because it has no peer in its own group. These suggestions are not quality rankings.

Comparison defaults to Alba/C5 Special. A detail page can pass its grade through the optional `first` query parameter. Both selectors use the real catalogue; choosing the same grade is allowed with guidance to choose different entries. Cards compare group, published diameter, verified finishing if present and the source criteria. Cards sit side by side when width/text scale allows and stack on small screens. Names wrap instead of forcing horizontal scrolling. No sample grading or model prediction occurs.

## Reference photographs

No verified grade-specific photographs were provided. Every `imageAsset`, `imageAttribution`, individual `appearance` and `finishingCharacteristics` value is currently null. Cards and detail pages use neutral unavailable states. Decorative quill drawings are never assigned as grade evidence.

To add a photograph later:

1. Verify the actual grade, permission/license and attribution with the image owner or authorized source.
2. Place the original authorized asset under `assets/images/study/alba/`, `continental/`, `mexican/` or `hamburg/` as appropriate; create only needed directories.
3. Register its path or directory in `pubspec.yaml`.
4. Set `imageAsset` and a non-empty `imageAttribution` in the correct JSON entry. Record any new descriptive evidence and its provenance before populating appearance or finishing.
5. Run asset, catalogue and widget checks. A missing/corrupt asset must display the honest unavailable state rather than substituting an unrelated photo.

## Files created

```text
assets/data/cinnamon_grades.json
lib/app/theme/app_tokens.dart
lib/core/widgets/brand_logo.dart
lib/core/widgets/status_indicator.dart
lib/features/auth/presentation/widgets/account_form.dart
lib/features/results/presentation/pages/results_page.dart
lib/features/study/domain/cinnamon_grade.dart
lib/features/study/data/cinnamon_grade_data_source.dart
lib/features/study/data/cinnamon_grade_repository.dart
lib/features/study/presentation/providers/study_provider.dart
lib/features/study/presentation/pages/grade_detail_page.dart
lib/features/study/presentation/pages/grade_comparison_page.dart
lib/features/study/presentation/widgets/cinnamon_grade_card.dart
lib/features/study/presentation/widgets/grade_category_filter.dart
lib/features/study/presentation/widgets/grade_size_badge.dart
lib/features/study/presentation/widgets/grade_comparison_card.dart
lib/features/study/presentation/widgets/reference_image_card.dart
test/study/cinnamon_grade_repository_test.dart
test/widgets/study_guide_test.dart
docs/UI_STUDY_GUIDE.md
```

The existing original logo was registered, not recreated. Flutter-generated localization classes and ignored build/previews are produced by tools, not hand-edited.

## Files modified

`pubspec.yaml`; `lib/app/l10n/app_en.arb`; `app_router.dart` and `route_names.dart`; `app_colors.dart` and `app_theme.dart`; `app_page.dart` and `status_card.dart`; `main_navigation_shell.dart`; the existing Splash, Onboarding, Login, Register, Home, Capture, History, Sync, Study, Settings and Profile pages; `stats_card.dart` and `capture_stepper.dart`; `test/support/test_app.dart`, `app_navigation_test.dart`, `appearance_test.dart`; `README.md`, `docs/FILE_MAP.md` and `docs/PROJECT_STRUCTURE.md`. See the [file map](FILE_MAP.md) for full feature paths. Main bootstrap, preference implementation and platform build configuration are preserved.

## Validation

The original **17 test cases remain**. Visible-copy assertions were updated for the requested Study subtitle and fourth dashboard statistic; the auth regression now verifies disabled submission of the requested input forms rather than asserting that no inputs exist. No capture gate, persistence or guest test was removed.

Added **16 tests**: six catalogue/data cases and ten widget cases. They cover all 13 official values, quill-count/foxing references, missing evidence, malformed data, group/name filtering, catalogue navigation, no-match recovery, grade details/back, unknown IDs, changing comparison selections, deep-link comparison initialization, original logo decoding/white backing, password visibility and small-screen keyboard reachability. Existing layout tests include Results, grade detail and comparison at 320 px / 200% text scale. Tablet and light/dark tap-target checks remain.

Widget tests preload the real bundled JSON outside the fake widget clock, then run the actual data source, repository, parser and providers against an injected bundle transport. Repository tests load the actual app asset directly. No sample data or cloud service is mocked into the product.

| Command | Actual result |
| --- | --- |
| `flutter pub get` | Passed; original dependency set retained |
| `flutter gen-l10n` | Passed; generated localization refreshed |
| `dart format .` | Passed; 63 Dart files processed |
| `flutter analyze` | No issues found |
| `flutter test` | 33 tests passed |
| `flutter test --dart-define=EXPORT_PREVIEWS=true --dart-define=PREVIEW_FONT_DIR=C:/flutter/flutter/bin/cache/artifacts/material_fonts` | Final 33-test run passed; 18 PNG previews exported |
| `flutter build apk --debug` | Android debug APK built successfully |
| `dart format --output=none --set-exit-if-changed .` | 63 files checked, 0 changes |
| `flutter devices` | Windows and browser targets only; no Android device connected |
| `git diff --check` | No whitespace errors reported |
| SHA-256 of original logo | Matches the initial file exactly |

Preview exports are in ignored `build/ui-study-previews/`: Home, onboarding, Capture, Study, Alba detail, comparison, Login, Settings and Results in light/dark themes. Home, Study, detail, comparison and Login previews were visually inspected, and the logo decode wait was verified. These are Flutter widget renders, not physical-device screenshots.

## Limits and Phase 2 readiness

- Study references are complete for the requested 13 grades; factual grade-specific photographs and finishing/appearance descriptions remain unavailable until provided/verified.
- Sinhala translation is still pending. New UI strings use the existing English localization catalogue.
- No physical-device or iOS runtime validation is claimed: the final device check found no Android device. The existing device integration test was not run. iOS building requires macOS/Xcode. The Android APK uses debug signing.
- Capture, real measurements, inference, saving, server authentication and synchronization remain unavailable. History search/filter controls and automatic sync settings are visibly disabled.
- The existing standalone feature-first architecture is ready for **Phase 2: Drift/SQLite, sample ownership, private image storage, transactional save/recovery, real statistics and history**. This task did not begin that phase or introduce a temporary sample database.

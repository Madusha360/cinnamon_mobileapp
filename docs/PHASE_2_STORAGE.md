# Phase 2 — SQLite and offline data storage

Implemented in the existing QuillGrade Flutter workspace. No web project, Git branch, commit or push is part of this work. Existing branding, five tabs, account/guest screens, themes, capture restrictions and all 13 reference grades are retained.

## Storage and data integrity

The production database is `getApplicationSupportDirectory()/quillgrade/quillgrade.sqlite`, opened through a background native Drift connection. SQLite is bundled through sqlite3 native assets. The image root is the sibling `originals/` directory, not temporary storage or a public gallery.

| Table | Stored data and relationships |
| --- | --- |
| `samples` | UUID, unique case-insensitive code, optional batch/notes, captured/updated dates, detection/calibration/sync status, revision, deletion tombstone |
| `sample_images` | UUID, sample FK, unique End/Side pair, unique relative private path, original byte count, detector FK and validation timestamp |
| `measurements` | UUID, unique sample FK, nullable max/min width, equivalent diameter and actual outer circumference in mm, calibration FK, algorithm version and timestamp |
| `finishing_results` | UUID, unique sample FK, nullable quality/confidence, model FK and analysis timestamp |
| `calibrations` | UUID, positive marker size and pixels/mm, method and timestamp |
| `sync_jobs` | UUID, unique sample FK, status, revision, unique idempotency key, attempts, dates, error and next eligible retry |
| `user_preferences` | UUID, unique key, JSON value and timestamp; used by persisted appearance/onboarding |
| `study_notes` | UUID, unique reference grade identity, note and timestamp; schema foundation |
| `model_metadata` | UUID, unique kind/version, optional private file/hash, installation flag and timestamp; schema foundation |

Foreign keys are enabled and checked on every opening. Positive dimensions, confidence bounds, legal statuses and uniqueness are enforced. No cinnamon length is stored or calculated. No measurement/classification results or production sample records are generated.

Schema version 2 upgrades the saved version 1 baseline by adding nullable queue error/retry fields and query indexes without recreating data. Both schemas and generated verification helpers are under `test/database/`. Version 1 is this phase's development baseline, not a claim that Phase 1 shipped a sample database. A future schema change must add a migration and export a new immutable snapshot.

## Offline behavior

- Transactional create/read/update/remove, all/recent queries, literal code/batch/note search, sync-status filters, date/code sorting and result persistence.
- Reactive Home totals, pending/synced counts, seven-day recent count and five most recent samples; genuine zero counts on a new installation.
- Existing History connected to SQLite, including saved details, two original photos, nullable results, metadata editing, sync status and delete confirmation.
- Original bytes preserved using staged pair copies and UUID paths. Failed writes cannot commit half a sample. Missing/unreadable image references display an accessible fallback.
- Confirmed deletion hides the record and removes queued work transactionally. Archived rows and originals remain private; no cloud deletion is implied.
- Persistent local queue with five statuses, revision/attempt guards, stable retry identity, exponential backoff, conflict state and interrupted-upload recovery. No network requests or background upload worker.
- Existing appearance/onboarding imported once into SQLite, without clearing the old recovery key. Offline guest entry and bundled Study remain independent of a cloud account.

## Capture safety

The production repository uses `UnavailableCaptureValidationGate`; it rejects sample creation even if a metadata row says a model is installed. No UI path injects a permissive gate. Only `test/support/storage_fixture.dart` supplies a test gate, temporary photos and isolated metadata/calibration/result values. Camera and detector implementation must eventually validate the actual private image bytes and the same physical quill before production grading is enabled.

## File inventory

Created: `lib/core/database/{app_database.dart,app_database.g.dart,database_provider.dart,tables.dart}`; `lib/core/storage/{image_storage_service.dart,sqlite_preferences_store.dart}`; `lib/features/samples/{domain/sample.dart,data/local_sample_repository.dart,presentation/providers/sample_providers.dart,presentation/widgets/sample_card.dart}`; `lib/features/history/presentation/pages/sample_detail_page.dart`; `lib/features/sync/data/local_sync_queue.dart`; `test/support/storage_fixture.dart`; `test/database/{local_sample_repository_test.dart,migration_test.dart,schemas/*,generated/*}`; `test/storage/image_storage_test.dart`; `test/settings/sqlite_preferences_test.dart`; `test/sync/local_sync_queue_test.dart`; `test/widgets/offline_library_test.dart`; this document.

Modified for Phase 2: `pubspec.yaml`, `pubspec.lock`, router/route names, English ARB, Home and its statistic/recent widgets, History, Sync, Settings preference provider, widget harness, existing Home-zero assertion, `README.md`, `docs/FILE_MAP.md`, `docs/PROJECT_STRUCTURE.md`, `docs/OFFLINE_SYNC.md`. Localization output is generated; it is not hand-edited. The shared formatter may normalize layout in existing files. See `FILE_MAP.md` for complete ownership.

## Verification

Verified with Flutter 3.47.5 / Dart 3.13.4 on this Windows development host:

| Command | Actual result |
| --- | --- |
| `flutter pub get` | Passed; lockfile resolved |
| `dart run build_runner build --delete-conflicting-outputs` | Passed; Drift code regenerated. This build_runner version reports the legacy flag as ignored. |
| `dart format .` | Passed across 85 Dart files |
| `flutter analyze` | Passed — no issues found |
| `flutter test` | **60 passed**: 33 existing scenarios retained, 27 added |
| `flutter build apk --debug` | Passed; `build/app/outputs/flutter-apk/app-debug.apk` |
| `flutter devices` | Windows, Chrome and Edge only; no Android device available |

The APK is 238,805,894 bytes and includes `libsqlite3.so` for `armeabi-v7a`, `arm64-v8a` and `x86_64`. Its SHA-256 is `006B58E95A1BAC5AE50750D291B66E5E3707BFE8F2E5111CE76B7F9259ADCF60`. Native SQLite is packaged in the artifact; the app does not download it at runtime.

The full test transcript is `build/phase2-all-tests.log`. New tests cover initialization, UUID identity and nullable results, CRUD/tombstones, unique constraints, foreign keys, transaction rollback, original bytes and filesystem failures, saved-schema migration, reopened file databases, interrupted upload recovery, legacy preference import, rolling statistics, queue transitions/stale receipts, History retry/search/filter/sort, Home reactivity, detail edits/delete confirmation, missing photos and large-text layouts. The added suite found and fixed a confirmation-dialog overflow at 320px / 2× text scale.

The original logo still has SHA-256 `A2A056C80E75659C648D1A3B3BDF0D79EC54C002B76986509898464DDB1AD2E5`. Drift emits a debug warning when a test creates several independent database instances; their executors and storage are isolated, while production uses one app-scoped database. The Gradle build succeeded with a JVM native-access warning.

Tests exercise real SQLite and filesystem operations, not an in-memory map substitute. File-backed databases are closed and reopened to verify persistence and recovery. Widget tests use in-memory SQLite with synchronous stream cleanup so fake-clock teardown does not leave deferred cache timers. Existing test scenarios remain; Home now expects real zero counts.

## Limitations and next phase

No device reboot or power-loss durability claim is made from host tests. Physical Android restart/offline checks require a test device; iOS builds require macOS. Clearing app data or uninstalling can remove local records. Backup/export, permanent erasure and orphan/staging cleanup after process termination are not implemented; originals are retained conservatively.

Study notes, calibration and model metadata have real tables but no new editing/install UI. The reference catalogue remains bundled. A database migration is tested from the saved development baseline; no historical production database existed before this phase. History currently loads matching records together; pagination is a future performance improvement for large libraries.

Cloud/auth/network integration, remote delete semantics, conflict-resolution UI, camera capture, detection, measurement engines, finishing inference, reports and Sinhala translation remain later work. Stored fixture results validate persistence only, not measurement accuracy or grading quality.

Next: Phase 3 real camera acquisition, permissions and private capture lifecycle. Keep grading blocked until trained detection is available and verified. Phase 7 will supply the real transport under the existing API contract.

Implementation references: [Drift native setup](https://drift.simonbinder.eu/platforms/vm/), [migration verification](https://drift.simonbinder.eu/migrations/tests/) and [table constraints](https://drift.simonbinder.eu/dart_api/tables/).

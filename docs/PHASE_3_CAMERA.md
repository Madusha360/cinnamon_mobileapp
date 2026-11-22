# Phase 3 — real camera infrastructure

Implemented in the existing standalone QuillGrade Flutter application. The five-tab UI, Study catalogue, original logo, SQLite schema/repositories, guest access and persistent preferences remain in place. No MERN, cloud transport, detector, finishing model or OpenCV measurement code is added.

## Packages and platforms

- [`camera` 0.12.2](https://pub.dev/packages/camera): maintained Flutter camera plugin, endorsed CameraX on Android and AVFoundation on iOS. The adapter selects a rear camera and requests `ResolutionPreset.max`; actual resolution and supported controls depend on hardware. Audio is disabled.
- [`permission_handler` 13.0.2](https://pub.dev/packages/permission_handler): camera permission status/request and application-settings link. Denied, permanently denied and restricted states have separate UI copy.
- [`image` 4.13.1](https://pub.dev/packages/image): offline decoding, EXIF-aware preview and quality heuristics in a background isolate. `pubspec.lock` pins all resolved packages.

Android minimum SDK is 24; compilation uses SDK 37 or higher as required by the resolved permission plugin. `AndroidManifest.xml` declares CAMERA and optional camera/autofocus features so devices without a rear camera can still use the rest of the app. The manifest explicitly removes inherited RECORD_AUDIO, READ_EXTERNAL_STORAGE and WRITE_EXTERNAL_STORAGE permissions. No gallery, storage, location or microphone access is requested. Flutter's debug manifest includes INTERNET for development tooling; Android dependencies also add normal network-state and internal receiver permissions. The camera module has no networking.

`ios/Runner/Info.plist` contains `NSCameraUsageDescription`. The existing iOS deployment target is 15.0 and the project uses Swift Package Manager. The permission handler's SPM integration enables camera from the usage description. Build with Flutter on macOS; if building directly from Xcode, follow the package's `PERMISSION_HANDLER_INFO_PLIST` configuration instructions. iOS compilation and native permission behavior have not been verified in this Windows workspace.

## Capture and review

Run a **debug** build, enter the offline guest workspace and open Capture → End View or Side View → **Open camera sandbox**. This is an explicitly labeled engineering workspace. Camera permission is requested upon entering it, never at normal startup.

End View displays a circular guide and marker-placement guide. Instructions require a **20 mm ArUco marker in the same physical plane as the quill end-face**. Side View displays a horizontal guide and asks for the visible surface of the **same quill**. These guides only help positioning; they do not detect the subject or marker. No width, circumference, grade or length is calculated.

The native preview supports available flash and tap-to-focus controls. The adapter locks the current capture orientation for the still photograph, then unlocks it. Capture records camera name, sensor orientation, device orientation, UTC time, flash mode and exposure mode when exposed by the plugin. Unsupported controls do not prevent capture. Unavailable/busy cameras, denied permission, initialization errors, failed photos and failed storage have recovery states.

After capture, the camera closes and the original photo moves to the dedicated temporary cache. Review displays an oriented inspection preview, original encoded dimensions and quality warnings. Pinch zoom supports 1–5× inspection. Retake deletes that view's temporary photo; discard removes it and returns to Capture. The other view remains in the same UUID session. **Discard both views** removes the entire session. Saving a sample is always disabled.

The Riverpod controller serializes camera operations and rejects late results after navigation, backgrounding or disposal. Camera-route visibility is tracked separately from widget mounting, because a nested review route can cover a still-mounted camera page. The camera closes while covered/backgrounded and reopens only when its own route is active. There is no streaming while idle or reviewing.

## Temporary storage and promotion boundary

The existing `ImageStorageService` owns both storage areas:

| Area | Location and policy |
| --- | --- |
| Native camera output | Android application cache; iOS application `tmp/camera`. Only files resolving inside the allowed private directories can be adopted or deleted. |
| Unvalidated sandbox | `<application cache>/quillgrade/capture_sandbox/<session UUID>/{end,side}.original.jpg`. Native output is renamed here, preserving bytes/EXIF and avoiding a duplicate. Existing photos cannot be silently overwritten. |
| Validated originals | Existing `<application support>/quillgrade/originals/<sample UUID>/…` managed by the Phase 2 repository. Sandbox sources are explicitly rejected. |

Retake/discard deletes only identified sandbox files. Starting a new session after application restart cleans abandoned UUID directories in the dedicated sandbox, while preserving unrelated cache files and all permanent originals. Cleanup errors are recoverable. Temporary review state is intentionally in memory; the OS may purge cache files, and abandoned sessions are not restored after restart. These engineering photos are not durable production data. A force-stop between the native shutter and file adoption can leave a plugin-owned cache file for the OS to reclaim; cleanup never sweeps unrelated cache files.

No SQLite schema change is needed. Capture has no sample-repository or sync-queue dependency. Both the entry UI and controller require `kDebugMode`; profile/release builds cannot use the sandbox, including through direct route navigation. Quality reports always have `validatesCinnamon == false`; temporary photos always have `productionEligible == false`. The model warning reads **Cinnamon Detection Model Not Installed**.

Future validated promotion must use `LocalSampleRepository.createSample`: a real `CaptureValidationGate` must validate both original files and return evidence for installed detector metadata; `saveOriginals` stages unchanged copies; one database transaction creates the sample, both image references and local queue job; failures compensate the uncommitted permanent copies. Only after a successful commit may a future production workflow remove its owned temporary originals. The current debug sandbox must remain ineligible even when a detector is later installed. There is no public bypass, promotion switch or copy-to-library action in this phase.

## Offline quality checks

Checks run after the shutter, off the UI isolate. They are preliminary capture warnings, **not cinnamon identity, accepted grading evidence or accuracy claims**. Originals are never decoded/re-encoded in place. JPEG EXIF orientation is read and applied to the in-memory review preview; encoded dimensions and original orientation remain available for future measurement.

| Check | Current implementation |
| --- | --- |
| Invalid image | Missing/empty file, decoder failure, invalid dimensions, file over 40 MiB or decoded dimensions over 50 million pixels are rejected for inspection. |
| Resolution | Warning if the shorter encoded edge is below 720 pixels or total resolution is below 1 megapixel. |
| Darkness | Mean weighted RGB luminance below 40 on a 0–255 scale. |
| Severe overexposure | More than 60% of inspected pixels have luminance at least 245. |
| Blur | Variance of a Laplacian filter below 75 within the central half of the image. |

The analysis image is reduced to a maximum 512-pixel edge; the separate review preview is at most 2048 pixels on its longest edge. Large JPEGs use scaled decoding to limit memory. Review zoom therefore inspects this bounded preview; it is not a full-resolution pixel viewer. The original file remains available unchanged. Blur depends on subject texture, contrast, noise, framing and camera processing; the central region can still include background. A sharp unrelated object can produce no quality warnings and remains unvalidated. Thresholds need representative physical-device evaluation before becoming production acceptance rules.

## Phase 4 / Phase 5 integration

`CaptureFrameProcessor` accepts image planes, strides, format, dimensions, sensor/device orientation, timestamp and requested view. `FrameReadiness` can represent model availability, correct view, rejection, detected regions and real confidence values. Its default state is unavailable, and the provider is null: no stream, boxes or inference run now. The adapter offers an explicit image stream with a 150 ms minimum interval, a single in-flight processor and generation checks that discard obsolete callbacks. Stop the stream before still capture. Real inference performance, frame formats and confidence calibration remain Phase 4 work.

Phase 4 must bring a validated model, verified labels, model metadata/version, preprocessing, correct-view checks, rejection policy and a repository validation-gate implementation. Stream readiness alone must never authorize saving. Sandbox data must never be relabeled as accepted evidence. Phase 5 can consume untouched high-resolution originals, encoded dimensions, EXIF and camera orientation metadata for OpenCV/ArUco calibration. Neither phase is implemented here.

## Verification

Verified on 21 November 2026 using Flutter 3.47.5 / Dart 3.13.4 on Windows:

| Check | Actual result |
| --- | --- |
| `flutter pub get` | Passed; dependency lockfile resolved. |
| `dart format .` | Passed; 99 Dart files checked, zero changes on the final run. |
| `flutter analyze` | Passed: **No issues found**. Log: `build/phase3-analysis.log`. |
| `flutter test` | Passed: **93 tests**, comprising all 60 prior tests plus 33 Phase 3 tests. Log: `build/phase3-all-tests.log`. |
| `flutter build apk --debug` | Passed, exit code 0; final Gradle assemble took 20.7 seconds. Log: `build/phase3-apk-build.log`. |
| APK manifest inspection with `aapt2` | Compile SDK 37, target 36, minimum 24; camera/autofocus features optional. CAMERA present; RECORD_AUDIO and both external-storage permissions absent. |
| `flutter devices` | Only Windows, Chrome and Edge detected. No Android device available. Log: `build/phase3-devices.log`. |
| Original logo SHA-256 | Unchanged: `A2A056C80E75659C648D1A3B3BDF0D79EC54C002B76986509898464DDB1AD2E5`. |

Artifact: `build/app/outputs/flutter-apk/app-debug.apk`, 242,674,145 bytes, containing ARMv7, ARM64 and x86-64 native libraries. SHA-256: `94E5AAFCD62E2A4EFA2894CD9260D768F2C16DC179B6BAE1859F1018C0CD93DE`.

Automated camera tests use mocks; filesystem, SQLite isolation and quality tests use real temporary files/decoded image fixtures. Tests cover permissions, unavailable/busy cameras, native-adapter controls, lifecycle/navigation races, late disposal, two-view sessions, duplicate-capture prevention, EXIF orientation, quality warnings, actual cleanup, sandbox promotion rejection, unchanged sample/queue counts, review/retake/discard and responsive layouts. They do not constitute physical camera testing. Existing navigation, Study, preferences, database, migration, History/Home and sync tests all remain passing.

The Android build emits host-toolchain Java native-access/SDK XML warnings; these do not prevent the successful build. The test harness can print Drift's multiple-database warning while exercising separate isolated databases; all assertions pass. Release/profile native behavior and iOS builds have not been executed. No Git branches, commits or pushes were changed by this task.

## Physical-device procedure — not yet completed

Use a test installation on a real Android device, with USB debugging enabled. Connect it, run `flutter devices`, then `flutter run -d <device-id>`. Alternatively install `build/app/outputs/flutter-apk/app-debug.apk`. No account or server is needed.

1. Enter as guest and confirm Home, all five tabs, Study's 13 grades, comparison and persisted theme work. Enable airplane mode and repeat the camera workflow.
2. Open each End/Side instruction page and its sandbox. Deny the first permission prompt; verify the explanation and retry. Deny permanently, open application settings, grant camera access and return. Test a restricted/device-policy case if available. Confirm no microphone/gallery permission prompt.
3. Inspect the actual rear preview in portrait and both landscape orientations. Check overlay alignment and tap-to-focus near several positions. Test flash on/off on supported hardware and graceful behavior without flash/focus support. Record device, OS and rear-camera characteristics.
4. Place the 20 mm marker at the end-face plane and capture End View. Review orientation, zoom and dimensions. Capture Side View of the same quill. Confirm the other view remains available; test per-view retake/discard and discard-both. Check originals are unchanged if inspecting the debug app's private cache through Android Studio.
5. Capture sharp, deliberately blurred, dark and strongly overexposed scenes. Record observed warning behavior and representative failures; passing these heuristics never proves cinnamon identity. Try an unrelated object and confirm it cannot be saved, graded or synced.
6. Background/resume during preview, permission handling and a shutter operation. Cover the camera with Review; switch views and leave/re-enter the camera. Interrupt with another camera application or unavailable camera where reproducible. Verify no hidden camera usage, stale capture or unrecoverable loading state.
7. Verify original-byte retention, cleanup after retake/discard/new-session restart and storage-error recovery on a controlled low-space test device. Verify permanent library images remain intact. Do not fill a personal device solely to run this test.
8. Compare History, Home counts and sync jobs before/after sandbox use: none may change. Restart the app/phone and confirm existing SQLite data/preferences remain available; temporary reviews need not survive.
9. Build a separate release/profile test artifact on a configured device. Verify no sandbox entry and no deep-route/controller bypass. Keep release signing separate from this debug deliverable.

Native Android camera operation, native iOS camera operation and iOS compilation remain **unverified** until executed on suitable hardware/toolchains. The existing integration test only covers app navigation; it does not physically test the camera.

## File inventory

Created for Phase 3:

- `lib/features/capture/data/{camera_service,image_quality_service}.dart`
- `lib/features/capture/domain/{capture_session,frame_processor}.dart`
- `lib/features/capture/presentation/providers/capture_provider.dart`
- `lib/features/capture/presentation/widgets/{camera_capture_view,camera_overlay}.dart`
- `lib/features/capture/presentation/pages/image_review_page.dart`
- `test/capture/{camera_service_test,capture_controller_test,image_quality_test,temporary_capture_storage_test}.dart`
- `test/support/camera_fixture.dart`, `test/widgets/camera_capture_test.dart`
- `docs/PHASE_3_CAMERA.md`

Modified for Phase 3:

- `pubspec.yaml`, `pubspec.lock`
- `android/app/src/main/AndroidManifest.xml`, `android/app/build.gradle.kts`, `ios/Runner/Info.plist`
- `lib/app/router/{app_router,route_names}.dart`, `lib/app/l10n/app_en.arb`
- `lib/core/storage/image_storage_service.dart`
- `lib/features/capture/presentation/pages/{end_capture_page,side_capture_page}.dart`
- `lib/features/capture/presentation/widgets/capture_instructions.dart`
- `test/support/{storage_fixture,test_app}.dart`
- `README.md`, `docs/FILE_MAP.md`, `docs/PROJECT_STRUCTURE.md`

Generated localization/build outputs are refreshed by Flutter and remain ignored. Existing database tables, migration history, sample and sync repositories, Study references and original logo are unchanged.

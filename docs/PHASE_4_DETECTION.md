# Phase 4 — model-independent detection infrastructure

Status as of 22 November 2026: **architecture implemented; no model trained, exported, installed or validated**. The local dataset search found only 24 branding/platform PNGs. The user-supplied Drive folder returned a sign-in page and remains unaudited. See [DATASET_AUDIT.md](DATASET_AUDIT.md). Work follows the requested inaccessible-dataset fallback.

## Implemented and connected

- Reuses the existing rear-camera adapter and frame stream; no duplicate camera service.
- Adds typed SEARCHING, VALID, INVALID, WRONG_VIEW, BLURRY, UNCERTAIN and MODEL_UNAVAILABLE results, status cards and normalized detection overlays. Green/red/amber/neutral tones follow existing UI components. Actual shipped state is unavailable, with no boxes or invented confidence.
- Adds model manifest/hash checking, explicit float32 tensor contracts and a native-runner interface. There is no installed native runner. No image stream starts unless a compatible detector and evaluated policy are available.
- Adds isolate-based BGRA/YUV conversion, rotation, letterbox preprocessing and inverse box mapping. Reuses Phase 3's actual quality analysis with explicit detection-policy thresholds.
- Adds single-inference backpressure, stable-frame count/time/overlap checks, stale-result expiry, lifecycle invalidation and independent final-photo revalidation APIs.
- Preserves the debug-only camera sandbox and all production restrictions. Detection results never create SQLite samples, permanent originals or sync jobs. The schema and sample/queue repositories are unchanged.
- Adds local dataset inventory, pending annotation templates, reviewed-box validation, identity/session/background/duplicate grouped splits, preparation, explicit training wrapper, real-export inspection and recorded-prediction evaluation scripts. No scripts train, download weights or invent annotations automatically.

## Milestone distinction

| Milestone | Status |
| --- | --- |
| Detection architecture and test fixtures | Implemented |
| Actual dataset content/annotation audit | Blocked by access; local inventory and missing-input audit completed |
| Model training | Not performed |
| Model export | Not performed |
| Native inference package/runner integration | Deferred until a real compatible artifact can be verified |
| Real camera inference | Not available; stream stays off without a model |
| Real cinnamon-only detection validation | Not performed |
| Production capture / grading | Blocked |

The proposed classes are `cinnamon_quill_end`, `cinnamon_quill_side`, `non_cinnamon` (non-target quill category). Actual dataset classes are unknown. Precision, recall, false acceptance, false rejection, confusion matrix, background performance, model size and device latency are **not measured**. Synthetic unit-test scores are never evaluation results.

## Verification

Verified on 22 November 2026 using Flutter 3.47.5 / Dart 3.13.4 on Windows:

| Check | Actual result |
| --- | --- |
| `flutter pub get` | Passed; `crypto` 3.0.8 is now a direct dependency for model-byte integrity. No native ML runtime added. |
| Formatting | `dart format .` hit Windows path-length traversal of generated Gradle files. The equivalent full-project command using the `\\?\` extended path passed: **117 files, zero changes** on the final run. Application/test directories were also formatted directly. |
| `flutter analyze` | **No issues found**. Log: `build/phase4-analysis.log`. |
| `flutter test` | **122 passed**: all 93 existing tests plus 29 Phase 4 tests. Log: `build/phase4-all-tests.log`. |
| Python dataset tools | **6 tests passed**, using real isolated Pillow-generated image files and fixture predictions. Log: `build/phase4-python-tests.log`. Python 3.14 / Pillow 13.0.0; these are tooling tests, not model evaluation. |
| Workspace image audit | 24 PNGs decoded, no image errors; all branding/platform resources. Report: `build/phase4-final-dataset-audit.json`. |
| `flutter build apk --debug` | **Passed, exit 0**, Gradle assemble 43.0 seconds. Log: `build/phase4-apk-build.log`. |
| Packaged APK inspection | No `.tflite`, `.onnx` or `.pt` model assets; CAMERA retained; microphone and external-storage permissions absent. |
| Hardware verification | `flutter devices` found Windows, Chrome and Edge only. No Android device connected; no native model/device test performed. Log: `build/phase4-devices.log`. |
| Original logo | Unchanged SHA-256: `A2A056C80E75659C648D1A3B3BDF0D79EC54C002B76986509898464DDB1AD2E5`. |

APK: `build/app/outputs/flutter-apk/app-debug.apk`, **242,720,100 bytes**. SHA-256: `E1DD7DB0A1C58F755E93F96536D681EBB410EF266BAF6CDFC45B33B6348AE491`.

The debug build emits host Java native-access warnings but completes successfully. Existing Drift tests may print the known multiple-isolated-database warning; all assertions pass. Automated tests cover valid/negative/uncertain/wrong-view/blur/unavailable states, multiple objects, timestamp/stability/expiry, backpressure, stale lifecycle results, final-photo revalidation, existing production restrictions, real pixel conversion/EXIF preservation, bounding-box mapping, model contract rejection, UI status semantics and all previous app features. Mocks do not verify recognition or physical hardware.

## Files

Created under `lib/features/cinnamon_detection/`:

- `domain/cinnamon_detector.dart`, `detection_result.dart`, `detection_status.dart`, `detection_policy.dart`
- `data/model_loader.dart`, `tflite_cinnamon_detector.dart`, `image_preprocessor.dart`, `image_quality_validator.dart`, `detection_coordinator.dart`
- `presentation/providers/detection_provider.dart`
- `presentation/widgets/detection_overlay.dart`, `detection_status_card.dart`

Created test/tooling/documentation files:

- `test/detection/detection_policy_test.dart`, `detection_coordinator_test.dart`, `model_contract_test.dart`, `image_preprocessor_test.dart`
- `test/widgets/detection_status_test.dart`, `test/support/detection_fixture.dart`
- `ml/cinnamon_detection/scripts/dataset_tools.py`, `train_model.py`, `inspect_export.py`, `evaluate_predictions.py`
- `ml/cinnamon_detection/tests/test_dataset_tools.py`, `ml/cinnamon_detection/README.md`
- `docs/DATASET_AUDIT.md`, `ANNOTATION_GUIDE.md`, `AI_MODEL_GUIDE.md`, `PHASE_4_DETECTION.md`

Modified: `pubspec.yaml`/lock (direct SHA-256 dependency), `.gitignore`, localized copy in `lib/app/l10n/app_en.arb`, Phase 3 `image_quality_service.dart`, `capture_session.dart`, `frame_processor.dart`, `capture_provider.dart`, `camera_capture_view.dart`, the widget test harness, README, FILE_MAP, PROJECT_STRUCTURE and dataset-prerequisite documentation. Generated localization remains ignored. No original logo, Study catalogue, web project or Git history mutation.

## Remaining dependencies and device procedure

1. Authorize the provided Drive source or provide a local dataset copy. Audit image/annotation quality and provenance; follow [ANNOTATION_GUIDE.md](ANNOTATION_GUIDE.md).
2. Review grouped splits, hard negatives, unseen physical samples/surfaces, phones and lighting. Train/evaluate an actual lightweight detector and record experiment environments. Follow [the ML guide](../ml/cinnamon_detection/README.md).
3. Export on a supported host, inspect actual tensors, compare source/exported predictions and evaluate quantization separately. Select a native runtime and implement its off-thread runner only after compatibility checks. Follow [AI_MODEL_GUIDE.md](AI_MODEL_GUIDE.md).
4. Calibrate confidence, quality, visibility, stability and freshness policy on validation images/sequences; freeze before the sealed test set. Record identity-level and background/phone results, not just aggregate accuracy.
5. On actual Android hardware, verify pixel format/color range, all orientations, box alignment, permission/lifecycle interruptions, resource release and p50/p95 end-to-end latency. Test the full hard-negative list, multiple objects, wrong views, blur, lighting and final-photo rejection. Verify unavailable/corrupt models remain blocked and sandbox use never changes History/sync.
6. Keep production grading blocked until required ArUco/calibration and finishing phases exist. Detection alone is insufficient, and quill length is never calculated.

No Android/iOS physical-camera tests or iOS build have been completed for this phase. A successful debug APK and mocked tests do not establish actual recognition performance.

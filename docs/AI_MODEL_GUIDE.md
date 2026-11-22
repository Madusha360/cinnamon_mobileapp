# Detection model deployment contract

**No trained model, validated threshold policy or native inference binding is installed.** The Flutter code implements model-independent interfaces and defensive contract handling. Adding a model filename alone does not enable detection or production grading.

## Architecture candidate and tool compatibility

A nano YOLO-family detector is a practical candidate for comparison; current [Ultralytics LiteRT documentation](https://docs.ultralytics.com/integrations/litert/) describes YOLO26n export with `format="litert"` and precision options. Its export requirements include a supported Linux x86-64 or Apple-silicon macOS host. Training/export commands and environment recording are in [the ML guide](../ml/cinnamon_detection/README.md). No candidate was trained, benchmarked or exported here.

The [TensorFlow `tflite_flutter` package](https://pub.dev/packages/tflite_flutter) exposes interpreter/isolate APIs, but compatibility must be checked against the actual exported model's operators/tensors, native library and target device. Its documented Android requirements may differ from the app's API-24 minimum. No runtime dependency or minimum-device change is introduced without a real model to test. Quantized output must not be interpreted as float32 or assumed equivalent to a float export.

## Asset integrity and explicit schema

Future reviewed assets belong under `assets/models/` and must be explicitly registered in `pubspec.yaml` under a deliberate model-distribution policy. There are **no fake model assets**. Raw datasets, experiment outputs and model binaries are ignored by default.

`ModelLoader` looks for `assets/models/cinnamon_detector.json`. Missing/unreadable assets, malformed metadata, unsupported label/type/layout, absent calibration values, bad hashes and bad flatbuffer identifiers fail closed. SHA-256 and the `TFL3` identifier establish byte identity only, not model validity or accuracy. A native runner must allocate the real flatbuffer and inspect its actual tensors. SQLite's existing `model_metadata` row alone does not install or approve a model; no installed row is created by this phase.

The proposed manifest schema requires:

| Field | Required meaning |
| --- | --- |
| `schema`, `version`, `asset`, `sha256` | Schema 1, recorded model version, a direct `.tflite` child of `assets/models/`, lowercase SHA-256 of actual model bytes |
| `labels` | Ordered `cinnamon_quill_end`, `cinnamon_quill_side`, `non_cinnamon`; these are proposed target labels, not observed dataset classes |
| `input` | Explicit width/height, `dtype: float32`, `layout: NHWC`, `color: RGB`, numeric scale/offset and padding value |
| `output` | `dtype: float32`, declared row count, `layout: xyxy_score_class_normalized_nms` |
| `policy` | Nonempty validation experiment ID; explicit confidence/candidate floor, visibility, timing, tracking and quality values described below |

Input is exactly `[1, height, width, 3]`, with `value = channel * scale + offset`. Output is exactly `[1, rows, 6]`; each row is `[left, top, right, bottom, confidence, class_id]`, normalized to the letterboxed input, with NMS already performed by the export/verified native adapter. Zero-score rows are padding. Non-finite values, invalid confidence, unknown classes, malformed boxes or shape mismatches are errors. **This is a canonical adapter contract, not a claim that a raw YOLO export has this layout.** The current adapter rejects raw/unknown layouts and INT8/UINT8 rather than guessing postprocessing or quantization.

`DetectionTensorRunner` is an interface only. Supply a tested implementation through `detectionRunnerFactoryProvider` after export verification. It must execute inference off the UI thread and report actual tensor shapes/dtypes. `TfliteCinnamonDetector.attach` validates these, enforces one invocation at a time and closes mismatched/disposed resources. There is no production mock runner or fake output fallback.

## Policy fields — no production defaults

Record `evaluation_id`, `minimum_confidence`, `candidate_floor`, `minimum_box_area`, `edge_margin`, `stable_frames`, `stable_duration_ms`, `maximum_frame_gap_ms`, `maximum_result_age_ms` and `minimum_tracking_iou`. Provide separately measured `preview_quality` and `still_quality`, each with `minimum_short_edge`, `minimum_pixels`, `minimum_luminance`, `clipped_luminance`, `maximum_clipped_fraction` and `minimum_laplacian_variance`.

These fields are required and range-checked; none has a production detection default. A nonempty experiment identifier is bookkeeping, not proof of scientific validation. Review the underlying labeled data, identity/background splits, threshold sweep and device results before shipping. Tests supply arbitrary fixture values only inside `test/`. Phase 3's existing photo-inspection defaults remain explicitly heuristic and do not authorize capture.

## Preprocessing and coordinates

The reusable preprocessor handles padded BGRA8888 and three-plane YUV420 with row/pixel strides. It uses an explicit full-range BT.601-style YUV-to-RGB conversion; this color-range assumption must be compared with the actual phone/runtime preprocessing before deployment. Unsupported NV21/unknown layouts, invalid strides, truncated planes or unsupported orientation fail closed. The existing rear-camera rotation formula uses sensor/device orientation, then letterboxes without distortion. JPEG stills honor EXIF and preserve original bytes; large JPEGs use scaled decoding for bounded inspection, not destructive resizing.

Image conversion, quality analysis and tensor construction run in `compute` isolates. The existing camera service copies eligible planes, throttles frames and applies backpressure. Candidate boxes are mapped from model padding to normalized upright image coordinates and then into the fitted camera-preview rectangle. The preview is unmirrored rear-camera output. Actual per-platform rotation/color/overlay alignment and latency still require physical-device verification.

## Acceptance boundaries

The policy requires exactly one sufficiently confident visible candidate above the configured candidate floor, the requested view, bounding-box visibility constraints and no image-quality warning. These box constraints are visibility proxies, not proof of surface or cross-section sufficiency; dataset labels and real evaluation must establish the model's view meaning. Stable validation requires consecutive distinct timestamps, consistent view/model, target overlap and calibrated count/duration/gap. Duplicate, delayed, stale or future frames cannot preserve capture readiness. Readiness expires if frames stop.

Final-photo revalidation consumes a fresh stable-preview ticket, reruns preprocessing/quality/detection on the original photo, and rejects changed view/model, failed quality, missing/invalid files or invalidated lifecycle results. A successful interface result is only a future **temporary-session** decision. It is never a repository validation receipt. The current debug sandbox never calls this as a promotion path, keeps immutable unvalidated provenance and remains excluded from permanent storage/History/sync.

Production capture remains disabled. The Phase 2 repository validation gate remains unavailable. ArUco calibration and millimeter measurements are Phase 5; finishing is Phase 6. Detection does not calculate length, establish calibration, assign a grade or authorize production grading. No model accuracy, acceptance rate or inference latency has been measured.

# Cinnamon detection experiments — no model trained yet

Keep training outside Flutter. Current code is preparation tooling, not a trained detector. The linked Drive dataset requires authorization and was not inspected. Do not treat branding assets, Study references, synthetic tests, or finishing labels as detection training data.

## Local inputs and annotation

Place an authorized copy under the ignored `ml/cinnamon_detection/dataset/` directory. Scripts constrain all inputs/outputs to this standalone workspace, reject traversal, and do not follow external symbolic links. Preserve the source photographs. Retain device, physical sample/object identity, capture session, background surface identity/type, view and provenance. Do not upload images or use cloud annotation without separate authorization.

Use a locally installed annotation tool such as CVAT or Label Studio to draw tight, reviewed boxes on explicitly upright images. Record coordinates against the exact image that will be trained, with originals retained separately. Export/review into the JSON manifest described below. The template command emits **pending/null** annotations; it never generates ground truth.

```sh
python ml/cinnamon_detection/scripts/dataset_tools.py inventory --root ml/cinnamon_detection/dataset
python ml/cinnamon_detection/scripts/dataset_tools.py template --root ml/cinnamon_detection/dataset --output ml/cinnamon_detection/dataset/pending_annotations.json
```

Install Pillow in an isolated audit environment before preparing data; it is required for actual image decoding, EXIF and corruption checks. The implementation was tested with Pillow 13.0.0 on Python 3.14. Generated reports and datasets are local artifacts, not automatically committed.

Each reviewed manifest row requires: `image` (relative path), `sample_id`, `session_id`, `background_id`, `background_type`, `phone_id`, `view` (`end`, `side`, `negative`), `negative_type`, `annotation_status: reviewed`, `reviewer`, and `boxes`. A box is `{ "class_id": 0, "xyxy": [left, top, right, bottom] }` using finite normalized coordinates; this example describes the schema only, not a real annotation. Class mapping: **0 cinnamon_quill_end, 1 cinnamon_quill_side, 2 non_cinnamon**. Annotate visible distractor objects as class 2. Empty/marker-only negative scenes have reviewed empty box lists. Whole-image finishing classes cannot substitute for these boxes.

Negative categories: pen, pencil, plastic_pipe, wooden_rod, rolled_paper, other_cylinder, powder, leaves, empty_background, marker_only, other. Include clutter, several objects, partial views, insufficient surface visibility and ambiguous quills. Establish expert labeling/review rules for “genuine cinnamon”; color, shape or a detector output cannot establish botanical authenticity by itself.

## Leakage-resistant preparation

```sh
python ml/cinnamon_detection/scripts/dataset_tools.py prepare --root ml/cinnamon_detection/dataset --manifest ml/cinnamon_detection/dataset/reviewed.json --output ml/cinnamon_detection/experiments/split-001
```

Connected components join physical identities, sessions, background identities and exact file hashes. Whole components go to train/validation/test (approximately 70/15/15 groups, seed 42). Each partition must contain End, Side and negative examples. If few components or missing categories prevent a split, collect more independent data; do not relabel identities to force a split. Exact hashes do not detect resized/cropped near-duplicates: manual provenance review remains required. Group splitting does not guarantee balanced background/phone coverage. Review the saved split manifest, category counts and diversity before training. Keep test identities/backgrounds sealed until the model, preprocessing and threshold policy are frozen.

Preparation copies originals byte-for-byte to a new experiment directory and converts reviewed boxes to YOLO text labels. It refuses existing output directories. A failed I/O operation can leave an incomplete new output directory; inspect it and choose a fresh destination. It never overwrites source photographs or annotations.

## Training candidate and experiment procedure

Evaluate a nano YOLO detector (YOLO26n is a current candidate) against a small mobile-friendly alternative if latency or export support is inadequate. No candidate has been benchmarked on cinnamon. Obtain local weights through a reviewed process and observe the selected tool/weights license. No weights are downloaded by the scripts.

Create a dedicated training environment on a supported host, install and freeze the exact Ultralytics/PyTorch versions, and record hardware. A human review JSON must contain `approved_for_experiment: true`, `reviewer`, and `limitations` describing annotation quality, sample counts, negative/background/phone coverage and what remains unknown. That review is not a model approval.

```sh
python ml/cinnamon_detection/scripts/train_model.py --prepared ml/cinnamon_detection/experiments/split-001 --weights ml/cinnamon_detection/dataset/yolo26n.pt --review ml/cinnamon_detection/dataset/review.json --output ml/cinnamon_detection/experiments/run-001 --epochs 100 --image-size 640 --batch 8 --device cpu
```

The command values are example experiment settings, not validated accuracy/latency choices. The script checks split separation, records package versions, trains and validates on `val` only. Initial augmentations vary brightness/color, small rotation/translation, scale, horizontal flips and moderate mosaic. Review whether these preserve the visible End/Side meaning. Do not use synthetic background replacement as a substitute for real white, black, green, wood, textured, indoor/outdoor, distance, lighting and phone diversity. Measure unseen-background failure rates and sample/background ablations before choosing a model.

## Export and validation

Current Ultralytics documentation recommends `format="litert"`; the older `tflite` route is deprecated. Its current export host requirements are Linux x86-64 or Apple-silicon macOS, so native export is **not verified on this Windows machine**. In the reviewed environment, export the actual trained checkpoint with an explicitly chosen precision and preprocessing contract; start with FP32 and evaluate quantized variants separately. Do not accept default calibration images for INT8: use representative training data with held-out evaluation.

```python
# Run only after training, on a supported export host with frozen dependencies.
from ultralytics import YOLO
model = YOLO("<actual-local-trained-checkpoint.pt>")
model.export(format="litert", imgsz=640, batch=1)
```

```sh
python ml/cinnamon_detection/scripts/inspect_export.py ml/cinnamon_detection/experiments/run-001/model.tflite --output ml/cinnamon_detection/experiments/run-001/tensors.json
```

`inspect_export.py` requires `ai-edge-litert`, allocates actual tensors and records shape/type/quantization/hash. It does not approve the model. Verify RGB order, YUV conversion/range, orientation, normalization, padding, label order, output units/layout, NMS, supported operators and quantization against labeled images. Compare source-model, desktop LiteRT and actual Android outputs numerically and visually. The current Flutter adapter accepts only the documented canonical float32 contract; raw YOLO or quantized exports need an explicitly verified adapter. Never rename a file to imply compatibility.

## Metrics and threshold selection

Save actual prediction records containing `image`, `accepted` (the end-to-end policy decision), `view` (`end`, `side`, `none`), measured `latency_ms`, and `boxes` (`class_id`, `confidence`, normalized upright `xyxy`). Every evaluation image must appear exactly once. Include model hash, runtime/device version and capture-policy version in the experiment report. Test fixtures are not evaluation evidence.

```sh
python ml/cinnamon_detection/scripts/evaluate_predictions.py --root ml/cinnamon_detection/dataset --manifest ml/cinnamon_detection/dataset/test.json --predictions ml/cinnamon_detection/experiments/run-001/test_predictions.json --output ml/cinnamon_detection/experiments/run-001/test_metrics.json --confidence <frozen-validation-threshold> --match-iou <declared-matching-threshold>
```

The evaluator reports box precision/recall at the supplied IoU/confidence, image false acceptance/rejection, view/rejection confusion, background counts/errors and measured latency mean/p95. A rate with no denominator is null, never fabricated as zero. It does not report mAP or confidence intervals. Use the training framework's real validation report for mAP and add identity-level bootstrap intervals for a defensible final report. Tune confidence/candidate floor, visibility margin, quality thresholds, frame count/time/gap, tracking IoU and expiry on validation sequences, prioritizing hard-negative false acceptance. Freeze the selected policy before the sealed test run. Still-photo and stream thresholds need separate evaluation.

References checked for implementation planning: [Ultralytics LiteRT export](https://docs.ultralytics.com/integrations/litert/), [Ultralytics model export](https://docs.ultralytics.com/modes/export/), [TensorFlow Flutter runtime](https://pub.dev/packages/tflite_flutter). These describe tools, not verified compatibility of a nonexistent cinnamon model.

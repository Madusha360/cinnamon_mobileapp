import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:quillgrade_mobile/features/capture/domain/capture_session.dart';
import 'package:quillgrade_mobile/features/capture/domain/frame_processor.dart';
import 'package:quillgrade_mobile/features/cinnamon_detection/data/image_preprocessor.dart';
import 'package:quillgrade_mobile/features/cinnamon_detection/data/model_loader.dart';
import 'package:quillgrade_mobile/features/cinnamon_detection/domain/cinnamon_detector.dart';
import 'package:quillgrade_mobile/features/cinnamon_detection/domain/detection_result.dart';

// Arbitrary deterministic values ONLY for exercising code branches, never a
// validated confidence policy or evidence about cinnamon recognition.
Map<String, dynamic> fixtureModelJson() {
  final quality = {
    'minimum_short_edge': 16,
    'minimum_pixels': 256,
    'minimum_luminance': 10.0,
    'clipped_luminance': 250.0,
    'maximum_clipped_fraction': .9,
    'minimum_laplacian_variance': 1.0,
  };
  return {
    'schema': 1,
    'version': 'test-only',
    'asset': 'assets/models/fixture.tflite',
    'sha256': List.filled(64, '0').join(),
    'labels': ['cinnamon_quill_end', 'cinnamon_quill_side', 'non_cinnamon'],
    'input': {
      'width': 32,
      'height': 32,
      'dtype': 'float32',
      'layout': 'NHWC',
      'color': 'RGB',
      'scale': 1 / 255,
      'offset': 0.0,
      'padding': 114,
    },
    'output': {
      'rows': 2,
      'dtype': 'float32',
      'layout': 'xyxy_score_class_normalized_nms',
    },
    'policy': {
      'evaluation_id': 'SYNTHETIC-UNIT-TEST-NOT-A-CALIBRATION',
      'minimum_confidence': .8,
      'candidate_floor': .3,
      'minimum_box_area': .05,
      'edge_margin': .02,
      'stable_frames': 3,
      'stable_duration_ms': 200,
      'maximum_frame_gap_ms': 250,
      'maximum_result_age_ms': 500,
      'minimum_tracking_iou': .5,
      'preview_quality': quality,
      'still_quality': quality,
    },
  };
}

ModelSpecification fixtureSpecification() =>
    ModelSpecification.fromJson(fixtureModelJson());
const goodQuality = ImageQualityReport(
  width: 1200,
  height: 1000,
  exifOrientation: 1,
  issues: [],
);
const endCandidate = DetectionCandidate(
  label: DetectionLabel.cinnamonEnd,
  confidence: .95,
  box: Rect.fromLTRB(.2, .2, .8, .8),
);
CaptureFrame fixtureFrame(
  DateTime time, {
  CaptureView view = CaptureView.end,
}) => CaptureFrame(
  width: 32,
  height: 32,
  format: 'test-only',
  planes: [],
  sensorOrientation: 90,
  deviceOrientation: 'portraitUp',
  receivedAt: time,
  view: view,
);

class FixtureDetector implements CinnamonDetector {
  List<DetectionCandidate> candidates = [endCandidate];
  bool enabled = true, closed = false;
  int calls = 0;
  Completer<void>? gate;
  final entered = Completer<void>();
  @override
  bool get available => enabled && !closed;
  @override
  String get modelVersion => 'test-only';
  @override
  Future<List<DetectionCandidate>> detect(Float32List input) async {
    calls++;
    if (!entered.isCompleted) entered.complete();
    if (gate != null) await gate!.future;
    return candidates;
  }

  @override
  Future<void> close() async {
    closed = true;
  }
}

class FixturePreprocessor extends ImagePreprocessor {
  ImageQualityReport quality = goodQuality;
  ImageQualityReport stillQuality = goodQuality;
  int files = 0;
  @override
  Future<PreparedDetectionImage> frame(
    CaptureFrame frame,
    PreprocessingSpec spec,
    QualityThresholds quality,
  ) async => PreparedDetectionImage(
    Float32List(spec.width * spec.height * 3),
    LetterboxTransform(32, 32, 32, 32),
    this.quality,
  );
  @override
  Future<PreparedDetectionImage> file(
    String path,
    PreprocessingSpec spec,
    QualityThresholds quality,
  ) async {
    files++;
    return PreparedDetectionImage(
      Float32List(spec.width * spec.height * 3),
      LetterboxTransform(32, 32, 32, 32),
      stillQuality,
    );
  }
}

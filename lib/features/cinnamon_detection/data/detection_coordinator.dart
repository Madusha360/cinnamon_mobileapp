import 'dart:async';

import '../../capture/domain/capture_session.dart';
import '../../capture/domain/frame_processor.dart';
import '../domain/cinnamon_detector.dart';
import '../domain/detection_policy.dart';
import '../domain/detection_result.dart';
import '../domain/detection_status.dart';
import 'image_preprocessor.dart';
import 'image_quality_validator.dart';

class DetectionCoordinator implements CaptureFrameProcessor {
  DetectionCoordinator({
    required this.detector,
    this.specification,
    this.policy,
    this.preprocessor = const ImagePreprocessor(),
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now,
       _gate = policy == null ? null : StableDetectionGate(policy);
  final CinnamonDetector detector;
  final PreprocessingSpec? specification;
  final DetectionPolicy? policy;
  final ImagePreprocessor preprocessor;
  final DateTime Function() _now;
  final StableDetectionGate? _gate;
  final _updates = StreamController<DetectionResult>.broadcast();
  Stream<DetectionResult> get updates => _updates.stream;
  DetectionResult current = DetectionResult.unavailable;
  bool _busy = false, _closed = false;
  int _generation = 0;
  Timer? _expiry;
  bool get available =>
      !_closed && detector.available && specification != null && policy != null;

  void _publish(DetectionResult result) {
    if (_closed) return;
    current = result;
    _expiry?.cancel();
    _updates.add(result);
    if (result.status == DetectionStatus.valid) {
      _expiry = Timer(policy!.maximumResultAge, reset);
    }
  }

  void reset() {
    ++_generation;
    _gate?.reset();
    _publish(
      available
          ? const DetectionResult(status: DetectionStatus.searching)
          : DetectionResult.unavailable,
    );
  }

  @override
  Future<FrameReadiness> process(CaptureFrame frame) async {
    if (!available) return FrameReadiness.unavailable;
    if (_busy) return FrameReadiness.unavailable;
    final age = _now().toUtc().difference(frame.receivedAt.toUtc());
    if (age.isNegative || age > policy!.maximumResultAge) {
      reset();
      return FrameReadiness.unavailable;
    }
    _busy = true;
    final generation = _generation;
    final watch = Stopwatch()..start();
    try {
      final prepared = await preprocessor.frame(
        frame,
        specification!,
        policy!.previewQuality,
      );
      final result = await _classify(prepared, frame.view, frame.receivedAt);
      if (_closed || generation != _generation) {
        return FrameReadiness.unavailable;
      }
      if (_now().toUtc().difference(frame.receivedAt.toUtc()) >
          policy!.maximumResultAge) {
        reset();
        return FrameReadiness.unavailable;
      }
      final stable = _gate!.add(result);
      final finalResult = DetectionResult(
        status: result.status,
        view: frame.view,
        observedAt: frame.receivedAt,
        modelVersion: detector.modelVersion,
        candidates: result.candidates,
        stable: stable,
        latency: watch.elapsed,
      );
      _publish(finalResult);
      return FrameReadiness(
        modelAvailable: true,
        correctView: result.status == DetectionStatus.valid,
        rejected:
            result.status == DetectionStatus.invalid ||
            result.status == DetectionStatus.wrongView,
        stable: stable,
        regions: [
          for (final c in result.candidates)
            DetectedRegion(
              left: c.box.left,
              top: c.box.top,
              width: c.box.width,
              height: c.box.height,
              label: c.label.name,
              confidence: c.confidence,
            ),
        ],
      );
    } catch (_) {
      if (!_closed && generation == _generation) {
        _gate!.reset();
        _publish(
          DetectionResult(
            status: DetectionStatus.uncertain,
            view: frame.view,
            reason: 'Frame analysis failed',
          ),
        );
      }
      return FrameReadiness.unavailable;
    } finally {
      _busy = false;
    }
  }

  Future<DetectionResult> _classify(
    PreparedDetectionImage image,
    CaptureView view,
    DateTime time,
  ) async {
    final rejection = const ImageQualityValidator().rejection(image.quality);
    if (rejection != null) {
      return DetectionResult(status: rejection, view: view, observedAt: time);
    }
    final raw = await detector.detect(image.tensor);
    if (raw.any((candidate) => !candidate.isWellFormed)) {
      throw const FormatException('Malformed detector output');
    }
    final candidates = [
      for (final c in raw)
        DetectionCandidate(
          label: c.label,
          confidence: c.confidence,
          box: image.transform.toUpright(c.box),
        ),
    ];
    return DetectionResult(
      status: policy!.classify(candidates, view, image.quality),
      view: view,
      observedAt: time,
      modelVersion: detector.modelVersion,
      candidates: List.unmodifiable(candidates),
    );
  }

  /// Requires a fresh stable preview, then independently examines the full
  /// original file. The preview ticket is consumed even when the still fails.
  Future<StillImageValidation> revalidateFile(
    String path,
    CaptureView view,
  ) async {
    final preview = current;
    final age = preview.observedAt == null
        ? null
        : _now().toUtc().difference(preview.observedAt!.toUtc());
    final eligible =
        available &&
        !_busy &&
        preview.readyForTemporaryCapture &&
        preview.view == view &&
        preview.modelVersion == detector.modelVersion &&
        age != null &&
        !age.isNegative &&
        age <= policy!.maximumResultAge;
    reset();
    if (!eligible) {
      return StillImageValidation(current, acceptedForSession: false);
    }
    _busy = true;
    final generation = _generation;
    try {
      final image = await preprocessor.file(
        path,
        specification!,
        policy!.stillQuality,
      );
      final result = await _classify(image, view, _now().toUtc());
      final accepted =
          !_closed &&
          generation == _generation &&
          result.status == DetectionStatus.valid &&
          result.modelVersion == preview.modelVersion;
      return StillImageValidation(result, acceptedForSession: accepted);
    } catch (_) {
      return const StillImageValidation(
        DetectionResult(
          status: DetectionStatus.uncertain,
          reason: 'Still image validation failed',
        ),
        acceptedForSession: false,
      );
    } finally {
      _busy = false;
    }
  }

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    ++_generation;
    _expiry?.cancel();
    _gate?.reset();
    await detector.close();
    await _updates.close();
  }
}

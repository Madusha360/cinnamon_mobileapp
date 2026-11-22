import '../../capture/domain/capture_session.dart';
import 'detection_result.dart';
import 'detection_status.dart';

/// All values must come from a recorded validation experiment. There are no
/// production confidence/stability defaults and no installed policy today.
class DetectionPolicy {
  DetectionPolicy({
    required this.evaluationId,
    required this.minimumConfidence,
    required this.candidateFloor,
    required this.minimumBoxArea,
    required this.edgeMargin,
    required this.stableFrames,
    required this.stableDuration,
    required this.maximumFrameGap,
    required this.maximumResultAge,
    required this.minimumTrackingIou,
    required this.previewQuality,
    required this.stillQuality,
  }) {
    if (evaluationId.trim().isEmpty ||
        stableFrames < 2 ||
        stableFrames > 120 ||
        stableDuration <= Duration.zero ||
        maximumFrameGap <= Duration.zero ||
        maximumResultAge <= Duration.zero ||
        [
          minimumConfidence,
          candidateFloor,
          minimumBoxArea,
          edgeMargin,
          minimumTrackingIou,
        ].any((v) => !v.isFinite || v <= 0 || v >= 1) ||
        candidateFloor > minimumConfidence ||
        edgeMargin >= 0.5 ||
        !previewQuality.isValid ||
        !stillQuality.isValid) {
      throw const FormatException('Invalid or uncalibrated detection policy');
    }
  }
  final String evaluationId;
  final double minimumConfidence,
      candidateFloor,
      minimumBoxArea,
      edgeMargin,
      minimumTrackingIou;
  final int stableFrames;
  final Duration stableDuration, maximumFrameGap, maximumResultAge;
  final QualityThresholds previewQuality, stillQuality;

  DetectionStatus classify(
    List<DetectionCandidate> candidates,
    CaptureView view,
    ImageQualityReport quality,
  ) {
    if (quality.issues.contains(QualityIssue.invalidFile)) {
      return DetectionStatus.uncertain;
    }
    if (quality.issues.contains(QualityIssue.blur)) {
      return DetectionStatus.blurry;
    }
    if (quality.hasWarnings) return DetectionStatus.uncertain;
    if (candidates.any((candidate) => !candidate.isWellFormed)) {
      return DetectionStatus.uncertain;
    }
    final visible = candidates
        .where((c) => c.confidence >= candidateFloor)
        .toList();
    if (visible.isEmpty) return DetectionStatus.searching;
    if (visible.length != 1) return DetectionStatus.uncertain;
    final candidate = visible.single;
    if (candidate.confidence < minimumConfidence) {
      return DetectionStatus.uncertain;
    }
    if (candidate.label == DetectionLabel.nonCinnamon) {
      return DetectionStatus.invalid;
    }
    if ((candidate.label == DetectionLabel.cinnamonEnd) !=
        (view == CaptureView.end)) {
      return DetectionStatus.wrongView;
    }
    final box = candidate.box;
    if (box.width * box.height < minimumBoxArea ||
        box.left < edgeMargin ||
        box.top < edgeMargin ||
        box.right > 1 - edgeMargin ||
        box.bottom > 1 - edgeMargin) {
      return DetectionStatus.uncertain;
    }
    return DetectionStatus.valid;
  }
}

class StableDetectionGate {
  StableDetectionGate(this.policy);
  final DetectionPolicy policy;
  DetectionResult? _previous;
  DateTime? _first;
  int _count = 0;
  void reset() {
    _previous = null;
    _first = null;
    _count = 0;
  }

  bool add(DetectionResult result) {
    final time = result.observedAt;
    final targets = result.candidates
        .where((c) => c.confidence >= policy.candidateFloor)
        .toList();
    if (result.status != DetectionStatus.valid ||
        time == null ||
        targets.length != 1) {
      reset();
      return false;
    }
    final previous = _previous;
    if (previous != null && !time.isAfter(previous.observedAt!)) {
      reset();
      return false;
    }
    final continuous =
        previous != null &&
        previous.modelVersion == result.modelVersion &&
        previous.view == result.view &&
        time.difference(previous.observedAt!) <= policy.maximumFrameGap &&
        boxIntersectionOverUnion(
              previous.candidates
                  .firstWhere((c) => c.confidence >= policy.candidateFloor)
                  .box,
              targets.single.box,
            ) >=
            policy.minimumTrackingIou;
    if (!continuous) {
      _count = 0;
      _first = time;
    }
    _count++;
    _previous = result;
    return _count >= policy.stableFrames &&
        time.difference(_first!) >= policy.stableDuration;
  }
}

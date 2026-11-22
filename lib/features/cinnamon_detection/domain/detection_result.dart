import 'dart:ui';

import '../../capture/domain/capture_session.dart';
import 'detection_status.dart';

enum DetectionLabel { cinnamonEnd, cinnamonSide, nonCinnamon }

class DetectionCandidate {
  const DetectionCandidate({
    required this.label,
    required this.confidence,
    required this.box,
  });
  final DetectionLabel label;
  final double confidence;

  /// Normalized coordinates in the upright, unmirrored original image.
  final Rect box;
  bool get isWellFormed =>
      confidence.isFinite &&
      confidence >= 0 &&
      confidence <= 1 &&
      [
        box.left,
        box.top,
        box.right,
        box.bottom,
      ].every((v) => v.isFinite && v >= 0 && v <= 1) &&
      box.width > 0 &&
      box.height > 0;
}

class DetectionResult {
  const DetectionResult({
    required this.status,
    this.view,
    this.observedAt,
    this.modelVersion,
    this.candidates = const [],
    this.stable = false,
    this.reason,
    this.latency,
  });
  final DetectionStatus status;
  final CaptureView? view;
  final DateTime? observedAt;
  final String? modelVersion;
  final List<DetectionCandidate> candidates;
  final bool stable;
  final String? reason;
  final Duration? latency;
  bool get readyForTemporaryCapture =>
      status == DetectionStatus.valid && stable;
  // Detection alone never satisfies calibration / finishing / repository checks.
  bool get productionGradingAllowed => false;
  static const unavailable = DetectionResult(
    status: DetectionStatus.modelUnavailable,
  );
}

double boxIntersectionOverUnion(Rect a, Rect b) {
  final intersection = a.intersect(b);
  if (intersection.isEmpty) return 0;
  final area = intersection.width * intersection.height;
  return area / (a.width * a.height + b.width * b.height - area);
}

/// Outcome for a future temporary validated workflow, never a database receipt.
class StillImageValidation {
  const StillImageValidation(this.result, {required this.acceptedForSession});
  final DetectionResult result;
  final bool acceptedForSession;
  bool get productionGradingAllowed => false;
}

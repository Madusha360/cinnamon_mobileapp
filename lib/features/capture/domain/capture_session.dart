import 'dart:typed_data';

enum CaptureView { end, side }

enum CameraPhase {
  idle,
  initializing,
  preview,
  capturing,
  review,
  paused,
  failed,
}

enum CameraFailureKind {
  permissionDenied,
  permissionPermanent,
  permissionRestricted,
  unavailable,
  inUse,
  initialization,
  capture,
  storage,
  unsupported,
  sandboxDisabled,
}

enum QualityIssue { invalidFile, resolution, blur, dark, overexposed }

/// Phase 3 defaults are inspection heuristics. Detection requires explicitly
/// evaluated preview/still thresholds, supplied by its reviewed model policy.
class QualityThresholds {
  const QualityThresholds({
    this.minimumShortEdge = 720,
    this.minimumPixels = 1000000,
    this.minimumLuminance = 40,
    this.clippedLuminance = 245,
    this.maximumClippedFraction = 0.6,
    this.minimumLaplacianVariance = 75,
  });
  final int minimumShortEdge, minimumPixels;
  final double minimumLuminance,
      clippedLuminance,
      maximumClippedFraction,
      minimumLaplacianVariance;
  bool get isValid =>
      minimumShortEdge > 0 &&
      minimumPixels > 0 &&
      minimumLuminance.isFinite &&
      minimumLuminance > 0 &&
      minimumLuminance < 255 &&
      clippedLuminance.isFinite &&
      clippedLuminance > minimumLuminance &&
      clippedLuminance <= 255 &&
      maximumClippedFraction.isFinite &&
      maximumClippedFraction > 0 &&
      maximumClippedFraction < 1 &&
      minimumLaplacianVariance.isFinite &&
      minimumLaplacianVariance > 0;
}

class CameraFailure implements Exception {
  const CameraFailure(this.kind);
  final CameraFailureKind kind;
}

class CaptureMetadata {
  const CaptureMetadata({
    required this.cameraName,
    required this.sensorOrientation,
    required this.deviceOrientation,
    required this.capturedAt,
    required this.flashMode,
    this.exposureMode,
  });
  final String cameraName;
  final int sensorOrientation;
  final String deviceOrientation;
  final DateTime capturedAt;
  final String flashMode;
  final String? exposureMode;
}

class ImageQualityReport {
  const ImageQualityReport({
    required this.width,
    required this.height,
    required this.exifOrientation,
    required this.issues,
    this.previewBytes,
    this.meanLuminance,
    this.laplacianVariance,
  });
  final int width;
  final int height;
  final int exifOrientation;
  final List<QualityIssue> issues;

  /// Oriented inspection preview only; the original file is never rewritten.
  final Uint8List? previewBytes;
  final double? meanLuminance;
  final double? laplacianVariance;
  bool get hasWarnings => issues.isNotEmpty;
  bool get validatesCinnamon => false;
  static const invalid = ImageQualityReport(
    width: 0,
    height: 0,
    exifOrientation: 1,
    issues: [QualityIssue.invalidFile],
  );
}

class TemporaryCapture {
  const TemporaryCapture({
    required this.path,
    required this.view,
    required this.metadata,
    required this.quality,
  });
  final String path;
  final CaptureView view;
  final CaptureMetadata metadata;
  final ImageQualityReport quality;
  // Sandbox provenance is immutable, independent of lighting/sharpness results.
  bool get productionEligible => false;
}

class CaptureSession {
  CaptureSession({
    required this.id,
    required this.startedAt,
    Map<CaptureView, TemporaryCapture> photos = const {},
  }) : photos = Map.unmodifiable(photos);
  final String id;
  final DateTime startedAt;
  final Map<CaptureView, TemporaryCapture> photos;
  CaptureSession withPhoto(CaptureView view, TemporaryCapture? photo) {
    final updated = Map<CaptureView, TemporaryCapture>.of(photos);
    if (photo == null) {
      updated.remove(view);
    } else {
      updated[view] = photo;
    }
    return CaptureSession(id: id, startedAt: startedAt, photos: updated);
  }
}

class CaptureState {
  const CaptureState({
    this.phase = CameraPhase.idle,
    this.view = CaptureView.end,
    this.session,
    this.failure,
    this.flashOn = false,
    this.flashSupported = false,
    this.focusSupported = false,
    this.controlUnavailable = false,
  });
  final CameraPhase phase;
  final CaptureView view;
  final CaptureSession? session;
  final CameraFailureKind? failure;
  final bool flashOn;
  final bool flashSupported;
  final bool focusSupported;
  final bool controlUnavailable;
  bool get busy =>
      phase == CameraPhase.initializing || phase == CameraPhase.capturing;
  TemporaryCapture? get photo => session?.photos[view];
  CaptureState copyWith({
    CameraPhase? phase,
    CaptureView? view,
    CaptureSession? session,
    CameraFailureKind? failure,
    bool clearFailure = false,
    bool? flashOn,
    bool? flashSupported,
    bool? focusSupported,
    bool? controlUnavailable,
  }) => CaptureState(
    phase: phase ?? this.phase,
    view: view ?? this.view,
    session: session ?? this.session,
    failure: clearFailure ? null : failure ?? this.failure,
    flashOn: flashOn ?? this.flashOn,
    flashSupported: flashSupported ?? this.flashSupported,
    focusSupported: focusSupported ?? this.focusSupported,
    controlUnavailable: controlUnavailable ?? this.controlUnavailable,
  );
}

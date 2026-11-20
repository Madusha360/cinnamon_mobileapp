import 'dart:typed_data';

import 'capture_session.dart';

class CapturePlane {
  const CapturePlane({required this.bytes, required this.bytesPerRow, this.bytesPerPixel});
  final Uint8List bytes;
  final int bytesPerRow;
  final int? bytesPerPixel;
}

class CaptureFrame {
  const CaptureFrame({required this.width, required this.height, required this.format, required this.planes, required this.sensorOrientation, required this.deviceOrientation, required this.receivedAt, required this.view});
  final int width;
  final int height;
  final String format;
  final List<CapturePlane> planes;
  final int sensorOrientation;
  final String deviceOrientation;
  final DateTime receivedAt;
  final CaptureView view;
}

/// Future detector coordinates are normalized against the supplied frame.
class DetectedRegion {
  const DetectedRegion({required this.left, required this.top, required this.width, required this.height, required this.label, required this.confidence});
  final double left, top, width, height, confidence;
  final String label;
}

class FrameReadiness {
  const FrameReadiness({required this.modelAvailable, required this.correctView, required this.rejected, this.regions = const []});
  final bool modelAvailable, correctView, rejected;
  final List<DetectedRegion> regions;
  bool get ready => modelAvailable && correctView && !rejected;
  static const unavailable = FrameReadiness(modelAvailable: false, correctView: false, rejected: false);
}

/// No production implementation/model is installed in Phase 3. Quality checks
/// do not implement this interface and cannot grant detection readiness.
abstract interface class CaptureFrameProcessor {
  Future<FrameReadiness> process(CaptureFrame frame);
}

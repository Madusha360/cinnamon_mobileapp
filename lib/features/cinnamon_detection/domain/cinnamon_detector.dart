import 'dart:typed_data';

import 'detection_result.dart';

/// A native binding must do expensive invocation in an isolate/native worker.
/// No native runner or trained artifact is installed by this phase's fallback.
abstract interface class CinnamonDetector {
  bool get available;
  String? get modelVersion;
  Future<List<DetectionCandidate>> detect(Float32List rgbInput);
  Future<void> close();
}

class UnavailableCinnamonDetector implements CinnamonDetector {
  const UnavailableCinnamonDetector();
  @override
  bool get available => false;
  @override
  String? get modelVersion => null;
  @override
  Future<List<DetectionCandidate>> detect(Float32List rgbInput) =>
      Future.error(StateError('Detection model is unavailable'));
  @override
  Future<void> close() async {}
}

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:quillgrade_mobile/core/storage/image_storage_service.dart';
import 'package:quillgrade_mobile/features/capture/data/camera_service.dart';
import 'package:quillgrade_mobile/features/capture/data/image_quality_service.dart';
import 'package:quillgrade_mobile/features/capture/domain/capture_session.dart';
import 'package:quillgrade_mobile/features/capture/domain/frame_processor.dart';

/// These mocks are confined to tests. Production always renders CameraPreview.
class FakeCameraService implements CameraService {
  final events = StreamController<CameraFailureKind>.broadcast();
  CameraFailureKind? initializeFailure;
  CameraFailureKind? closeFailure;
  Completer<void>? initializeGate;
  Completer<void>? photoGate;
  final List<File> outputs = [];
  int initializations = 0,
      closes = 0,
      captures = 0,
      settingsOpened = 0,
      streamsStarted = 0;
  bool isOpen = false, disposed = false, allowControls = true;
  Offset? lastFocus;
  @override
  bool flashSupported = true;
  @override
  bool focusSupported = true;
  @override
  double get aspectRatio => 4 / 3;
  @override
  Stream<CameraFailureKind> get errors => events.stream;
  @override
  Future<void> initialize({bool requestPermission = true}) async {
    initializations++;
    if (initializeGate != null) await initializeGate!.future;
    if (initializeFailure != null) throw CameraFailure(initializeFailure!);
    isOpen = true;
  }

  @override
  Widget buildPreview() => const ColoredBox(
    key: ValueKey('mock-camera-preview'),
    color: Colors.black,
  );
  @override
  Future<CameraPhoto> takePhoto() async {
    captures++;
    if (photoGate != null) await photoGate!.future;
    return CameraPhoto(
      outputs.removeAt(0),
      CaptureMetadata(
        cameraName: 'test-rear',
        sensorOrientation: 90,
        deviceOrientation: 'portraitUp',
        capturedAt: DateTime.utc(2026, 11, 21),
        flashMode: 'off',
      ),
    );
  }

  @override
  Future<void> close() async {
    closes++;
    isOpen = false;
    if (closeFailure != null) throw CameraFailure(closeFailure!);
  }

  @override
  Future<void> dispose() async {
    disposed = true;
    await close();
    await events.close();
  }

  @override
  Future<bool> setFlash(bool enabled) async => allowControls;
  @override
  Future<bool> focus(Offset point) async {
    lastFocus = point;
    return allowControls;
  }

  @override
  Future<bool> openSettings() async {
    settingsOpened++;
    return true;
  }

  @override
  Future<void> startFrames(
    CaptureFrameProcessor processor,
    CaptureView view,
    void Function(FrameReadiness) onResult,
  ) async {
    streamsStarted++;
  }
}

class FakeQualityService implements ImageQualityService {
  FakeQualityService({this.issues = const []});
  final List<QualityIssue> issues;
  Completer<void>? gate;
  final entered = Completer<void>();
  @override
  Future<ImageQualityReport> inspect(String path) async {
    if (!entered.isCompleted) entered.complete();
    if (gate != null) await gate!.future;
    return ImageQualityReport(
      width: 1200,
      height: 1000,
      exifOrientation: 1,
      issues: issues,
      previewBytes: img.encodePng(img.Image(width: 32, height: 24)),
    );
  }
}

/// Widget tests isolate file transport; filesystem tests exercise the real
/// ImageStorageService separately with actual temporary files.
class WidgetCaptureStorage extends ImageStorageService {
  final files = <String>{};
  int removed = 0;
  @override
  Future<void> cleanTemporaryCaptures({String? keepSessionId}) async {}
  @override
  Future<File> adoptTemporaryCapture(
    String sessionId,
    String view,
    File source,
  ) async {
    final file = File('/isolated-camera-test/$sessionId/$view.jpg');
    files.add(file.path);
    return file;
  }

  @override
  Future<void> discardTemporaryCapture(String sessionId, String view) async {
    removed++;
    files.remove(File('/isolated-camera-test/$sessionId/$view.jpg').path);
  }

  @override
  Future<void> discardTemporarySession(String sessionId) async {
    removed += files.length;
    files.clear();
  }

  @override
  Future<void> discardCameraOutput(File source) async {}
}

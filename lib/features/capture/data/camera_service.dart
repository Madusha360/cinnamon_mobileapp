import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../domain/capture_session.dart';
import '../domain/frame_processor.dart';

enum CameraPermission { granted, denied, permanentlyDenied, restricted }

abstract interface class CameraPermissionGateway {
  Future<CameraPermission> check({required bool request});
  Future<bool> openSettings();
}

class DeviceCameraPermission implements CameraPermissionGateway {
  @override
  Future<CameraPermission> check({required bool request}) async {
    var status = await Permission.camera.status;
    if (!status.isGranted && !status.isRestricted && request) status = await Permission.camera.request();
    if (status.isGranted) return CameraPermission.granted;
    if (status.isPermanentlyDenied) return CameraPermission.permanentlyDenied;
    if (status.isRestricted) return CameraPermission.restricted;
    return CameraPermission.denied;
  }
  @override
  Future<bool> openSettings() => openAppSettings();
}

class CameraPhoto {
  const CameraPhoto(this.file, this.metadata);
  final File file;
  final CaptureMetadata metadata;
}

abstract interface class CameraService {
  Future<void> initialize({bool requestPermission = true});
  Future<CameraPhoto> takePhoto();
  Future<bool> setFlash(bool enabled);
  Future<bool> focus(Offset normalizedPoint);
  Future<bool> openSettings();
  Future<void> close();
  Future<void> dispose();
  Future<void> startFrames(CaptureFrameProcessor processor, CaptureView view, void Function(FrameReadiness) onResult);
  Widget buildPreview();
  double get aspectRatio;
  bool get flashSupported;
  bool get focusSupported;
  Stream<CameraFailureKind> get errors;
}

/// Sole hardware adapter. Audio/video/gallery access is deliberately disabled.
class DeviceCameraService implements CameraService {
  DeviceCameraService({CameraPermissionGateway? permissions, Future<List<CameraDescription>> Function()? cameras, CameraController Function(CameraDescription)? controllerFactory})
    : _permissions = permissions ?? DeviceCameraPermission(), _cameras = cameras ?? availableCameras,
      _factory = controllerFactory ?? ((description) => CameraController(description, ResolutionPreset.max, enableAudio: false));
  final CameraPermissionGateway _permissions;
  final Future<List<CameraDescription>> Function() _cameras;
  final CameraController Function(CameraDescription) _factory;
  final _errors = StreamController<CameraFailureKind>.broadcast();
  CameraController? _controller;
  bool _flashSupported = false;
  bool _processing = false;
  int _streamGeneration = 0;
  @override
  Stream<CameraFailureKind> get errors => _errors.stream;
  @override
  double get aspectRatio => _controller?.value.aspectRatio ?? 4 / 3;
  @override
  bool get flashSupported => _flashSupported;
  @override
  bool get focusSupported => _controller?.value.focusPointSupported ?? false;

  static CameraFailureKind classify(Object error) {
    if (error is CameraFailure) return error.kind;
    if (error is! CameraException) return CameraFailureKind.initialization;
    return switch (error.code) {
      'CameraAccessDenied' => CameraFailureKind.permissionDenied,
      'CameraAccessDeniedWithoutPrompt' => CameraFailureKind.permissionPermanent,
      'CameraAccessRestricted' => CameraFailureKind.permissionRestricted,
      'CameraInUse' || 'cameraInUse' || 'CameraAccess' || 'ERROR_CAMERA_IN_USE' || 'MaxCamerasInUse' => CameraFailureKind.inUse,
      _ => CameraFailureKind.initialization,
    };
  }

  @override
  Future<void> initialize({bool requestPermission = true}) async {
    await close();
    try {
      final permission = await _permissions.check(request: requestPermission);
      if (permission != CameraPermission.granted) throw CameraFailure(switch (permission) {
        CameraPermission.permanentlyDenied => CameraFailureKind.permissionPermanent,
        CameraPermission.restricted => CameraFailureKind.permissionRestricted,
        _ => CameraFailureKind.permissionDenied,
      });
      final cameras = await _cameras();
      final rear = cameras.where((camera) => camera.lensDirection == CameraLensDirection.back).firstOrNull;
      if (rear == null) throw const CameraFailure(CameraFailureKind.unavailable);
      final controller = _factory(rear);
      _controller = controller;
      await controller.initialize();
      controller.addListener(_cameraChanged);
      // Some back cameras have no flash. Unsupported controls are disabled;
      // they never make the otherwise usable camera initialization fail.
      try {
        await controller.setFlashMode(FlashMode.auto);
        await controller.setFlashMode(FlashMode.off);
        _flashSupported = true;
      } on CameraException { _flashSupported = false; }
    } catch (error) {
      await close();
      throw CameraFailure(classify(error));
    }
  }

  void _cameraChanged() {
    final controller = _controller;
    if (controller != null && controller.value.hasError && !_errors.isClosed) {
      _errors.add(CameraFailureKind.inUse);
    }
  }

  @override
  Widget buildPreview() => CameraPreview(_controller!);

  @override
  Future<CameraPhoto> takePhoto() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || controller.value.isTakingPicture) throw const CameraFailure(CameraFailureKind.capture);
    try {
      if (controller.value.isStreamingImages) await controller.stopImageStream();
      final orientation = controller.value.deviceOrientation;
      await controller.lockCaptureOrientation(orientation);
      final photo = await controller.takePicture();
      return CameraPhoto(File(photo.path), CaptureMetadata(cameraName: controller.description.name,
        sensorOrientation: controller.description.sensorOrientation, deviceOrientation: orientation.name,
        capturedAt: DateTime.now().toUtc(), flashMode: controller.value.flashMode.name, exposureMode: controller.value.exposureMode.name));
    } on CameraException { throw const CameraFailure(CameraFailureKind.capture); }
    finally {
      if (controller.value.isInitialized) {
        try { await controller.unlockCaptureOrientation(); } on CameraException { /* Closing camera will also release the lock. */ }
      }
    }
  }

  @override
  Future<bool> setFlash(bool enabled) async {
    if (!flashSupported || _controller == null) return false;
    try { await _controller!.setFlashMode(enabled ? FlashMode.always : FlashMode.off); return true; }
    on CameraException { _flashSupported = false; return false; }
  }
  @override
  Future<bool> focus(Offset normalizedPoint) async {
    if (!focusSupported || _controller == null) return false;
    try {
      final point = Offset(normalizedPoint.dx.clamp(0, 1), normalizedPoint.dy.clamp(0, 1));
      await _controller!.setFocusMode(FocusMode.auto);
      await _controller!.setFocusPoint(point);
      return true;
    } on CameraException { return false; }
  }
  @override
  Future<bool> openSettings() => _permissions.openSettings();

  @override
  Future<void> startFrames(CaptureFrameProcessor processor, CaptureView view, void Function(FrameReadiness) onResult) async {
    final controller = _controller;
    if (controller == null) return;
    final generation = ++_streamGeneration;
    var lastFrame = DateTime.fromMillisecondsSinceEpoch(0);
    await controller.startImageStream((image) async {
      final now = DateTime.now();
      if (_processing || now.difference(lastFrame).inMilliseconds < 150 || generation != _streamGeneration) return;
      _processing = true;
      lastFrame = now;
      try {
        final result = await processor.process(CaptureFrame(width: image.width, height: image.height, format: image.format.group.name,
          planes: [for (final plane in image.planes) CapturePlane(bytes: Uint8List.fromList(plane.bytes), bytesPerRow: plane.bytesPerRow, bytesPerPixel: plane.bytesPerPixel)],
          sensorOrientation: controller.description.sensorOrientation, deviceOrientation: controller.value.deviceOrientation.name, receivedAt: now.toUtc(), view: view));
        if (generation == _streamGeneration) onResult(result);
      } catch (_) { if (generation == _streamGeneration) onResult(FrameReadiness.unavailable); }
      finally { _processing = false; }
    });
  }

  @override
  Future<void> close() async {
    ++_streamGeneration;
    final controller = _controller;
    _controller = null;
    _flashSupported = false;
    if (controller != null) {
      controller.removeListener(_cameraChanged);
      await controller.dispose();
    }
  }
  @override
  Future<void> dispose() async { await close(); await _errors.close(); }
}

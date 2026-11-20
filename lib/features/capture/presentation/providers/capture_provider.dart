import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/database_provider.dart';
import '../../../../core/storage/image_storage_service.dart';
import '../../data/camera_service.dart';
import '../../data/image_quality_service.dart';
import '../../domain/capture_session.dart';
import '../../domain/frame_processor.dart';

final cameraServiceProvider = Provider<CameraService>((ref) => DeviceCameraService());
final imageQualityServiceProvider = Provider<ImageQualityService>((ref) => const OfflineImageQualityService());
final captureFrameProcessorProvider = Provider<CaptureFrameProcessor?>((ref) => null);
final captureProvider = NotifierProvider<CaptureController, CaptureState>(CaptureController.new);

/// Serializes native camera work. Epochs invalidate results from a camera or
/// permission dialog that completed after navigation/background/disposal.
class CaptureController extends Notifier<CaptureState> with WidgetsBindingObserver {
  late CameraService _camera;
  late ImageStorageService _images;
  late ImageQualityService _quality;
  late StreamSubscription<CameraFailureKind> _errors;
  Future<void> _tail = Future.value();
  bool _alive = true;
  bool _routeActive = false;
  bool _foreground = true;
  int _epoch = 0;
  FrameReadiness _readiness = FrameReadiness.unavailable;
  FrameReadiness get readiness => _readiness;

  @override
  CaptureState build() {
    _camera = ref.read(cameraServiceProvider);
    _images = ref.read(imageStorageProvider);
    _quality = ref.read(imageQualityServiceProvider);
    WidgetsBinding.instance.addObserver(this);
    _errors = _camera.errors.listen((failure) {
      if (!_alive || state.phase != CameraPhase.preview) return;
      final epoch = ++_epoch;
      unawaited(_enqueue(() async {
        await _camera.close();
        if (_alive && epoch == _epoch) state = state.copyWith(phase: CameraPhase.failed, failure: failure);
      }));
    });
    ref.onDispose(() {
      _alive = false;
      ++_epoch;
      WidgetsBinding.instance.removeObserver(this);
      unawaited(_errors.cancel());
      unawaited(_tail.then((_) => _camera.dispose()).catchError((Object _) {}));
    });
    return const CaptureState();
  }

  Future<T> _enqueue<T>(Future<T> Function() operation) {
    final next = _tail.then((_) => operation());
    _tail = next.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return next;
  }

  Future<void> start(CaptureView view, {bool requestPermission = true}) {
    if (!kDebugMode) {
      state = state.copyWith(phase: CameraPhase.failed, failure: CameraFailureKind.sandboxDisabled);
      return Future.value();
    }
    _routeActive = true;
    final epoch = ++_epoch;
    state = state.copyWith(view: view, phase: CameraPhase.initializing, clearFailure: true, controlUnavailable: false);
    return _enqueue(() => _initialize(epoch, view, requestPermission));
  }

  Future<void> _initialize(int epoch, CaptureView view, bool requestPermission) async {
    if (!_alive || epoch != _epoch || !_routeActive) return;
    if (!_foreground) { state = state.copyWith(phase: CameraPhase.paused); return; }
    try {
      if (state.session == null) {
        await _images.cleanTemporaryCaptures();
        if (!_alive || epoch != _epoch) return;
        state = state.copyWith(session: CaptureSession(id: const Uuid().v4(), startedAt: DateTime.now().toUtc()));
      }
      await _camera.initialize(requestPermission: requestPermission);
      if (!_alive || epoch != _epoch || !_foreground || !_routeActive) { await _camera.close(); return; }
      final processor = ref.read(captureFrameProcessorProvider);
      if (processor != null) await _camera.startFrames(processor, view, (readiness) { if (_alive && epoch == _epoch) _readiness = readiness; });
      if (!_alive || epoch != _epoch) { await _camera.close(); return; }
      state = state.copyWith(phase: CameraPhase.preview, clearFailure: true, flashOn: false, flashSupported: _camera.flashSupported, focusSupported: _camera.focusSupported);
    } catch (error) {
      if (_alive && epoch == _epoch) state = state.copyWith(phase: CameraPhase.failed, failure: error is ImageStorageException || error is FileSystemException ? CameraFailureKind.storage : DeviceCameraService.classify(error));
    }
  }

  Future<bool> capture() {
    if (!kDebugMode || state.phase != CameraPhase.preview || state.photo != null || state.session == null) return Future.value(false);
    final epoch = _epoch;
    final view = state.view;
    final session = state.session!;
    state = state.copyWith(phase: CameraPhase.capturing, clearFailure: true);
    return _enqueue(() async {
      CameraPhoto? output;
      File? adopted;
      try {
        output = await _camera.takePhoto();
        if (!_alive || epoch != _epoch) { await _images.discardCameraOutput(output.file); return false; }
        adopted = await _images.adoptTemporaryCapture(session.id, view.name, output.file);
        await _camera.close();
        final report = await _quality.inspect(adopted.path);
        if (!_alive || epoch != _epoch) { await _images.discardTemporaryCapture(session.id, view.name); return false; }
        state = state.copyWith(phase: CameraPhase.review, session: session.withPhoto(view,
          TemporaryCapture(path: adopted.path, view: view, metadata: output.metadata, quality: report)));
        return true;
      } catch (error) {
        try {
          if (adopted != null) await _images.discardTemporaryCapture(session.id, view.name);
          else if (output != null) await _images.discardCameraOutput(output.file);
        } catch (_) { /* Dedicated cache is cleaned on the next new session. */ }
        try { await _camera.close(); } catch (_) { /* Error remains visible below. */ }
        if (_alive && epoch == _epoch) state = state.copyWith(phase: CameraPhase.failed,
          failure: error is CameraFailure ? error.kind : CameraFailureKind.storage);
        return false;
      }
    });
  }

  Future<void> leaveCamera(CaptureView view) {
    if (!_alive || state.view != view) return Future.value();
    _routeActive = false;
    final epoch = ++_epoch;
    return _enqueue(() async {
      await _camera.close();
      if (_alive && epoch == _epoch) state = state.copyWith(phase: CameraPhase.paused);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycle) {
    _foreground = lifecycle == AppLifecycleState.resumed;
    if (!_alive || !_routeActive) return;
    if (_foreground) {
      unawaited(start(state.view, requestPermission: false));
    } else {
      final epoch = ++_epoch;
      unawaited(_enqueue(() async {
        await _camera.close();
        if (_alive && epoch == _epoch) state = state.copyWith(phase: CameraPhase.paused);
      }));
    }
  }

  Future<bool> discard(CaptureView view) => _enqueue(() async {
    final session = state.session;
    if (session == null) return true;
    try {
      await _images.discardTemporaryCapture(session.id, view.name);
      if (_alive) state = state.copyWith(session: session.withPhoto(view, null), phase: CameraPhase.idle, clearFailure: true);
      return true;
    } catch (_) {
      if (_alive) state = state.copyWith(failure: CameraFailureKind.storage);
      return false;
    }
  });

  Future<bool> discardSession() {
    _routeActive = false;
    ++_epoch;
    return _enqueue(() async {
      try {
        await _camera.close();
        final session = state.session;
        if (session != null) await _images.discardTemporarySession(session.id);
        if (_alive) state = const CaptureState();
        return true;
      } catch (_) { if (_alive) state = state.copyWith(failure: CameraFailureKind.storage); return false; }
    });
  }

  Future<void> toggleFlash() => _enqueue(() async {
    if (!_alive || state.phase != CameraPhase.preview) return;
    final enabled = !state.flashOn;
    final success = await _camera.setFlash(enabled);
    if (_alive) state = state.copyWith(flashOn: success ? enabled : false, flashSupported: _camera.flashSupported, controlUnavailable: !success);
  });

  Future<void> focus(Offset point) => _enqueue(() async {
    if (!_alive || state.phase != CameraPhase.preview) return;
    final success = await _camera.focus(point);
    if (_alive) state = state.copyWith(controlUnavailable: !success);
  });

  Future<bool> openSettings() => _camera.openSettings();
}

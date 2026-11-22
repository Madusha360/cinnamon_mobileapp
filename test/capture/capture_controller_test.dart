import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:quillgrade_mobile/core/database/database_provider.dart';
import 'package:quillgrade_mobile/features/capture/domain/capture_session.dart';
import 'package:quillgrade_mobile/features/capture/presentation/providers/capture_provider.dart';

import '../support/camera_fixture.dart';
import '../support/storage_fixture.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late StorageFixture f;
  late FakeCameraService camera;
  late FakeQualityService quality;
  late ProviderContainer container;
  late CaptureController controller;
  setUp(() async {
    f = await StorageFixture.create();
    camera = FakeCameraService();
    quality = FakeQualityService();
    for (final view in ['end', 'side']) {
      final file = File(p.join(f.directory.path, 'camera_cache', '$view.jpg'));
      await file.parent.create(recursive: true);
      camera.outputs.add(await file.writeAsBytes(await f.end.readAsBytes()));
    }
    container = ProviderContainer(
      overrides: [
        cameraServiceProvider.overrideWithValue(camera),
        imageStorageProvider.overrideWithValue(f.images),
        imageQualityServiceProvider.overrideWithValue(quality),
      ],
    );
    controller = container.read(captureProvider.notifier);
  });
  tearDown(() async {
    container.dispose();
    await Future<void>.delayed(Duration.zero);
    await f.dispose();
  });

  test('initializing, preview, temporary capture and review preserve both views in one session', () async {
    camera.initializeGate = Completer<void>();
    final startup = controller.start(CaptureView.end);
    expect(container.read(captureProvider).phase, CameraPhase.initializing);
    camera.initializeGate!.complete();
    await startup;
    expect(container.read(captureProvider).phase, CameraPhase.preview);
    expect(camera.streamsStarted, 0);
    expect(controller.readiness.modelAvailable, isFalse);
    final sessionId = container.read(captureProvider).session!.id;
    final capture = controller.capture();
    expect(container.read(captureProvider).phase, CameraPhase.capturing);
    expect(await controller.capture(), isFalse);
    expect(await capture, isTrue);
    var state = container.read(captureProvider);
    expect(state.phase, CameraPhase.review);
    expect(state.photo!.productionEligible, isFalse);
    expect(await File(state.photo!.path).exists(), isTrue);
    expect(camera.isOpen, isFalse);
    await controller.start(CaptureView.side);
    expect(await controller.capture(), isTrue);
    state = container.read(captureProvider);
    expect(state.session!.id, sessionId);
    expect(state.session!.photos.length, 2);
    expect(await f.repository.getAllSamples(), isEmpty);
    expect(await f.db.select(f.db.syncJobs).get(), isEmpty);
  });

  test(
    'permission denial can be retried without creating a production sample',
    () async {
      camera.initializeFailure = CameraFailureKind.permissionPermanent;
      await controller.start(CaptureView.end);
      expect(
        container.read(captureProvider).failure,
        CameraFailureKind.permissionPermanent,
      );
      expect(await controller.openSettings(), isTrue);
      camera.initializeFailure = null;
      await controller.start(CaptureView.end);
      expect(container.read(captureProvider).phase, CameraPhase.preview);
      expect(await f.repository.getAllSamples(), isEmpty);
    },
  );

  test('retake and discard remove actual temporary files without touching originals', () async {
    await controller.start(CaptureView.end);
    await controller.capture();
    final file = File(container.read(captureProvider).photo!.path);
    expect(await controller.discard(CaptureView.end), isTrue);
    expect(await file.exists(), isFalse);
    await controller.start(CaptureView.side);
    await controller.capture();
    final side = File(container.read(captureProvider).photo!.path);
    expect(await controller.discardSession(), isTrue);
    expect(await side.exists(), isFalse);
    expect(container.read(captureProvider).session, isNull);
    expect(await f.end.exists(), isTrue);
  });

  test('background closes camera and foreground resumes only an active camera route', () async {
    await controller.start(CaptureView.end);
    controller.didChangeAppLifecycleState(AppLifecycleState.inactive);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(camera.isOpen, isFalse);
    expect(container.read(captureProvider).phase, CameraPhase.paused);
    controller.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(camera.isOpen, isTrue);
    await controller.leaveCamera(CaptureView.end);
    final count = camera.initializations;
    controller.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(camera.initializations, count);
    expect(camera.isOpen, isFalse);
  });

  test(
    'backgrounding during initialization cannot publish a stale ready camera',
    () async {
      camera.initializeGate = Completer<void>();
      final startup = controller.start(CaptureView.end);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      controller.didChangeAppLifecycleState(AppLifecycleState.inactive);
      camera.initializeGate!.complete();
      await startup;
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(camera.isOpen, isFalse);
      expect(container.read(captureProvider).phase, CameraPhase.paused);
    },
  );

  test(
    'navigation during image analysis discards the late temporary capture',
    () async {
      await controller.start(CaptureView.end);
      quality.gate = Completer<void>();
      final shot = controller.capture();
      await quality.entered.future;
      final leaving = controller.leaveCamera(CaptureView.end);
      quality.gate!.complete();
      expect(await shot, isFalse);
      await leaving;
      expect(container.read(captureProvider).session!.photos, isEmpty);
      final root = Directory(
        p.join(
          f.directory.path,
          'camera_cache',
          'quillgrade',
          'capture_sandbox',
        ),
      );
      expect(
        (await root.list(recursive: true).toList()).whereType<File>(),
        isEmpty,
      );
    },
  );

  test('unsupported controls and runtime failures are visible without accepting a photo', () async {
    await controller.start(CaptureView.side);
    camera.allowControls = false;
    await controller.toggleFlash();
    expect(container.read(captureProvider).controlUnavailable, isTrue);
    await controller.focus(const Offset(0.5, 0.5));
    expect(camera.lastFocus, const Offset(0.5, 0.5));
    camera.events.add(CameraFailureKind.inUse);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(container.read(captureProvider).failure, CameraFailureKind.inUse);
    expect(await controller.capture(), isFalse);
  });

  test(
    'disposing during initialization releases the late native controller',
    () async {
      camera.initializeGate = Completer<void>();
      final startup = controller.start(CaptureView.end);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      container.dispose();
      camera.initializeGate!.complete();
      await startup;
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(camera.isOpen, isFalse);
      expect(camera.disposed, isTrue);
    },
  );
  test(
    'native disposal failure becomes a recoverable state on backgrounding',
    () async {
      await controller.start(CaptureView.end);
      camera.closeFailure = CameraFailureKind.inUse;
      controller.didChangeAppLifecycleState(AppLifecycleState.inactive);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(container.read(captureProvider).phase, CameraPhase.failed);
      expect(container.read(captureProvider).failure, CameraFailureKind.inUse);
      camera.closeFailure = null;
      controller.didChangeAppLifecycleState(AppLifecycleState.resumed);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(container.read(captureProvider).phase, CameraPhase.preview);
    },
  );
}

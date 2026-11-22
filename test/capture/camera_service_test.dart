import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quillgrade_mobile/features/capture/data/camera_service.dart';
import 'package:quillgrade_mobile/features/capture/domain/capture_session.dart';

class _Permission implements CameraPermissionGateway {
  _Permission(this.result);
  final CameraPermission result;
  bool requested = false;
  @override
  Future<CameraPermission> check({required bool request}) async {
    requested = request;
    return result;
  }

  @override
  Future<bool> openSettings() async => true;
}

class _Controller extends CameraController {
  _Controller(CameraDescription description)
    : super(description, ResolutionPreset.max, enableAudio: false);
  bool closed = false, locked = false, supportsFlash = true;
  Offset? focusPoint;
  @override
  Future<void> initialize() async {
    value = value.copyWith(
      isInitialized: true,
      previewSize: const Size(1920, 1080),
      focusPointSupported: true,
    );
  }

  @override
  Future<void> setFlashMode(FlashMode mode) async {
    if (!supportsFlash) throw CameraException('FlashUnsupported', 'Fixture');
    value = value.copyWith(flashMode: mode);
  }

  @override
  Future<void> setFocusMode(FocusMode mode) async {}
  @override
  Future<void> setFocusPoint(Offset? point) async {
    focusPoint = point;
  }

  @override
  Future<void> lockCaptureOrientation([DeviceOrientation? orientation]) async {
    locked = true;
  }

  @override
  Future<void> unlockCaptureOrientation() async {
    locked = false;
  }

  @override
  Future<XFile> takePicture() async {
    expect(locked, isTrue);
    return XFile('isolated-photo.jpg');
  }

  @override
  Future<void> dispose() async {
    closed = true;
    await super.dispose();
  }
}

void main() {
  const rear = CameraDescription(
    name: 'back',
    lensDirection: CameraLensDirection.back,
    sensorOrientation: 90,
  );
  const front = CameraDescription(
    name: 'front',
    lensDirection: CameraLensDirection.front,
    sensorOrientation: 270,
  );

  for (final item in [
    (CameraPermission.denied, CameraFailureKind.permissionDenied),
    (CameraPermission.permanentlyDenied, CameraFailureKind.permissionPermanent),
    (CameraPermission.restricted, CameraFailureKind.permissionRestricted),
  ]) {
    test(
      'permission ${item.$1.name} stops before camera enumeration',
      () async {
        final service = DeviceCameraService(
          permissions: _Permission(item.$1),
          cameras: () async {
            fail('Must not enumerate without permission');
          },
        );
        await expectLater(
          service.initialize(),
          throwsA(isA<CameraFailure>().having((e) => e.kind, 'kind', item.$2)),
        );
        expect(await service.openSettings(), isTrue);
        await service.dispose();
      },
    );
  }
  test(
    'rear camera is required, with no fallback to an unrelated front view',
    () async {
      final service = DeviceCameraService(
        permissions: _Permission(CameraPermission.granted),
        cameras: () async => [front],
      );
      await expectLater(
        service.initialize(),
        throwsA(
          isA<CameraFailure>().having(
            (e) => e.kind,
            'kind',
            CameraFailureKind.unavailable,
          ),
        ),
      );
      await service.dispose();
    },
  );
  test(
    'rear selection, focus, flash, orientation metadata and native disposal',
    () async {
      late _Controller native;
      final permission = _Permission(CameraPermission.granted);
      final service = DeviceCameraService(
        permissions: permission,
        cameras: () async => [front, rear],
        controllerFactory: (description) => native = _Controller(description),
      );
      await service.initialize();
      expect(permission.requested, isTrue);
      expect(native.description, rear);
      expect(native.enableAudio, isFalse);
      expect(service.flashSupported, isTrue);
      expect(await service.setFlash(true), isTrue);
      expect(await service.focus(const Offset(0.25, 0.75)), isTrue);
      expect(native.focusPoint, const Offset(0.25, 0.75));
      final photo = await service.takePhoto();
      expect(photo.metadata.cameraName, 'back');
      expect(photo.metadata.sensorOrientation, 90);
      expect(photo.metadata.deviceOrientation, 'portraitUp');
      expect(native.locked, isFalse);
      await service.dispose();
      expect(native.closed, isTrue);
    },
  );
  test('unsupported flash does not prevent a usable camera', () async {
    final service = DeviceCameraService(
      permissions: _Permission(CameraPermission.granted),
      cameras: () async => [rear],
      controllerFactory: (description) =>
          _Controller(description)..supportsFlash = false,
    );
    await service.initialize(requestPermission: false);
    expect(service.flashSupported, isFalse);
    expect(service.focusSupported, isTrue);
    expect(await service.setFlash(true), isFalse);
    await service.dispose();
  });
  test(
    'native busy and initialization errors have distinct recoverable states',
    () {
      expect(
        DeviceCameraService.classify(CameraException('CameraInUse', 'Fixture')),
        CameraFailureKind.inUse,
      );
      expect(
        DeviceCameraService.classify(CameraException('Unknown', 'Fixture')),
        CameraFailureKind.initialization,
      );
    },
  );
}

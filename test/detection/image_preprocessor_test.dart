import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:quillgrade_mobile/features/capture/domain/capture_session.dart';
import 'package:quillgrade_mobile/features/capture/domain/frame_processor.dart';
import 'package:quillgrade_mobile/features/cinnamon_detection/data/image_preprocessor.dart';
import 'package:quillgrade_mobile/features/cinnamon_detection/presentation/widgets/detection_overlay.dart';

import '../support/detection_fixture.dart';

void main() {
  final spec = fixtureSpecification();
  const processor = ImagePreprocessor();
  CaptureFrame frame(
    String format,
    List<CapturePlane> planes, {
    int sensor = 0,
    String device = 'portraitUp',
  }) => CaptureFrame(
    width: 16,
    height: 16,
    format: format,
    planes: planes,
    sensorOrientation: sensor,
    deviceOrientation: device,
    receivedAt: DateTime.utc(2026, 11, 22),
    view: CaptureView.end,
  );
  test('BGRA planes respect row padding and RGB channel ordering', () async {
    final bytes = Uint8List(16 * 72);
    for (var y = 0; y < 16; y++) {
      for (var x = 0; x < 16; x++) {
        final i = y * 72 + x * 4;
        bytes[i] = 20;
        bytes[i + 1] = 80;
        bytes[i + 2] = 180;
        bytes[i + 3] = 255;
      }
    }
    final result = await processor.frame(
      frame('bgra8888', [
        CapturePlane(bytes: bytes, bytesPerRow: 72, bytesPerPixel: 4),
      ]),
      spec.preprocessing,
      spec.policy.previewQuality,
    );
    expect(result.tensor[0], closeTo(180 / 255, .00001));
    expect(result.tensor[1], closeTo(80 / 255, .00001));
    expect(result.tensor[2], closeTo(20 / 255, .00001));
  });
  test('YUV planes handle independent row and pixel strides', () async {
    final y = Uint8List(20 * 16)..fillRange(0, 20 * 16, 100);
    final uv = Uint8List(18 * 8)..fillRange(0, 18 * 8, 128);
    final result = await processor.frame(
      frame('yuv420', [
        CapturePlane(bytes: y, bytesPerRow: 20, bytesPerPixel: 1),
        CapturePlane(bytes: uv, bytesPerRow: 18, bytesPerPixel: 2),
        CapturePlane(bytes: uv, bytesPerRow: 18, bytesPerPixel: 2),
      ]),
      spec.preprocessing,
      spec.policy.previewQuality,
    );
    expect(result.tensor.take(3), everyElement(closeTo(100 / 255, .00001)));
  });
  test(
    'rear rotation is explicit and unsupported/truncated planes fail closed',
    () async {
      expect(rearFrameRotation(frame('yuv420', [], sensor: 90)), 90);
      expect(
        rearFrameRotation(
          frame('yuv420', [], sensor: 90, device: 'landscapeLeft'),
        ),
        0,
      );
      expect(
        rearFrameRotation(
          frame('yuv420', [], sensor: 90, device: 'landscapeRight'),
        ),
        180,
      );
      await expectLater(
        processor.frame(
          frame('nv21', []),
          spec.preprocessing,
          spec.policy.previewQuality,
        ),
        throwsFormatException,
      );
      await expectLater(
        processor.frame(
          frame('bgra8888', [
            CapturePlane(bytes: Uint8List(4), bytesPerRow: 64),
          ]),
          spec.preprocessing,
          spec.policy.previewQuality,
        ),
        throwsFormatException,
      );
    },
  );
  test(
    'letterbox inversion and preview mapping preserve rectangular coordinates',
    () {
      final transform = LetterboxTransform(400, 200, 320, 320);
      expect(transform.top, 80);
      expect(transform.left, 0);
      final box = transform.toUpright(
        const Rect.fromLTRB(.25, .375, .75, .625),
      );
      expect(box, const Rect.fromLTRB(.25, .25, .75, .75));
      expect(
        detectionPreviewRect(box, const Size(400, 200)),
        const Rect.fromLTRB(100, 50, 300, 150),
      );
    },
  );
  test('empty/corrupt originals are rejected and EXIF image bytes remain unchanged', () async {
    final directory = await Directory.systemTemp.createTemp(
      'quillgrade_preprocess_',
    );
    addTearDown(() async {
      final target = await directory.resolveSymbolicLinks();
      final root = await Directory.systemTemp.resolveSymbolicLinks();
      if (!target.startsWith(
        '$root${Platform.pathSeparator}quillgrade_preprocess_',
      )) {
        throw StateError('Unsafe fixture cleanup');
      }
      await directory.delete(recursive: true);
    });
    final file = File('${directory.path}/original.jpg');
    await file.writeAsBytes([]);
    await expectLater(
      processor.file(file.path, spec.preprocessing, spec.policy.stillQuality),
      throwsFormatException,
    );
    final image = img.Image(width: 32, height: 16);
    for (final pixel in image) {
      pixel.setRgb(pixel.x < 16 ? 200 : 30, 80, 60);
    }
    image.exif.imageIfd.orientation = 6;
    final bytes = img.encodeJpg(image);
    await file.writeAsBytes(bytes);
    final result = await processor.file(
      file.path,
      spec.preprocessing,
      spec.policy.stillQuality,
    );
    expect(result.transform.source, const Size(16, 32));
    expect(await file.readAsBytes(), bytes);
  });
}

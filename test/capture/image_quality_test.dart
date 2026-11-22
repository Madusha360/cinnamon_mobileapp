import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:quillgrade_mobile/features/capture/data/image_quality_service.dart';
import 'package:quillgrade_mobile/features/capture/domain/capture_session.dart';

img.Image checker() {
  final image = img.Image(width: 1200, height: 1000);
  for (final pixel in image) {
    final value = ((pixel.x ~/ 24 + pixel.y ~/ 24) % 2 == 0) ? 60 : 190;
    pixel.setRgb(value, value, value);
  }
  return image;
}

void main() {
  test(
    'sharp well-lit fixture has no warnings but never validates cinnamon',
    () {
      final report = inspectCaptureBytes(img.encodeJpg(checker()));
      expect(report.issues, isEmpty);
      expect(report.width, 1200);
      expect(report.height, 1000);
      expect(report.laplacianVariance, greaterThan(75));
      expect(report.validatesCinnamon, isFalse);
    },
  );
  test('blurred fixture is detected by reduced Laplacian variance', () {
    final sharp = inspectCaptureBytes(img.encodeJpg(checker()));
    final soft = inspectCaptureBytes(
      img.encodeJpg(img.gaussianBlur(checker(), radius: 24)),
    );
    expect(soft.laplacianVariance, lessThan(sharp.laplacianVariance!));
    expect(soft.issues, contains(QualityIssue.blur));
  });
  test('dark and clipped bright images produce useful lighting warnings', () {
    final dark = img.Image(width: 1024, height: 1024);
    final bright = img.fill(
      img.Image(width: 1024, height: 1024),
      color: img.ColorRgb8(255, 255, 255),
    );
    expect(
      inspectCaptureBytes(img.encodePng(dark)).issues,
      contains(QualityIssue.dark),
    );
    expect(
      inspectCaptureBytes(img.encodePng(bright)).issues,
      contains(QualityIssue.overexposed),
    );
  });
  test('low resolution is independent of identity and sharpness', () {
    final report = inspectCaptureBytes(
      img.encodeJpg(img.copyResize(checker(), width: 160)),
    );
    expect(report.issues, contains(QualityIssue.resolution));
    expect(report.validatesCinnamon, isFalse);
  });
  test('empty, corrupt and missing files fail safely', () async {
    for (final bytes in [
      Uint8List(0),
      Uint8List.fromList([1, 3, 5, 7]),
    ]) {
      expect(inspectCaptureBytes(bytes).issues, [QualityIssue.invalidFile]);
    }
    final missing = File(
      '${Directory.systemTemp.path}/quillgrade_missing_quality_fixture.jpg',
    );
    expect((await inspectCaptureFile(missing.path)).issues, [
      QualityIssue.invalidFile,
    ]);
  });
  test('EXIF rotation is applied only to the review preview', () {
    final exif = img.ExifData()..imageIfd.orientation = 6;
    final bytes = img.injectJpgExif(img.encodeJpg(checker()), exif)!;
    final original = Uint8List.fromList(bytes);
    final report = inspectCaptureBytes(bytes);
    expect(report.exifOrientation, 6);
    expect(report.width, 1200);
    expect(report.height, 1000);
    final preview = img.decodeJpg(report.previewBytes!)!;
    expect(preview.width, 1000);
    expect(preview.height, 1200);
    expect(bytes, original);
  });
}

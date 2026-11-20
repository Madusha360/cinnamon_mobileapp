import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

import '../domain/capture_session.dart';

abstract interface class ImageQualityService {
  Future<ImageQualityReport> inspect(String path);
}

class OfflineImageQualityService implements ImageQualityService {
  const OfflineImageQualityService();
  @override
  Future<ImageQualityReport> inspect(String path) => compute(inspectCaptureFile, path);
}

/// Runs off the UI isolate. Limits are resource bounds, not grading thresholds.
Future<ImageQualityReport> inspectCaptureFile(String path) async {
  try {
    final file = File(path);
    final length = await file.length();
    if (length == 0 || length > 40 * 1024 * 1024) return ImageQualityReport.invalid;
    return inspectCaptureBytes(await file.readAsBytes());
  } catch (_) { return ImageQualityReport.invalid; }
}

ImageQualityReport inspectCaptureBytes(Uint8List bytes) {
  try {
    if (bytes.isEmpty || bytes.length > 40 * 1024 * 1024) return ImageQualityReport.invalid;
    final decoder = img.findDecoderForData(bytes);
    final info = decoder?.startDecode(bytes);
    if (info == null || info.width <= 0 || info.height <= 0 || info.width * info.height > 50000000) return ImageQualityReport.invalid;
    final orientation = decoder is img.JpegDecoder ? img.decodeJpgExif(bytes)?.imageIfd.orientation ?? 1 : 1;
    // JPEG decoding already applies EXIF orientation. Reduced native decode
    // bounds inspection memory while original dimensions/bytes are retained.
    final longest = math.max(info.width, info.height);
    final scale = longest > 8192 ? 8 : longest > 4096 ? 4 : longest > 2048 ? 2 : 1;
    final decoded = decoder is img.JpegDecoder ? img.JpegDecoder(maxPixels: 50000000, scale: scale).decode(bytes) : decoder!.decode(bytes);
    if (decoded == null) return ImageQualityReport.invalid;
    final oriented = img.bakeOrientation(decoded);
    final preview = math.max(oriented.width, oriented.height) > 2048
      ? img.copyResize(oriented, width: oriented.width >= oriented.height ? 2048 : null, height: oriented.height > oriented.width ? 2048 : null)
      : oriented;
    final image = img.copyResize(oriented, width: oriented.width >= oriented.height ? math.min(oriented.width, 512) : null,
      height: oriented.height > oriented.width ? math.min(oriented.height, 512) : null, interpolation: img.Interpolation.average);
    final luma = Float64List(image.width * image.height);
    var total = 0.0;
    var clipped = 0;
    for (final pixel in image) {
      final value = 255 * (0.2126 * pixel.rNormalized + 0.7152 * pixel.gNormalized + 0.0722 * pixel.bNormalized);
      luma[pixel.y * image.width + pixel.x] = value;
      total += value;
      if (value >= 245) clipped++;
    }
    var lapTotal = 0.0, lapSquares = 0.0;
    var count = 0;
    // Center region reduces sharp background/marker edges masking a soft quill.
    final xStart = math.max(1, image.width ~/ 4), xEnd = math.min(image.width - 1, image.width * 3 ~/ 4);
    final yStart = math.max(1, image.height ~/ 4), yEnd = math.min(image.height - 1, image.height * 3 ~/ 4);
    for (var y = yStart; y < yEnd; y++) {
      for (var x = xStart; x < xEnd; x++) {
        final i = y * image.width + x;
        final lap = luma[i-1] + luma[i+1] + luma[i-image.width] + luma[i+image.width] - 4*luma[i];
        lapTotal += lap; lapSquares += lap * lap; count++;
      }
    }
    final mean = total / luma.length;
    final variance = count == 0 ? 0.0 : math.max(0.0, lapSquares / count - math.pow(lapTotal / count, 2));
    final issues = <QualityIssue>[
      if (math.min(info.width, info.height) < 720 || info.width * info.height < 1000000) QualityIssue.resolution,
      if (mean < 40) QualityIssue.dark,
      if (clipped / luma.length > 0.6) QualityIssue.overexposed,
      if (variance < 75) QualityIssue.blur,
    ];
    return ImageQualityReport(width: info.width, height: info.height, exifOrientation: orientation,
      issues: List.unmodifiable(issues), meanLuminance: mean, laplacianVariance: variance,
      previewBytes: img.encodeJpg(preview, quality: 92));
  } catch (_) { return ImageQualityReport.invalid; }
}

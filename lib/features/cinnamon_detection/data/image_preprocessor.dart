import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

import '../../capture/data/image_quality_service.dart';
import '../../capture/domain/capture_session.dart';
import '../../capture/domain/frame_processor.dart';

class PreprocessingSpec {
  PreprocessingSpec({
    required this.width,
    required this.height,
    required this.scale,
    required this.offset,
    required this.padding,
  }) {
    if (width < 16 ||
        height < 16 ||
        width > 1024 ||
        height > 1024 ||
        !scale.isFinite ||
        scale <= 0 ||
        !offset.isFinite ||
        padding < 0 ||
        padding > 255) {
      throw const FormatException('Unsupported input preprocessing');
    }
  }
  final int width, height, padding;

  /// RGB float32 NHWC: realValue = channel * scale + offset.
  final double scale, offset;
}

class LetterboxTransform {
  LetterboxTransform(
    int sourceWidth,
    int sourceHeight,
    int inputWidth,
    int inputHeight,
  ) : source = Size(sourceWidth.toDouble(), sourceHeight.toDouble()),
      input = Size(inputWidth.toDouble(), inputHeight.toDouble()),
      resizedWidth = math.max(
        1,
        (sourceWidth *
                math.min(inputWidth / sourceWidth, inputHeight / sourceHeight))
            .round(),
      ),
      resizedHeight = math.max(
        1,
        (sourceHeight *
                math.min(inputWidth / sourceWidth, inputHeight / sourceHeight))
            .round(),
      );
  final Size source, input;
  final int resizedWidth, resizedHeight;
  int get left => (input.width.toInt() - resizedWidth) ~/ 2;
  int get top => (input.height.toInt() - resizedHeight) ~/ 2;
  Rect toUpright(Rect normalizedInputBox) => Rect.fromLTRB(
    ((normalizedInputBox.left * input.width - left) / resizedWidth).clamp(0, 1),
    ((normalizedInputBox.top * input.height - top) / resizedHeight).clamp(0, 1),
    ((normalizedInputBox.right * input.width - left) / resizedWidth).clamp(
      0,
      1,
    ),
    ((normalizedInputBox.bottom * input.height - top) / resizedHeight).clamp(
      0,
      1,
    ),
  );
}

class PreparedDetectionImage {
  const PreparedDetectionImage(this.tensor, this.transform, this.quality);
  final Float32List tensor;
  final LetterboxTransform transform;
  final ImageQualityReport quality;
}

class ImagePreprocessor {
  const ImagePreprocessor();
  Future<PreparedDetectionImage> frame(
    CaptureFrame frame,
    PreprocessingSpec spec,
    QualityThresholds quality,
  ) => compute(_prepareFrame, (frame, spec, quality));
  Future<PreparedDetectionImage> file(
    String path,
    PreprocessingSpec spec,
    QualityThresholds quality,
  ) => compute(_prepareFile, (path, spec, quality));
}

int rearFrameRotation(CaptureFrame frame) {
  final device = switch (frame.deviceOrientation) {
    'portraitUp' => 0,
    'landscapeLeft' => 90,
    'portraitDown' => 180,
    'landscapeRight' => 270,
    _ => throw const FormatException('Unknown camera orientation'),
  };
  if (![0, 90, 180, 270].contains(frame.sensorOrientation)) {
    throw const FormatException('Unsupported sensor orientation');
  }
  return (frame.sensorOrientation - device + 360) % 360;
}

PreparedDetectionImage _prepareFrame(
  (CaptureFrame, PreprocessingSpec, QualityThresholds) request,
) {
  final (frame, spec, thresholds) = request;
  if (frame.width <= 0 ||
      frame.height <= 0 ||
      frame.width * frame.height > 16000000) {
    throw const FormatException('Invalid camera dimensions');
  }
  final image = img.Image(width: frame.width, height: frame.height);
  int read(
    CapturePlane plane,
    int x,
    int y,
    int defaultStride, [
    int component = 0,
  ]) {
    final stride = plane.bytesPerPixel ?? defaultStride;
    if (plane.bytesPerRow <= 0 || stride <= 0) {
      throw const FormatException('Invalid plane strides');
    }
    final index = y * plane.bytesPerRow + x * stride + component;
    if (index < 0 || index >= plane.bytes.length) {
      throw const FormatException('Truncated camera plane');
    }
    return plane.bytes[index];
  }

  for (var y = 0; y < frame.height; y++) {
    for (var x = 0; x < frame.width; x++) {
      if (frame.format == 'bgra8888' && frame.planes.length == 1) {
        final plane = frame.planes.single;
        image.setPixelRgb(
          x,
          y,
          read(plane, x, y, 4, 2),
          read(plane, x, y, 4, 1),
          read(plane, x, y, 4),
        );
      } else if (frame.format == 'yuv420' && frame.planes.length == 3) {
        final luma = read(frame.planes[0], x, y, 1).toDouble();
        final u = read(frame.planes[1], x ~/ 2, y ~/ 2, 1) - 128;
        final v = read(frame.planes[2], x ~/ 2, y ~/ 2, 1) - 128;
        image.setPixelRgb(
          x,
          y,
          (luma + 1.402 * v).round().clamp(0, 255),
          (luma - 0.344136 * u - 0.714136 * v).round().clamp(0, 255),
          (luma + 1.772 * u).round().clamp(0, 255),
        );
      } else {
        throw const FormatException('Unsupported camera pixel format');
      }
    }
  }
  final rotation = rearFrameRotation(frame);
  return _prepare(
    rotation == 0 ? image : img.copyRotate(image, angle: rotation),
    spec,
    thresholds,
  );
}

Future<PreparedDetectionImage> _prepareFile(
  (String, PreprocessingSpec, QualityThresholds) request,
) async {
  final (path, spec, quality) = request;
  final file = File(path);
  final length = await file.length();
  if (length <= 0 || length > 40 * 1024 * 1024) {
    throw const FormatException('Invalid photo size');
  }
  final bytes = await file.readAsBytes();
  final decoder = img.findDecoderForData(bytes);
  final info = decoder?.startDecode(bytes);
  if (info == null ||
      info.width <= 0 ||
      info.height <= 0 ||
      info.width * info.height > 50000000) {
    throw const FormatException('Invalid photo');
  }
  final longest = math.max(info.width, info.height);
  final decoded = decoder is img.JpegDecoder
      ? img.JpegDecoder(
          maxPixels: 50000000,
          scale: longest > 8192
              ? 8
              : longest > 4096
              ? 4
              : longest > 2048
              ? 2
              : 1,
        ).decode(bytes)
      : decoder!.decode(bytes);
  if (decoded == null) throw const FormatException('Photo decoding failed');
  return _prepare(
    img.bakeOrientation(decoded),
    spec,
    quality,
    originalWidth: info.width,
    originalHeight: info.height,
  );
}

PreparedDetectionImage _prepare(
  img.Image image,
  PreprocessingSpec spec,
  QualityThresholds thresholds, {
  int? originalWidth,
  int? originalHeight,
}) {
  final quality = inspectDecodedCapture(
    image,
    width: originalWidth ?? image.width,
    height: originalHeight ?? image.height,
    thresholds: thresholds,
    includePreview: false,
  );
  final transform = LetterboxTransform(
    image.width,
    image.height,
    spec.width,
    spec.height,
  );
  final resized = img.copyResize(
    image,
    width: transform.resizedWidth,
    height: transform.resizedHeight,
    interpolation: img.Interpolation.linear,
  );
  final tensor = Float32List(spec.width * spec.height * 3);
  tensor.fillRange(0, tensor.length, spec.padding * spec.scale + spec.offset);
  for (final pixel in resized) {
    final index =
        ((pixel.y + transform.top) * spec.width + pixel.x + transform.left) * 3;
    tensor[index] = pixel.r * spec.scale + spec.offset;
    tensor[index + 1] = pixel.g * spec.scale + spec.offset;
    tensor[index + 2] = pixel.b * spec.scale + spec.offset;
  }
  return PreparedDetectionImage(tensor, transform, quality);
}

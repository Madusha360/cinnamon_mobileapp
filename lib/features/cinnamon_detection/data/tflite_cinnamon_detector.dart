import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../domain/cinnamon_detector.dart';
import '../domain/detection_result.dart';
import 'model_loader.dart';

/// Deployment seam, NOT an installed TFLite interpreter. Implement using a
/// compatible native runtime only after inspecting and testing the real export.
abstract interface class DetectionTensorRunner {
  List<int> get inputShape;
  List<int> get outputShape;
  String get inputType;
  String get outputType;
  bool get runsOffUiThread;
  Future<Float32List> invoke(Float32List rgbInput);
  Future<void> close();
}

/// Adapter for an explicitly declared canonical output contract. Raw YOLO,
/// quantized outputs and automatic output-shape guessing are not supported.
class TfliteCinnamonDetector implements CinnamonDetector {
  TfliteCinnamonDetector._(this.specification, this._runner);
  static Future<TfliteCinnamonDetector> attach(
    ModelSpecification specification,
    DetectionTensorRunner runner,
  ) async {
    if (!listEquals(runner.inputShape, specification.inputShape) ||
        !listEquals(runner.outputShape, specification.outputShape) ||
        runner.inputType != 'float32' ||
        runner.outputType != 'float32' ||
        !runner.runsOffUiThread) {
      await runner.close();
      throw const FormatException(
        'Native tensor contract does not match reviewed model',
      );
    }
    return TfliteCinnamonDetector._(specification, runner);
  }

  final ModelSpecification specification;
  final DetectionTensorRunner _runner;
  bool _closed = false, _busy = false;
  Future<void>? _running;
  @override
  bool get available => !_closed;
  @override
  String get modelVersion => specification.version;
  @override
  Future<List<DetectionCandidate>> detect(Float32List rgbInput) async {
    if (_closed || _busy) {
      throw StateError('Detector closed or already running');
    }
    if (rgbInput.length != specification.inputShape.reduce((a, b) => a * b) ||
        rgbInput.any((v) => !v.isFinite)) {
      throw const FormatException('Invalid input tensor');
    }
    _busy = true;
    try {
      final invocation = _runner.invoke(rgbInput);
      _running = invocation.then<void>(
        (_) {},
        onError: (Object _, StackTrace _) {},
      );
      final output = await invocation;
      if (_closed) throw StateError('Detector disposed during inference');
      if (output.length != specification.outputRows * 6) {
        throw const FormatException('Invalid output shape');
      }
      final candidates = <DetectionCandidate>[];
      for (var i = 0; i < output.length; i += 6) {
        final row = output.sublist(i, i + 6);
        if (row.any((v) => !v.isFinite)) {
          throw const FormatException('Non-finite model output');
        }
        final confidence = row[4];
        if (confidence < 0 || confidence > 1) {
          throw const FormatException('Invalid confidence');
        }
        if (confidence == 0) continue; // Explicit zero-score padding only.
        final label = row[5].toInt();
        if (row[5] != label ||
            label < 0 ||
            label >= DetectionLabel.values.length) {
          throw const FormatException('Unknown detection class');
        }
        final candidate = DetectionCandidate(
          label: DetectionLabel.values[label],
          confidence: confidence,
          box: Rect.fromLTRB(row[0], row[1], row[2], row[3]),
        );
        if (!candidate.isWellFormed) {
          throw const FormatException('Invalid model bounding box');
        }
        candidates.add(candidate);
      }
      return List.unmodifiable(candidates);
    } finally {
      _busy = false;
    }
  }

  @override
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    await _running;
    await _runner.close();
  }
}

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../capture/domain/capture_session.dart';
import '../domain/detection_policy.dart';
import 'image_preprocessor.dart';

class ModelSpecification {
  ModelSpecification.fromJson(Map<String, dynamic> json)
    : version = json['version'] as String,
      asset = json['asset'] as String,
      digest = json['sha256'] as String,
      preprocessing = PreprocessingSpec(
        width: json['input']['width'] as int,
        height: json['input']['height'] as int,
        scale: (json['input']['scale'] as num).toDouble(),
        offset: (json['input']['offset'] as num).toDouble(),
        padding: json['input']['padding'] as int,
      ),
      outputRows = json['output']['rows'] as int,
      policy = _policy(json['policy'] as Map<String, dynamic>) {
    if (json['schema'] != 1 ||
        version.trim().isEmpty ||
        !RegExp(r'^assets/models/[a-zA-Z0-9_-]+\.tflite$').hasMatch(asset) ||
        !RegExp(r'^[a-f0-9]{64}$').hasMatch(digest) ||
        json['input']['dtype'] != 'float32' ||
        json['input']['layout'] != 'NHWC' ||
        json['input']['color'] != 'RGB' ||
        json['output']['dtype'] != 'float32' ||
        json['output']['layout'] != 'xyxy_score_class_normalized_nms' ||
        outputRows < 1 ||
        outputRows > 10000 ||
        !listEquals(json['labels'] as List?, [
          'cinnamon_quill_end',
          'cinnamon_quill_side',
          'non_cinnamon',
        ])) {
      throw const FormatException('Unsupported or unverified model contract');
    }
  }
  final String version, asset, digest;
  final PreprocessingSpec preprocessing;
  final int outputRows;
  final DetectionPolicy policy;
  List<int> get inputShape => [1, preprocessing.height, preprocessing.width, 3];
  List<int> get outputShape => [1, outputRows, 6];
  static QualityThresholds _quality(Map<String, dynamic> value) =>
      QualityThresholds(
        minimumShortEdge: value['minimum_short_edge'] as int,
        minimumPixels: value['minimum_pixels'] as int,
        minimumLuminance: (value['minimum_luminance'] as num).toDouble(),
        clippedLuminance: (value['clipped_luminance'] as num).toDouble(),
        maximumClippedFraction: (value['maximum_clipped_fraction'] as num)
            .toDouble(),
        minimumLaplacianVariance: (value['minimum_laplacian_variance'] as num)
            .toDouble(),
      );
  static DetectionPolicy _policy(Map<String, dynamic> value) => DetectionPolicy(
    evaluationId: value['evaluation_id'] as String,
    minimumConfidence: (value['minimum_confidence'] as num).toDouble(),
    candidateFloor: (value['candidate_floor'] as num).toDouble(),
    minimumBoxArea: (value['minimum_box_area'] as num).toDouble(),
    edgeMargin: (value['edge_margin'] as num).toDouble(),
    stableFrames: value['stable_frames'] as int,
    stableDuration: Duration(milliseconds: value['stable_duration_ms'] as int),
    maximumFrameGap: Duration(
      milliseconds: value['maximum_frame_gap_ms'] as int,
    ),
    maximumResultAge: Duration(
      milliseconds: value['maximum_result_age_ms'] as int,
    ),
    minimumTrackingIou: (value['minimum_tracking_iou'] as num).toDouble(),
    previewQuality: _quality(value['preview_quality'] as Map<String, dynamic>),
    stillQuality: _quality(value['still_quality'] as Map<String, dynamic>),
  );
}

class LoadedDetectionModel {
  const LoadedDetectionModel(this.specification, this.bytes);
  final ModelSpecification specification;
  final Uint8List bytes;
}

class ModelLoadResult {
  const ModelLoadResult({this.model, this.reason});
  final LoadedDetectionModel? model;
  final String? reason;
}

class ModelLoader {
  ModelLoader({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;
  final AssetBundle _bundle;
  Future<ModelLoadResult> load() async {
    try {
      final json = jsonDecode(
        await _bundle.loadString(
          'assets/models/cinnamon_detector.json',
          cache: false,
        ),
      ) as Map<String, dynamic>;
      final spec = ModelSpecification.fromJson(json);
      final data = await _bundle.load(spec.asset);
      final bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      final valid = await compute(_verifyBytes, (bytes, spec.digest));
      if (!valid) {
        return const ModelLoadResult(reason: 'Model integrity check failed');
      }
      return ModelLoadResult(model: LoadedDetectionModel(spec, bytes));
    } catch (_) {
      return const ModelLoadResult(
        reason: 'Model assets or compatible metadata are unavailable',
      );
    }
  }
}

bool _verifyBytes((Uint8List, String) request) {
  final (bytes, digest) = request;
  // Header/hash checks are integrity checks, not proof of accuracy or a usable
  // flatbuffer. The native runner must allocate and inspect actual tensors.
  return bytes.length >= 8 &&
      bytes.length <= 100 * 1024 * 1024 &&
      ascii.decode(bytes.sublist(4, 8), allowInvalid: true) == 'TFL3' &&
      sha256.convert(bytes).toString() == digest;
}

import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quillgrade_mobile/features/cinnamon_detection/data/model_loader.dart';
import 'package:quillgrade_mobile/features/cinnamon_detection/data/tflite_cinnamon_detector.dart';
import 'package:quillgrade_mobile/features/cinnamon_detection/domain/detection_result.dart';

import '../support/detection_fixture.dart';

class _Bundle extends CachingAssetBundle {
  _Bundle(this.files);
  final Map<String, Uint8List> files;
  @override
  Future<ByteData> load(String key) async {
    final value = files[key];
    if (value == null) throw StateError('Missing fixture asset');
    return ByteData.sublistView(value);
  }
}

class _Runner implements DetectionTensorRunner {
  @override
  List<int> inputShape = [1, 32, 32, 3];
  @override
  List<int> outputShape = [1, 2, 6];
  @override
  String inputType = 'float32';
  @override
  String outputType = 'float32';
  @override
  bool runsOffUiThread = true;
  bool closed = false;
  Float32List output = Float32List.fromList([
    .2,
    .2,
    .8,
    .8,
    .95,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ]);
  @override
  Future<Float32List> invoke(Float32List input) async => output;
  @override
  Future<void> close() async {
    closed = true;
  }
}

void main() {
  test('missing model and metadata fail closed', () async {
    expect((await ModelLoader(bundle: _Bundle({})).load()).model, isNull);
  });
  test('model byte hash and header are checked but do not imply a usable interpreter', () async {
    final json = fixtureModelJson();
    // In-memory header bytes only. No fake model file is written or packaged.
    final bytes = Uint8List.fromList([0, 0, 0, 0, 84, 70, 76, 51]);
    final files = <String, Uint8List>{'assets/models/fixture.tflite': bytes};
    files['assets/models/cinnamon_detector.json'] = Uint8List.fromList(
      utf8.encode(jsonEncode(json)),
    );
    expect((await ModelLoader(bundle: _Bundle(files)).load()).model, isNull);
    json['sha256'] = sha256.convert(bytes).toString();
    files['assets/models/cinnamon_detector.json'] = Uint8List.fromList(
      utf8.encode(jsonEncode(json)),
    );
    expect((await ModelLoader(bundle: _Bundle(files)).load()).model, isNotNull);
    // This proves integrity parsing only; a native runner must reject this header-only payload.
  });
  test('quantized, guessed output layouts and wrong labels are rejected', () {
    for (final change in ['dtype', 'layout', 'labels']) {
      final json = fixtureModelJson();
      if (change == 'dtype') json['input']['dtype'] = 'int8';
      if (change == 'layout') json['output']['layout'] = 'raw_yolo';
      if (change == 'labels') {
        json['labels'] = ['finishing_good', 'finishing_bad'];
      }
      expect(() => ModelSpecification.fromJson(json), throwsFormatException);
    }
  });
  test('native shape or UI-thread mismatch closes the runner', () async {
    for (final wrongShape in [true, false]) {
      final runner = _Runner();
      if (wrongShape) {
        runner.inputShape = [1, 640, 640, 3];
      } else {
        runner.runsOffUiThread = false;
      }
      await expectLater(
        TfliteCinnamonDetector.attach(fixtureSpecification(), runner),
        throwsFormatException,
      );
      expect(runner.closed, isTrue);
    }
  });
  test('canonical output parses labels and rejects malformed confidence/coordinates', () async {
    final runner = _Runner();
    final detector = await TfliteCinnamonDetector.attach(
      fixtureSpecification(),
      runner,
    );
    final input = Float32List(32 * 32 * 3);
    final results = await detector.detect(input);
    expect(results.single.label, DetectionLabel.cinnamonEnd);
    expect(results.single.confidence, closeTo(.95, .00001));
    runner.output[4] = double.nan;
    await expectLater(detector.detect(input), throwsFormatException);
    runner.output[4] = .9;
    runner.output[5] = 9;
    await expectLater(detector.detect(input), throwsFormatException);
    await detector.close();
    expect(runner.closed, isTrue);
    await expectLater(detector.detect(input), throwsStateError);
  });
}

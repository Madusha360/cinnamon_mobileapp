import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:quillgrade_mobile/features/capture/domain/capture_session.dart';
import 'package:quillgrade_mobile/features/cinnamon_detection/data/detection_coordinator.dart';
import 'package:quillgrade_mobile/features/cinnamon_detection/domain/detection_status.dart';
import 'package:quillgrade_mobile/features/samples/domain/sample.dart';

import 'dart:io';

import '../support/detection_fixture.dart';

void main() {
  late FixtureDetector detector;
  late FixturePreprocessor preprocessor;
  late DetectionCoordinator engine;
  late DateTime now;
  setUp(() {
    detector = FixtureDetector();
    preprocessor = FixturePreprocessor();
    now = DateTime.utc(2026, 11, 22);
    final spec = fixtureSpecification();
    engine = DetectionCoordinator(
      detector: detector,
      specification: spec.preprocessing,
      policy: spec.policy,
      preprocessor: preprocessor,
      now: () => now,
    );
  });
  tearDown(() => engine.close());
  Future<void> stable() async {
    for (var i = 0; i < 3; i++) {
      await engine.process(fixtureFrame(now));
      now = now.add(const Duration(milliseconds: 100));
    }
  }

  test(
    'unavailable model never runs preprocessing or grants readiness',
    () async {
      detector.enabled = false;
      expect((await engine.process(fixtureFrame(now))).ready, isFalse);
      expect(engine.current.status, DetectionStatus.modelUnavailable);
      expect(detector.calls, 0);
    },
  );
  test(
    'stable preview is observable and expires after its calibrated lifetime',
    () async {
      await stable();
      expect(engine.current.readyForTemporaryCapture, isTrue);
      expect(engine.current.productionGradingAllowed, isFalse);
      await Future<void>.delayed(const Duration(milliseconds: 520));
      expect(engine.current.status, DetectionStatus.searching);
    },
  );
  test(
    'backpressure refuses overlap and navigation invalidates a late result',
    () async {
      detector.gate = Completer<void>();
      final first = engine.process(fixtureFrame(now));
      await detector.entered.future;
      expect((await engine.process(fixtureFrame(now))).ready, isFalse);
      expect(detector.calls, 1);
      engine.reset();
      detector.gate!.complete();
      expect((await first).ready, isFalse);
      expect(engine.current.readyForTemporaryCapture, isFalse);
    },
  );
  test(
    'blurry frames do not invoke the model and reset stable capture',
    () async {
      await stable();
      final calls = detector.calls;
      preprocessor.quality = const ImageQualityReport(
        width: 32,
        height: 32,
        exifOrientation: 1,
        issues: [QualityIssue.blur],
      );
      expect((await engine.process(fixtureFrame(now))).ready, isFalse);
      expect(engine.current.status, DetectionStatus.blurry);
      expect(detector.calls, calls);
    },
  );
  test(
    'final photo is independently revalidated and consumes the preview ticket',
    () async {
      await stable();
      final validation = await engine.revalidateFile(
        'test-only-original',
        CaptureView.end,
      );
      expect(validation.acceptedForSession, isTrue);
      expect(preprocessor.files, 1);
      expect(validation.productionGradingAllowed, isFalse);
      expect(
        (await engine.revalidateFile(
          'test-only-original',
          CaptureView.end,
        )).acceptedForSession,
        isFalse,
      );
      expect(preprocessor.files, 1);
      await expectLater(
        const UnavailableCaptureValidationGate().validate(
          File('end'),
          File('side'),
        ),
        throwsA(isA<StateError>()),
      );
    },
  );
  test('high-resolution rejection, wrong view and stale preview cannot be accepted', () async {
    await stable();
    detector.candidates = [];
    expect(
      (await engine.revalidateFile(
        'test-only-original',
        CaptureView.end,
      )).acceptedForSession,
      isFalse,
    );
    detector.candidates = [endCandidate];
    await stable();
    expect(
      (await engine.revalidateFile(
        'test-only-original',
        CaptureView.side,
      )).acceptedForSession,
      isFalse,
    );
    await stable();
    now = now.add(const Duration(seconds: 1));
    expect(
      (await engine.revalidateFile(
        'test-only-original',
        CaptureView.end,
      )).acceptedForSession,
      isFalse,
    );
  });
  test('future or delayed frames never create fresh readiness', () async {
    final time = now.add(const Duration(seconds: 1));
    expect((await engine.process(fixtureFrame(time))).ready, isFalse);
    expect(
      (await engine.process(
        fixtureFrame(now.subtract(const Duration(seconds: 1))),
      )).ready,
      isFalse,
    );
    expect(detector.calls, 0);
  });
}

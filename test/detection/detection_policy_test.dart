import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:quillgrade_mobile/features/capture/domain/capture_session.dart';
import 'package:quillgrade_mobile/features/cinnamon_detection/data/model_loader.dart';
import 'package:quillgrade_mobile/features/cinnamon_detection/domain/detection_policy.dart';
import 'package:quillgrade_mobile/features/cinnamon_detection/domain/detection_result.dart';
import 'package:quillgrade_mobile/features/cinnamon_detection/domain/detection_status.dart';

import '../support/detection_fixture.dart';

void main() {
  final policy = fixtureSpecification().policy;
  test(
    'positive detections require view, confidence, visibility and quality',
    () {
      expect(
        policy.classify([endCandidate], CaptureView.end, goodQuality),
        DetectionStatus.valid,
      );
      expect(
        policy.classify([endCandidate], CaptureView.side, goodQuality),
        DetectionStatus.wrongView,
      );
      expect(
        policy.classify(
          [
            const DetectionCandidate(
              label: DetectionLabel.cinnamonSide,
              confidence: .95,
              box: Rect.fromLTRB(.2, .2, .8, .8),
            ),
          ],
          CaptureView.side,
          goodQuality,
        ),
        DetectionStatus.valid,
      );
      expect(
        policy.classify(
          [
            const DetectionCandidate(
              label: DetectionLabel.cinnamonEnd,
              confidence: .5,
              box: Rect.fromLTRB(.2, .2, .8, .8),
            ),
          ],
          CaptureView.end,
          goodQuality,
        ),
        DetectionStatus.uncertain,
      );
      expect(
        policy.classify(
          [
            const DetectionCandidate(
              label: DetectionLabel.cinnamonEnd,
              confidence: .99,
              box: Rect.fromLTRB(0, .2, .8, .8),
            ),
          ],
          CaptureView.end,
          goodQuality,
        ),
        DetectionStatus.uncertain,
      );
    },
  );
  test(
    'negative, empty, multiple and malformed results never grant approval',
    () {
      expect(
        policy.classify(
          [
            const DetectionCandidate(
              label: DetectionLabel.nonCinnamon,
              confidence: .95,
              box: Rect.fromLTRB(.2, .2, .8, .8),
            ),
          ],
          CaptureView.end,
          goodQuality,
        ),
        DetectionStatus.invalid,
      );
      expect(
        policy.classify([], CaptureView.end, goodQuality),
        DetectionStatus.searching,
      );
      expect(
        policy.classify(
          [endCandidate, endCandidate],
          CaptureView.end,
          goodQuality,
        ),
        DetectionStatus.uncertain,
      );
      expect(
        policy.classify(
          [
            const DetectionCandidate(
              label: DetectionLabel.cinnamonEnd,
              confidence: double.nan,
              box: Rect.fromLTRB(.2, .2, .8, .8),
            ),
          ],
          CaptureView.end,
          goodQuality,
        ),
        DetectionStatus.uncertain,
      );
    },
  );
  test(
    'blur and other quality failures cannot be overridden by confidence',
    () {
      for (final issue in QualityIssue.values) {
        final quality = ImageQualityReport(
          width: 1200,
          height: 1000,
          exifOrientation: 1,
          issues: [issue],
        );
        expect(
          policy.classify([endCandidate], CaptureView.end, quality),
          issue == QualityIssue.blur
              ? DetectionStatus.blurry
              : DetectionStatus.uncertain,
        );
      }
    },
  );
  test(
    'stability requires consecutive unique frames of the same target and view',
    () {
      final gate = StableDetectionGate(policy);
      final start = DateTime.utc(2026, 11, 22);
      DetectionResult frame(
        int ms, {
        CaptureView view = CaptureView.end,
        String version = 'one',
        DetectionStatus status = DetectionStatus.valid,
      }) => DetectionResult(
        status: status,
        view: view,
        observedAt: start.add(Duration(milliseconds: ms)),
        candidates: [endCandidate],
        modelVersion: version,
      );
      expect(gate.add(frame(0)), isFalse);
      expect(gate.add(frame(100)), isFalse);
      expect(gate.add(frame(200)), isTrue);
      expect(gate.add(frame(200)), isFalse); // Duplicate timestamp resets.
      expect(gate.add(frame(300)), isFalse);
      expect(gate.add(frame(400, view: CaptureView.side)), isFalse);
      expect(gate.add(frame(500, version: 'changed')), isFalse);
      expect(gate.add(frame(800)), isFalse); // Gap resets.
      expect(gate.add(frame(900, status: DetectionStatus.invalid)), isFalse);
      expect(gate.add(frame(1000)), isFalse);
    },
  );
  test('unreviewed policy data has no permissive defaults', () {
    final json = fixtureModelJson();
    (json['policy'] as Map)['evaluation_id'] = '';
    expect(() => ModelSpecification.fromJson(json), throwsFormatException);
  });
}

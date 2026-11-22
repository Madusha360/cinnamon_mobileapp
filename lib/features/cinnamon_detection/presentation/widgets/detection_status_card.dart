import 'package:flutter/material.dart';

import '../../../../app/l10n/l10n.dart';
import '../../../../core/widgets/status_indicator.dart';
import '../../domain/detection_result.dart';
import '../../domain/detection_status.dart';

class DetectionStatusCard extends StatelessWidget {
  const DetectionStatusCard({
    super.key,
    this.result = DetectionResult.unavailable,
  });
  final DetectionResult result;
  @override
  Widget build(BuildContext context) {
    final text = context.l10n;
    final (label, tone) = switch (result.status) {
      DetectionStatus.valid => (text.cinnamonDetected, StatusTone.positive),
      DetectionStatus.invalid => (text.invalidObject, StatusTone.negative),
      DetectionStatus.wrongView => (
        text.incorrectCameraView,
        StatusTone.negative,
      ),
      DetectionStatus.blurry => (text.imageTooBlurry, StatusTone.uncertain),
      DetectionStatus.uncertain => (
        text.unableToVerifyCinnamon,
        StatusTone.uncertain,
      ),
      DetectionStatus.searching => (
        text.searchingForCinnamon,
        StatusTone.neutral,
      ),
      DetectionStatus.modelUnavailable => (
        text.detectionMissing,
        StatusTone.neutral,
      ),
    };
    return Semantics(
      liveRegion: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusIndicator(label: label, tone: tone),
          const SizedBox(height: 8),
          Text(
            result.status == DetectionStatus.modelUnavailable
                ? text.detectionMissingBody
                : result.status == DetectionStatus.valid && !result.stable
                ? text.holdQuillSteady
                : text.detectionGradingBlocked,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../domain/detection_result.dart';
import '../../domain/detection_status.dart';

Rect detectionPreviewRect(Rect normalizedBox, Size fittedPreview) =>
    Rect.fromLTRB(
      normalizedBox.left * fittedPreview.width,
      normalizedBox.top * fittedPreview.height,
      normalizedBox.right * fittedPreview.width,
      normalizedBox.bottom * fittedPreview.height,
    );

class DetectionOverlay extends StatelessWidget {
  const DetectionOverlay({super.key, required this.result});
  final DetectionResult result;
  @override
  Widget build(BuildContext context) =>
      IgnorePointer(child: CustomPaint(painter: _DetectionPainter(result)));
}

class _DetectionPainter extends CustomPainter {
  const _DetectionPainter(this.result);
  final DetectionResult result;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..color = switch (result.status) {
        DetectionStatus.valid => AppColors.forest,
        DetectionStatus.invalid || DetectionStatus.wrongView => Colors.red,
        _ => AppColors.warning,
      };
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    for (final candidate in result.candidates.where((c) => c.isWellFormed)) {
      canvas.drawRect(detectionPreviewRect(candidate.box, size), paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_DetectionPainter oldDelegate) =>
      oldDelegate.result != result;
}

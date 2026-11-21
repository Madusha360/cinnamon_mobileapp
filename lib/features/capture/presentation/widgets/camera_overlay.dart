import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../domain/capture_session.dart';

/// A positioning guide over the native feed, never a detected object box.
class CameraOverlay extends StatelessWidget {
  const CameraOverlay({super.key, required this.view});
  final CaptureView view;
  @override
  Widget build(BuildContext context) => IgnorePointer(child: CustomPaint(painter: _GuidePainter(view)));
}

class _GuidePainter extends CustomPainter {
  const _GuidePainter(this.view);
  final CaptureView view;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.orange..style = PaintingStyle.stroke..strokeWidth = 2.5;
    if (view == CaptureView.end) {
      final radius = size.shortestSide * 0.23;
      canvas.drawCircle(Offset(size.width * 0.43, size.height * 0.5), radius, paint);
      final side = size.shortestSide * 0.14;
      canvas.drawRect(Rect.fromCenter(center: Offset(size.width * 0.82, size.height * 0.5), width: side, height: side), paint..color = Colors.white);
    } else {
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: size.center(Offset.zero), width: size.width * 0.86, height: size.height * 0.24), const Radius.circular(16)), paint);
    }
  }
  @override
  bool shouldRepaint(_GuidePainter oldDelegate) => view != oldDelegate.view;
}

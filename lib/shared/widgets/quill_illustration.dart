import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Decorative vector artwork only; never represents a captured or accepted image.
class QuillIllustration extends StatelessWidget {
  const QuillIllustration({super.key, this.endView = false, this.height = 210});
  final bool endView;
  final double height;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _QuillPainter(endView: endView)),
    ),
  );
}

class _QuillPainter extends CustomPainter {
  _QuillPainter({required this.endView});
  final bool endView;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    final scale = math.min(size.width / 320, size.height / 210);
    canvas.scale(scale);
    final grid = Paint()
      ..color = const Color(0xFFB5D6BD).withValues(alpha: 0.13)
      ..strokeWidth = 0.8;
    for (var x = -150.0; x <= 150; x += 25) {
      for (var y = -100.0; y <= 100; y += 25) {
        canvas.drawCircle(Offset(x, y), 1.3, grid);
      }
    }
    canvas.drawCircle(
      Offset.zero,
      86,
      Paint()..color = const Color(0xFFB5D6BD).withValues(alpha: 0.06),
    );
    canvas.drawCircle(
      Offset.zero,
      104,
      Paint()
        ..color = const Color(0xFFB5D6BD).withValues(alpha: 0.12)
        ..style = PaintingStyle.stroke,
    );
    if (endView) {
      _end(canvas, const Offset(-16, 0), 58);
      // Alignment reference, deliberately not a machine-readable ArUco marker.
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(80, 28, 40, 40),
          const Radius.circular(5),
        ),
        Paint()..color = AppColors.cream,
      );
      final line = Paint()
        ..color = AppColors.forest
        ..strokeWidth = 3;
      canvas.drawLine(const Offset(91, 39), const Offset(109, 57), line);
      canvas.drawLine(const Offset(109, 39), const Offset(91, 57), line);
    } else {
      canvas.save();
      canvas.rotate(-0.36);
      _stick(canvas, const Offset(-104, -34), 202, 45);
      _stick(canvas, const Offset(-80, 17), 187, 39);
      canvas.restore();
    }
    final bracket = Paint()
      ..color = const Color(0xFFD7E8C1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    for (final (x, y, dx, dy) in [
      (-132.0, -78.0, 1.0, 1.0),
      (132.0, -78.0, -1.0, 1.0),
      (-132.0, 78.0, 1.0, -1.0),
      (132.0, 78.0, -1.0, -1.0),
    ]) {
      canvas.drawPath(
        Path()
          ..moveTo(x, y + dy * 16)
          ..lineTo(x, y)
          ..lineTo(x + dx * 16, y),
        bracket,
      );
    }
    canvas.restore();
  }

  void _stick(Canvas canvas, Offset origin, double width, double height) {
    final rect = Rect.fromLTWH(origin.dx, origin.dy, width, height);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect.shift(const Offset(0, 6)),
        const Radius.circular(14),
      ),
      Paint()..color = Colors.black.withValues(alpha: 0.15),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(12)),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE1B583), Color(0xFFB98050), Color(0xFF8F5233)],
        ).createShader(rect),
    );
    for (var i = 0; i < 5; i++) {
      final y = origin.dy + 7 + i * 7;
      canvas.drawPath(
        Path()
          ..moveTo(origin.dx + 15, y)
          ..quadraticBezierTo(
            origin.dx + width * 0.5,
            y - 5,
            origin.dx + width - 12,
            y + 2,
          ),
        Paint()
          ..color = const Color(0xFF6A3E29).withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = i.isEven ? 1.5 : 0.7,
      );
    }
    canvas.save();
    canvas.translate(origin.dx + width - 5, origin.dy + height / 2);
    canvas.scale(0.48, 1);
    _end(canvas, Offset.zero, height / 2);
    canvas.restore();
  }

  void _end(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFFE7BD8C));
    canvas.drawCircle(
      center,
      radius - 4,
      Paint()..color = const Color(0xFF925533),
    );
    final path = Path();
    for (var i = 0; i <= 240; i++) {
      final t = i / 240;
      final angle = t * math.pi * 7;
      final r = (radius - 7) * (1 - t) + 2;
      final p = center + Offset(math.cos(angle) * r, math.sin(angle) * r);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFEAC695)
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.065
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_QuillPainter oldDelegate) =>
      endView != oldDelegate.endView;
}

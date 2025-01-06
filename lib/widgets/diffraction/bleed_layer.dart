import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../utils/sun_colors.dart';

class BleedLayer extends StatelessWidget {
  final double sunPosition;
  final double sunSize;
  final double bleedAmount;

  const BleedLayer({
    super.key,
    required this.sunPosition,
    required this.sunSize,
    required this.bleedAmount,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: BleedPainter(
            sunPosition: sunPosition,
            sunSize: sunSize,
            bleedAmount: bleedAmount,
          ),
        );
      },
    );
  }
}

class BleedPainter extends CustomPainter {
  final double sunPosition;
  final double sunSize;
  final double bleedAmount;
  static const int totalBands = 54;

  BleedPainter({
    required this.sunPosition,
    required this.sunSize,
    required this.bleedAmount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bandHeight = size.height / totalBands;
    final totalHeight = size.height * 1.4;
    final startPosition = size.height * 1.2;
    final sunCenterY = startPosition - (totalHeight * sunPosition);
    final sunCenterX = size.width / 2;
    final radius = sunSize / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < totalBands; i++) {
      final bandY = i * bandHeight;
      final gapY = bandY + bandHeight;
      final verticalDistance = (gapY - sunCenterY).abs();

      if (verticalDistance <= radius) {
        final halfWidth = math.sqrt((radius * radius) - (verticalDistance * verticalDistance));
        final leftX = sunCenterX - halfWidth;
        final rightX = sunCenterX + halfWidth;

        // Constant thickness controlled only by bleedAmount
        final thickness = bandHeight * (0.1 + (bleedAmount * 0.4));

        paint
          ..color = SunColors.getColorAtBand(i).withOpacity(0.8)
          ..strokeWidth = thickness;

        canvas.drawLine(
          Offset(leftX, gapY),
          Offset(rightX, gapY),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant BleedPainter oldDelegate) =>
      oldDelegate.sunPosition != sunPosition ||
          oldDelegate.sunSize != sunSize ||
          oldDelegate.bleedAmount != bleedAmount;
}
// lib/widgets/effects/diffraction_layer.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';

class DiffractionLayer extends StatelessWidget {
  final double sunPosition;
  final double sunSize;
  final double intensity; // 0.0 to 1.0
  static const int totalBands = 54;

  const DiffractionLayer({
    super.key,
    required this.sunPosition,
    required this.sunSize,
    required this.intensity,
  });

  Path _calculateDiffractionPath(Size size, double bandY, double sunCenterY, double sunCenterX) {
    final path = Path();
    final radius = sunSize / 2;
    final verticalDistance = (bandY - sunCenterY).abs();

    if (verticalDistance > radius) return path; // No diffraction outside sun

    // Calculate intersection points with sun circle
    final halfWidth = math.sqrt((radius * radius) - (verticalDistance * verticalDistance));
    final leftX = sunCenterX - halfWidth;
    final rightX = sunCenterX + halfWidth;

    // Calculate curve control points based on intensity
    final curveHeight = 20.0 * intensity;
    final normalizedDistance = verticalDistance / radius;
    final adjustedHeight = curveHeight * (1 - math.pow(normalizedDistance, 2));

    path.moveTo(leftX, bandY);
    path.quadraticBezierTo(
      sunCenterX,
      bandY - adjustedHeight,
      rightX,
      bandY,
    );

    return path;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalHeight = constraints.maxHeight * 1.4;
        final startPosition = constraints.maxHeight * 1.2;
        final sunCenterY = startPosition - (totalHeight * sunPosition);
        final sunCenterX = constraints.maxWidth / 2;

        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: DiffractionPainter(
            sunCenterX: sunCenterX,
            sunCenterY: sunCenterY,
            sunSize: sunSize,
            intensity: intensity,
            totalBands: totalBands,
          ),
        );
      },
    );
  }
}

class DiffractionPainter extends CustomPainter {
  final double sunCenterX;
  final double sunCenterY;
  final double sunSize;
  final double intensity;
  final int totalBands;

  DiffractionPainter({
    required this.sunCenterX,
    required this.sunCenterY,
    required this.sunSize,
    required this.intensity,
    required this.totalBands,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bandHeight = size.height / totalBands;
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1 * intensity) // Reduced opacity
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8 // Thinner lines
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < totalBands; i++) {
      final bandY = i * bandHeight + (bandHeight / 2);
      final path = _calculateDiffractionPath(size, bandY, sunCenterY, sunCenterX);
      canvas.drawPath(path, paint);
    }
  }

  Path _calculateDiffractionPath(Size size, double bandY, double sunCenterY, double sunCenterX) {
    final path = Path();
    final radius = sunSize / 2;
    final verticalDistance = (bandY - sunCenterY).abs();

    if (verticalDistance > radius) return path;

    // Calculate intersection points with sun circle
    final halfWidth = math.sqrt((radius * radius) - (verticalDistance * verticalDistance));
    final leftX = sunCenterX - halfWidth;
    final rightX = sunCenterX + halfWidth;

    // Calculate curve parameters
    final normalizedDistance = verticalDistance / radius;
    final curveStrength = math.cos(normalizedDistance * math.pi / 2) * intensity;
    final curveLength = 80.0 * curveStrength; // Longer horizontal extension
    final curveHeight = 5.0 * curveStrength; // Less vertical displacement

    // Left side curve
    path.moveTo(leftX - curveLength, bandY);
    path.quadraticBezierTo(
        leftX, bandY - curveHeight,
        leftX, bandY
    );

    // Straight line through sun
    path.lineTo(rightX, bandY);

    // Right side curve (mirrored horizontally)
    path.quadraticBezierTo(
        rightX, bandY - curveHeight,
        rightX + curveLength, bandY
    );

    return path;
  }

  @override
  bool shouldRepaint(covariant DiffractionPainter oldDelegate) =>
      oldDelegate.sunCenterX != sunCenterX ||
          oldDelegate.sunCenterY != sunCenterY ||
          oldDelegate.sunSize != sunSize ||
          oldDelegate.intensity != intensity;
}
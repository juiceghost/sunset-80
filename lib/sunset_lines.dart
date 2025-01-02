import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class SunsetLines extends StatelessWidget {
  const SunsetLines({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: 240,
          height: 500,
          child: CustomPaint(
            painter: SunsetLinesPainter(),
          ),
        ),
      ),
    );
  }
}

class SunsetLinesPainter extends CustomPainter {
  Color getGradientColor(double progress) {
    if (progress < 0.2) {
      return HSLColor.fromAHSL(
        1.0,
        280,
        0.6,
        0.25,
      ).toColor();
    } else if (progress < 0.4) {
      double localProgress = (progress - 0.2) * 5;
      return HSLColor.fromAHSL(
        1.0,
        220 - (localProgress * 40),
        0.5,
        0.3,
      ).toColor();
    } else if (progress < 0.6) {
      double localProgress = (progress - 0.4) * 5;
      return HSLColor.fromAHSL(
        1.0,
        180 - (localProgress * 60),
        0.4,
        0.35,
      ).toColor();
    } else if (progress < 0.8) {
      double localProgress = (progress - 0.6) * 5;
      return HSLColor.fromAHSL(
        1.0,
        120 - (localProgress * 60),
        0.5,
        math.max(0.2, 0.35 - localProgress * 0.15),
      ).toColor();
    } else {
      double localProgress = (progress - 0.8) * 5;
      return HSLColor.fromAHSL(
        1.0,
        60 - (localProgress * 30),
        0.6,
        math.max(0.15, 0.3 - localProgress * 0.15),
      ).toColor();
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final numberOfLines = 54;
    final spacing = size.height / numberOfLines;
    final lineThickness = 2.5;

    final sunCenterX = size.width / 2;
    final sunCenterY = size.height * 0.937; // Moved up by one line spacing
    final sunRadius = size.width * 0.25;
    final verticalCompressionFactor = 0.7;

    // Draw background lines
    for (int i = 0; i < numberOfLines; i++) {
      final progress = i / numberOfLines;
      final y = spacing * i;

      final paint = Paint()
        ..strokeWidth = lineThickness
        ..style = PaintingStyle.stroke
        ..color = getGradientColor(progress);

      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Draw sun with smooth thickness transition
    var sunLineCount = 0;
    for (int i = 0; i < numberOfLines; i++) {
      final y = spacing * i;
      final scaledDistance = (y - sunCenterY) / verticalCompressionFactor;
      if (scaledDistance.abs() <= sunRadius) {
        final distanceFromCenter = scaledDistance.abs();
        final halfWidth = math.cos(math.asin(distanceFromCenter / sunRadius)) * sunRadius;

        final segments = 40;
        for (int j = 0; j < segments; j++) {
          final xProgress = j / (segments - 1);
          final x = sunCenterX - halfWidth + (halfWidth * 2 * xProgress);
          final nextX = sunCenterX - halfWidth + (halfWidth * 2 * ((j + 1) / (segments - 1)));

          final distanceFromCenterX = ((x + nextX) / 2 - sunCenterX).abs() / halfWidth;
          final thicknessProgress = distanceFromCenterX > 0.8 ?
          math.pow(1 - ((distanceFromCenterX - 0.8) / 0.2), 1.5).toDouble() : 1.0;
          final thickness = 1.5 + (thicknessProgress * 5.0);

          Color sunColor;
          if (sunLineCount == 0) {
            sunColor = Color(0xFFFFE082);
          } else if (sunLineCount <= 2) {
            sunColor = Color(0xFFFB8C00);
          } else {
            sunColor = Color(0xFFD32F2F);
          }

          final paint = Paint()
            ..strokeWidth = thickness
            ..style = PaintingStyle.stroke
            ..color = sunColor
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, thickness * 0.2);

          canvas.drawLine(
            Offset(x, y),
            Offset(nextX, y),
            paint,
          );
        }
        sunLineCount++;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
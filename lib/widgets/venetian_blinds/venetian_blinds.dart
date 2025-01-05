import 'dart:math' as math;
import 'package:flutter/material.dart';

class VenetianBlinds extends StatelessWidget {
  final int numberOfBlinds;
  final double slatsAngle;
  final Color blindColor;
  final double sunPosition;
  final double sunSize;

  const VenetianBlinds({
    super.key,
    this.numberOfBlinds = 54,
    this.slatsAngle = 0,
    this.blindColor = Colors.black,
    required this.sunPosition,
    this.sunSize = 140,
  });

  double _calculateGapIncrease(double y, double sunCenterY) {
    final verticalDistance = (y - sunCenterY).abs();
    final effectRadius = sunSize * 0.7;

    if (verticalDistance > effectRadius) return 0.0;

    final normalizedDistance = verticalDistance / effectRadius;
    return (1.0 - math.pow(normalizedDistance, 2)) * 2.0; // Adjust multiplier for gap size
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final baseHeight = constraints.maxHeight / numberOfBlinds;
        final blindHeight = baseHeight * 0.8; // Base height of each blind
        final totalHeight = constraints.maxHeight * 1.4;
        final startPosition = constraints.maxHeight * 1.2;
        final sunCenterY = startPosition - (totalHeight * sunPosition);

        double currentY = 0;
        final bands = <Widget>[];

        for (int i = 0; i < numberOfBlinds; i++) {
          final gapIncrease = _calculateGapIncrease(currentY, sunCenterY);

          bands.add(
            Positioned(
              top: currentY,
              left: 0,
              right: 0,
              child: Container(
                height: blindHeight,
                color: blindColor,
              ),
            ),
          );

          // Increase the gap before the next blind
          currentY += blindHeight + (baseHeight * 0.2 * (1 + gapIncrease));
        }

        return Stack(children: bands);
      },
    );
  }
}
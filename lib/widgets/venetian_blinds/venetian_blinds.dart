import 'dart:math' as math;
import 'package:flutter/material.dart';

class VenetianBlinds extends StatelessWidget {
  final int numberOfBlinds;
  final double slatsAngle;
  final Color blindColor;
  final double sunPosition;
  final double sunSize;
  final double lineThickness;

  const VenetianBlinds({
    super.key,
    this.numberOfBlinds = 54,
    this.slatsAngle = 0,
    this.blindColor = Colors.black,
    required this.sunPosition,
    this.sunSize = 140,
    this.lineThickness = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalHeight = constraints.maxHeight * 1.4;
        final startPosition = constraints.maxHeight * 1.2;
        final sunCenterY = startPosition - (totalHeight * sunPosition);
        final sunCenterX = constraints.maxWidth / 2;
        final radius = sunSize / 2;

        // Calculate sizes based on total available space and number of blinds
        final unitHeight = constraints.maxHeight / numberOfBlinds;
        final gapHeight = unitHeight * lineThickness; // Gap height from parameter
        final blindHeight = unitHeight - gapHeight; // Blind height is remaining space

        double currentY = 0;
        final bands = <Widget>[];

        for (int i = 0; i < numberOfBlinds; i++) {
          // Add the black band
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

          // Calculate if this gap intersects with the sun
          final gapY = currentY + blindHeight;
          final verticalDistance = (gapY - sunCenterY).abs();

          if (verticalDistance <= radius) {
            // If gap intersects with sun, add a transparent line
            bands.add(
              Positioned(
                top: gapY,
                left: 0,
                right: 0,
                child: Container(
                  height: gapHeight,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            );
          }

          currentY += blindHeight + gapHeight;
        }

        return Stack(children: bands);
      },
    );
  }
}
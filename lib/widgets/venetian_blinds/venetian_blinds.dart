import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../utils/sun_colors.dart';

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

  Color _getSunColorAtPosition(double normalizedY) {
    if (normalizedY < 0.25) {
      return const Color(0xFFFFCC00); // Yellow
    } else if (normalizedY < 0.5) {
      return const Color(0xFFFF9900); // Yellow-orange
    } else if (normalizedY < 0.75) {
      return const Color(0xFFFF6600); // Orange
    } else {
      return const Color(0xFFFF3300); // Orange-red
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalHeight = constraints.maxHeight * 1.4;
        final startPosition = constraints.maxHeight * 1.2;
        final sunCenterY = startPosition - (totalHeight * sunPosition);
        final sunCenterX = constraints.maxWidth / 2;
        final radius = sunSize / 2;

        final unitHeight = constraints.maxHeight / numberOfBlinds;
        final gapHeight = unitHeight * lineThickness;
        final blindHeight = unitHeight - gapHeight;

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
            // Calculate the y-position within the sun to determine color
            final normalizedY = (gapY - (sunCenterY - radius)) / (radius * 2);
            final bandIndex = SunColors.getBandIndex(gapY, constraints.maxHeight);
            final sunColor = SunColors.getColorAtBand(bandIndex);

            bands.add(
              Positioned(
                top: gapY,
                left: 0,
                right: 0,
                child: Container(
                  height: gapHeight,
                  color: sunColor.withOpacity(0.8),
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
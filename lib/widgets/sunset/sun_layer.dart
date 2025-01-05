import 'package:flutter/material.dart';

class SunLayer extends StatelessWidget {
  final double sunPosition;
  final double sunSize;
  final double squishFactor; // 1.0 is perfect circle, higher values squish more
  static const int totalBands = 54;

  const SunLayer({
    super.key,
    required this.sunPosition,
    this.sunSize = 140,
    this.squishFactor = 1.2, // Default squish amount
  });

  Color _getSunColor(int bandIndex) {
    if (bandIndex >= 51) {
      return const Color(0xFFFF3300); // Orange-red
    } else if (bandIndex >= 49) {
      return const Color(0xFFFF6600); // Orange
    } else if (bandIndex >= 47) {
      return const Color(0xFFFF9900); // Yellow-orange
    } else {
      return const Color(0xFFFFCC00); // Yellow
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final sunCenter = constraints.maxWidth / 2;
        final totalHeight = constraints.maxHeight * 1.4;
        final startPosition = constraints.maxHeight * 1.2;
        final currentPosition = startPosition - (totalHeight * sunPosition);
        final squishHeight = sunSize / squishFactor;

        return Stack(
          children: [
            Positioned(
              left: sunCenter - (sunSize / 2),
              top: currentPosition - (squishHeight / 2),
              child: ClipOval(
                child: Container(
                  width: sunSize,
                  height: squishHeight,
                  child: Stack(
                    children: List.generate(totalBands, (index) {
                      final bandHeight = constraints.maxHeight / totalBands;
                      final bandTop = index * bandHeight;
                      return Positioned(
                        left: 0,
                        right: 0,
                        top: bandTop - (currentPosition - squishHeight/2),
                        height: bandHeight,
                        child: Container(
                          color: _getSunColor(index),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
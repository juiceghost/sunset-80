import 'package:flutter/material.dart';

class VenetianBlinds extends StatelessWidget {
  final int numberOfBlinds;
  final double slatsAngle;
  final Color blindColor;
  final double opacity;
  final double slatHeightRatio;
  final double width;
  final double height;

  const VenetianBlinds({
    super.key,
    this.numberOfBlinds = 54,
    this.slatsAngle = 0,
    this.blindColor = Colors.black,
    this.opacity = 0.8,
    this.slatHeightRatio = 0.9,
    this.width = 300,
    this.height = 600,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bandHeight = height / numberOfBlinds;
          final slatHeight = bandHeight * slatHeightRatio;
          final gap = (bandHeight - slatHeight) / 2;

          return Stack(
            clipBehavior: Clip.none,
            children: List.generate(
              numberOfBlinds,
                  (index) => Positioned(
                top: (index * bandHeight) + gap,
                left: 0,
                right: 0,
                child: Container(
                  height: slatHeight,
                  color: blindColor.withOpacity(opacity),
                  // Transform can be added here later for slat rotation
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
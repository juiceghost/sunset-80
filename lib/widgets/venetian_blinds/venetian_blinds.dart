import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../utils/sun_colors.dart';

class VenetianBlinds extends StatefulWidget {
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
  State<VenetianBlinds> createState() => _VenetianBlindsState();

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

class _VenetianBlindsState extends State<VenetianBlinds> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    final Curve customCurve = Cubic(0.25, 0.1, 0.25, 1.0);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: customCurve,
    );

//    _animation = CurvedAnimation(
//      parent: _controller,
//      curve: Curves.easeInOut, // We'll replace this with custom cubic later
//    );

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ClipRect(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return CustomPaint(
                size: Size(constraints.maxWidth,
                    constraints.maxHeight * _animation.value),
                painter: BlindsPainter(
                  sunPosition: widget.sunPosition,
                  sunSize: widget.sunSize,
                  lineThickness: widget.lineThickness,
                  progress: _animation.value,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class BlindsPainter extends CustomPainter {
  final double sunPosition;
  final double sunSize;
  final double lineThickness;
  final double progress;
  static const int totalBands = 54;

  BlindsPainter({
    required this.sunPosition,
    required this.sunSize,
    required this.lineThickness,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bandHeight = size.height / totalBands;
    final totalHeight = size.height * 1.4;
    final startPosition = size.height * 1.2;
    final sunCenterY = startPosition - (totalHeight * sunPosition);

    // Calculate how many bands should be visible based on progress
    final visibleBands = (totalBands * progress).ceil();

    for (int i = 0; i < visibleBands; i++) {
      // Rest of your existing painting code
    }
  }

  @override
  bool shouldRepaint(covariant BlindsPainter oldDelegate) =>
      oldDelegate.sunPosition != sunPosition ||
          oldDelegate.sunSize != sunSize ||
          oldDelegate.lineThickness != lineThickness ||
          oldDelegate.progress != progress;
}
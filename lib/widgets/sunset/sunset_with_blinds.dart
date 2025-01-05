import 'package:flutter/material.dart';
import '../venetian_blinds/venetian_blinds.dart';
import 'sunset_background.dart';
import 'sun_layer.dart';

class SunsetWithBlinds extends StatelessWidget {
  final List<Color> controlColors;
  final bool showBlinds;
  final double sunPosition;
  final double sunSquish;

  const SunsetWithBlinds({
    super.key,
    required this.controlColors,
    this.showBlinds = true,
    this.sunPosition = 1.0,
    this.sunSquish = 1.2,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SunsetBackground(controlColors: controlColors),
        SunLayer(
          sunPosition: sunPosition,
          squishFactor: sunSquish,
        ),
        if (showBlinds)
          VenetianBlinds(
            sunPosition: sunPosition,
          ),
      ],
    );
  }
}
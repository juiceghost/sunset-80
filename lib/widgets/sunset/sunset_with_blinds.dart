import 'package:flutter/material.dart';
import '../venetian_blinds/venetian_blinds.dart';
import 'sunset_background.dart';

class SunsetWithBlinds extends StatelessWidget {
  final List<Color> controlColors;
  final bool showBlinds;

  const SunsetWithBlinds({
    super.key,
    required this.controlColors,
    this.showBlinds = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background sunset gradient
        SunsetBackground(controlColors: controlColors),

        // Venetian blinds mask
        if (showBlinds) const VenetianBlinds(),
      ],
    );
  }
}
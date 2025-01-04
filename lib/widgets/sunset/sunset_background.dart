import 'package:flutter/material.dart';

class SunsetBackground extends StatelessWidget {
  final List<Color> controlColors;

  const SunsetBackground({
    super.key,
    required this.controlColors,
  });

  List<Color> _generateGradientColors() {
    List<Color> colors = [];
    final int bandsPerSection = 9;

    for (int i = 0; i < 54; i++) {
      int section = i ~/ bandsPerSection;
      int positionInSection = i % bandsPerSection;

      if (section >= controlColors.length - 1) {
        colors.add(controlColors.last);
      } else if (positionInSection == 0) {
        colors.add(controlColors[section]);
      } else {
        double progress = positionInSection / bandsPerSection;
        colors.add(Color.lerp(
            controlColors[section],
            controlColors[section + 1],
            progress
        )!);
      }
    }
    return colors;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bandHeight = constraints.maxHeight / 54;
        final colors = _generateGradientColors();

        return Container(
          color: Colors.black,
          child: Column(
            children: List.generate(
              54,
                  (index) => Container(
                height: bandHeight,
                color: colors[index],
              ),
            ),
          ),
        );
      },
    );
  }
}
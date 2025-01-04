import 'package:flutter/material.dart';

class SunsetBackground extends StatelessWidget {
  const SunsetBackground({super.key});

  // These colors represent the gradient from top to bottom
  static const List<Color> sunsetColors = [
    Color(0xFF1A1A1A), // Dark top
    Color(0xFF1A1A1A),
    Color(0xFF1E2329),
    Color(0xFF1E2833),
    Color(0xFF1F2D3D),
    Color(0xFF203147),
    Color(0xFF213551),
    Color(0xFF22395B),
    Color(0xFF233D65),
    Color(0xFF24426F),
    Color(0xFF254679),
    Color(0xFF264A83),
    Color(0xFF274E8D),
    Color(0xFF285297),
    Color(0xFF2956A1),
    Color(0xFF2A5AAB),
    Color(0xFF2B5EB5),
    Color(0xFF2C62BF),
    Color(0xFF2D66C9),
    Color(0xFF2E6AD3),
    Color(0xFF2F6EDD),
    Color(0xFF3072E7),
    Color(0xFF2F6EDD),
    Color(0xFF2E6AD3),
    Color(0xFF2D66C9),
    Color(0xFF2C62BF),
    Color(0xFF2B5EB5),
    Color(0xFF2A5AAB),
    Color(0xFF2956A1),
    Color(0xFF285297),
    Color(0xFF274E8D),
    Color(0xFF264A83),
    Color(0xFF254679),
    Color(0xFF24426F),
    Color(0xFF233D65),
    Color(0xFF22395B),
    Color(0xFF213551),
    Color(0xFF203147),
    Color(0xFF1F2D3D),
    Color(0xFF1E2833),
    Color(0xFF1D2329),
    Color(0xFF1C1F1F),
    Color(0xFF1A1A1A),
    Color(0xFF1A1A1A),
    Color(0xFF1A1A1A),
    Color(0xFF331A1A),
    Color(0xFF4D1A1A),
    Color(0xFF661A1A),
    Color(0xFF801A1A),
    Color(0xFF991A1A),
    Color(0xFFB31A1A),
    Color(0xFFCC1A1A),
    Color(0xFFE61A1A),
    Color(0xFFFF1A1A),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bandHeight = constraints.maxHeight / sunsetColors.length;

        return Column(
          children: List.generate(
            sunsetColors.length,
                (index) => Container(
              height: bandHeight,
              color: sunsetColors[index],
            ),
          ),
        );
      },
    );
  }
}
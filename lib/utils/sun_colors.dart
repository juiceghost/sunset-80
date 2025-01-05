// lib/utils/sun_colors.dart
import 'dart:ui';

class SunColors {
  static Color getColorAtBand(int bandIndex) {
    if (bandIndex >= 51) {
      return const Color(0xFFFF5046);
    } else if (bandIndex >= 49) {
      return const Color(0xFFFF645A);
    } else if (bandIndex >= 47) {
      return const Color(0xFFFF786E);
    } else if (bandIndex >= 45) {
      return const Color(0xFFFF8C82);
    } else if (bandIndex >= 43) {
      return const Color(0xFFFFA096);
    } else if (bandIndex >= 41) {
      return const Color(0xFFFFB4AA);
    } else if (bandIndex >= 39) {
      return const Color(0xFFFFC8BE);
    } else {
      return const Color(0xFFFFC8BE);
    }
  }

  // Helper function to get band index from y position
  static int getBandIndex(double y, double totalHeight) {
    return (y / (totalHeight / 54)).floor();
  }
}

import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

abstract class MediBotColors {
  static Color color1 = HexColor("FBF5EF");
  static Color color2 = HexColor("E0FBFC");
  static Color color3 = HexColor("C9F0F7");
  static Color white = HexColor("FFFFFF");
}
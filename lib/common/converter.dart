import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringExtension on String {
  String toSingleUpperCase() => "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  String toEveryFirstUpperCase() => this.split(" ").map((str) => str.toSingleUpperCase()).join(" ");

  String toSingleLetter() => "${this.replaceAll(this.substring(1), "")}";
  String toEverySingleLetter() => this.split(" ").map((str) => str.toSingleLetter()).join(".");

  String toDMYDate() => DateFormat('dd-MM-yyyy').format(DateTime.parse(this)).toString();
  String toDateTime() => DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.parse(this)).toString();

  double toDouble() => double.parse(this.toString());
  int toInt() => int.parse(this.toString());

}
class ColorConvert {
  static materialColor(hexColor, color) {
    return MaterialColor(
      hexColor,
      getMaterialColor(color),
    );
  }
}

// Color
Map<int, Color> getMaterialColor (Color color) {
  final hslColor = HSLColor.fromColor(color);
  final lightness = hslColor.lightness;


  final lowDivisor = 6;

  final highDivisor = 5;

  final lowStep = (1.0 - lightness) / lowDivisor;
  final highStep = lightness / highDivisor;

  return {
    50: (hslColor.withLightness(lightness + (lowStep * 5))).toColor(),
    100: (hslColor.withLightness(lightness + (lowStep * 4))).toColor(),
    200: (hslColor.withLightness(lightness + (lowStep * 3))).toColor(),
    300: (hslColor.withLightness(lightness + (lowStep * 2))).toColor(),
    400: (hslColor.withLightness(lightness + lowStep)).toColor(),
    500: (hslColor.withLightness(lightness)).toColor(),
    600: (hslColor.withLightness(lightness - highStep)).toColor(),
    700: (hslColor.withLightness(lightness - (highStep * 2))).toColor(),
    800: (hslColor.withLightness(lightness - (highStep * 3))).toColor(),
    900: (hslColor.withLightness(lightness - (highStep * 4))).toColor(),
  };
}


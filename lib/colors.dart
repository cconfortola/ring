import 'package:flutter/material.dart';

final _lightColors = {
  'primary': Colors.red[400],
  'background': Colors.white,
  'backgroundAccent': Colors.grey[100],
  'text': Colors.black,
  'textContrast': Colors.white,
  'textHeading': Colors.red[400],
  'textHeadingContrast': Colors.black,
};

final _darkColors = {
  'primary': Colors.red[400],
  'background': Colors.black,
  'backgroundAccent': Colors.grey[900],
  'text': Colors.white.withOpacity(0.8),
  'textContrast': Colors.white,
  'textHeading': Colors.white,
  'textHeadingContrast': Colors.white,
};

class RingColors {
  final BuildContext context;
  Color primary;
  Color background;
  Color backgroundAccent;
  Color text;
  Color textContrast;
  Color textHeading;
  Color textHeadingContrast;

  RingColors.of(this.context) {
    final colors = MediaQuery.of(context).platformBrightness == Brightness.light
        ? _lightColors
        : _darkColors;

    Color getColor(String color) => colors[color] ?? _lightColors[color];

    this.primary = getColor('primary');
    this.background = getColor('background');
    this.backgroundAccent = getColor('backgroundAccent');
    this.text = getColor('text');
    this.textHeading = getColor('textHeading');
    this.textContrast = getColor('textContrast');
    this.textHeadingContrast = getColor('textHeadingContrast');
  }
}

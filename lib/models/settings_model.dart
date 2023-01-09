import 'package:flutter/material.dart';

class Settings extends ChangeNotifier {
  Brightness _brightness = Brightness.light;
  ColorScheme _colorScheme = ColorScheme.fromSeed(seedColor: Colors.deepOrange);

  late ThemeData themeData = ThemeData(
    useMaterial3: true,
    colorScheme: _colorScheme,
    brightness: _brightness,
  );

  void setBrightness(bool isDark) {
    _brightness = isDark ? Brightness.dark : Brightness.light;

    updateTheme();
  }

  void setColor(Color color) {
    _colorScheme = ColorScheme.fromSeed(seedColor: color);
    updateTheme();
  }

  void updateTheme() {
    themeData = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _colorScheme.primary,
        brightness: _brightness,
      ),
    );

    notifyListeners();
  }
}

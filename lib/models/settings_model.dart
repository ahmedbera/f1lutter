import 'package:f1lutter/cache.dart';
import 'package:flutter/material.dart';

class Settings extends ChangeNotifier {
  CacheHelper _cacheHelper = CacheHelper();
  Brightness _brightness = Brightness.light;
  Color _seedColor = Colors.deepOrange;
  List<Widget> scaffolActions = [];

  Settings(isDark) {
    if (isDark == null)
      _brightness = Brightness.dark;
    else
      _brightness = isDark ? Brightness.dark : Brightness.light;
  }

  late ThemeData themeData = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: _brightness,
    ),
  );

  void setBrightness(bool isDark) {
    _brightness = isDark ? Brightness.dark : Brightness.light;
    _cacheHelper.writeSettings(isDark);

    updateTheme();
  }

  void setColor(Color color) {
    _seedColor = color;
    updateTheme();
  }

  void updateTheme() {
    themeData = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: _brightness,
      ),
    );

    notifyListeners();
  }

  setScaffoldActions(var actions) {
    scaffolActions = actions;
    notifyListeners();
  }
}

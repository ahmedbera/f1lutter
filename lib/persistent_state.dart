import 'dart:core';
import 'package:flutter/material.dart';
//import 'package:f1utter/models/Race.dart';

class GlobalData extends ChangeNotifier{
  static ValueNotifier<Map> raceResults = new ValueNotifier<Map<dynamic, dynamic>>(new Map());
  static ValueNotifier<Map> driverStandings = new ValueNotifier<Map<dynamic, dynamic>>(new Map());
  static ValueNotifier<Map> constructorStandings = new ValueNotifier<Map<dynamic, dynamic>>(new Map());

  static void updateRaceResults(round, res) {
    GlobalData.raceResults.value[round.toString()] = res;
    GlobalData.raceResults.notifyListeners();
  }

  static ValueNotifier <Brightness> appBrightness = new ValueNotifier<Brightness>(Brightness.light);
  static Color primarySwatch = Colors.red;
  static Color accent = Colors.orangeAccent;

  static void updateTheme(Brightness brightess) {
    if(brightess == Brightness.dark) {
      primarySwatch = Colors.blue;
      accent = Colors.deepPurpleAccent;
      appBrightness.value = Brightness.dark; // Update brightness value last since it calls listeners
    } else if (brightess == Brightness.light) {
      primarySwatch = Colors.red;
      accent = Colors.orangeAccent;
      print(accent);
      appBrightness.value = Brightness.light; // Update brightness value last since it calls listeners
    }
  }
}
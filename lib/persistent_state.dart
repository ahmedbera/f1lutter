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

}
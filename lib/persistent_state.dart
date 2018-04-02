import 'dart:core';
import 'package:flutter/material.dart';
import 'package:f1utter/models/Race.dart';

class GlobalData {
  static ValueNotifier<List<RaceResult>> raceResults = new ValueNotifier(new List<RaceResult>());
  static ValueNotifier<Map> driverStandings = new ValueNotifier<Map<dynamic, dynamic>>(new Map());
  static ValueNotifier<Map> constructorStandings = new ValueNotifier<Map<dynamic, dynamic>>(new Map());
}
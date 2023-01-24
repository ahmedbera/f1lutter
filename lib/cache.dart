import 'dart:async';
import 'package:localstore/localstore.dart';

class CacheHelper {
  final db = Localstore.instance;

  void writeRaceCache(cache, cacheKey) async {
    db.collection("cache").doc(cacheKey).set({"data": cache, "done": true});
  }

  void writeSettings(value) async {
    db.collection("settings").doc("isDark").set({"isDark": value});
  }

  Future<Map<String, dynamic>?> readRaceCache() async {
    return await db.collection("cache").doc("calendar").get();
  }

  Future readSettings() async {
    return await db.collection("settings").doc("isDark").get();
  }
}

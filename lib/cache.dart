import 'dart:async';
import 'package:localstore/localstore.dart';

class CacheHelper {
  final db = Localstore.instance;

  Future writeRaceCache(cache) async {
    db.collection("cache").doc("races").set({"data": cache, "done": true});
  }

  Future<Map<String, dynamic>?> readRaceCache() async {
    return await db.collection("cache").doc("races").get();
  }
}

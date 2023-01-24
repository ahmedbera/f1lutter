import 'dart:io';
import 'dart:async';
import 'package:f1lutter/cache.dart';
import 'package:http/http.dart' as http;

class Api {
  static Future<String> getRacesByYear(int year) {
    if (year.toString().length != 4) {
      throw Exception("Wrong parameter: year");
    }
    Uri seasonUri = Uri.https("ergast.com", "/api/f1/$year.json");

    return makeRequest(seasonUri, "calendar");
  }

  static Future<String> getDriversStandings(int year) {
    if (year.toString().length != 4) {
      throw Exception("Wrong parameter: year");
    }
    Uri uri = Uri.https("ergast.com", "/api/f1/$year/driverStandings.json");

    return makeRequest(uri, "drivers");
  }

  static Future<String> getConstructorsStandings(int year) {
    if (year.toString().length != 4) {
      throw Exception("Wrong parameter: year");
    }
    Uri uri = Uri.https("ergast.com", "/api/f1/$year/constructorStandings.json");

    return makeRequest(uri, "constructors");
  }

  static Future<String> makeRequest(Uri uri, String dbKey) async {
    var response = await http.get(uri);
    var cache = CacheHelper();

    if (response.statusCode == HttpStatus.ok) {
      var json = await response.body;
      cache.writeRaceCache(json, dbKey);
      return json;
    } else {
      return 'Error getting IP address:\nHttp status ${response.statusCode}';
    }
  }
}

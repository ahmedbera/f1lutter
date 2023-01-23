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

    return makeRequest(seasonUri);
  }

  static Future<String> makeRequest(Uri uri) async {
    var response = await http.get(uri);
    var cache = CacheHelper();

    if (response.statusCode == HttpStatus.ok) {
      var json = await response.body;
      cache.writeRaceCache(json);
      return json;
    } else {
      return 'Error getting IP address:\nHttp status ${response.statusCode}';
    }
  }
}

import 'cache.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

class ApiHelper {
  static final Uri _seasonUri = new Uri.https("ergast.com","/api/f1/2018.json");
  static final Uri _driverStandingsUri = new Uri.http("ergast.com", "/api/f1/current/driverStandings.json");
  static final Uri _constructorStandingsUri = new Uri.http("ergast.com", "/api/f1/current/constructorStandings.json");
  
  static Future<String> makeRequest(Uri uri) async {
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var json = await response.transform(UTF8.decoder).join();
      if(uri == _seasonUri)
        CacheHelper.writeRaceCache(json);
      return json;
    } else {
      return 'Error getting IP address:\nHttp status ${response.statusCode}';
    }
  }

  static Future<String> getRaces() {
    return makeRequest(_seasonUri).then((res) => res);
  }

  static Future<String> getDriverStandings() { 
    return makeRequest(_driverStandingsUri).then((res) => res);
  }
  
  static Future<String> getConstructorStandings() {
    return makeRequest(_constructorStandingsUri).then((res) => res);
  }
  
}
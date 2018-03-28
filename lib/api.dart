import 'cache.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:f1utter/models/Driver.dart';
import 'package:f1utter/models/Constructors.dart';


class ApiHelper {
  static final Uri _seasonUri = new Uri.https("ergast.com","/api/f1/2018.json");
  
  static Uri driverStandingsUri([String year="current"]) {
    return new Uri.http("ergast.com", "/api/f1/" + year + "/driverStandings.json") ;
  }

  static Uri constructorStandingsUri([String year="current"]) {
    return new Uri.http("ergast.com", "/api/f1/" + year + "/constructorStandings.json") ;
  }

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

  static Future<Map> getDriverStandings([String year="current"]) { 
    return makeRequest(driverStandingsUri(year)).then((res) {
      var response = JSON.decode(res);
      List<DriverStandingModel> standingsList = new List();
      
      var standings = response["MRData"]["StandingsTable"]["StandingsLists"][0];

      var driverStandings = standings["DriverStandings"];
      
      for(var driver in driverStandings) {
        standingsList.add(
          new DriverStandingModel(
            new Driver(
              driver["Driver"]["driverId"],
              driver["Driver"]["permanentNumber"],
              driver["Driver"]["code"],
              driver["Driver"]["familyName"],
              driver["Driver"]["givenName"],
              driver["Driver"][new DateTime.now()],
              driver["Driver"]["nationality"]
            ),
            driver["position"],
            driver["points"],
            driver["wins"],          
          ),
        );
      }
      
      Map requestResponse = {
        "standings" : standingsList,
        "round" : standings["round"],
        "year" : standings["season"]
      };

      return requestResponse;
    });
  }
  
  static Future<Map> getConstructorStandings([String year="current"]) {
    return makeRequest(constructorStandingsUri(year)).then((res) {
      var response = JSON.decode(res);
      List<ConstructorStandingModel> standingsList = new List();

      var standings = response["MRData"]["StandingsTable"]["StandingsLists"][0];

      var constructorStandings = standings["ConstructorStandings"];

      for(var ctor in constructorStandings) {
        standingsList.add(
          new ConstructorStandingModel(
            new Constructor(
              ctor["Constructor"]["constructorId"],
              ctor["Constructor"]["name"],
              ctor["Constructor"]["nationality"],
            ),
            ctor["position"],
            ctor["points"],
            ctor["wins"],   
          )
        );
      }
      
      Map requestResponse = {
        "standings" : standingsList,
        "round" : standings["round"],
        "year" : standings["season"]
      };

      return requestResponse;
    });
  }
  
}
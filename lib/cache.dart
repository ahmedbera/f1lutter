import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class CacheHelper {
  static Future<String> get _localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  static Future<File> get _localFile async {
    final path = await CacheHelper._localPath;
    return new File('$path/cache.json');
  }

  static Future<File> writeRaceCache(cache) async {
    final file = await CacheHelper._localFile;
    
    return file.writeAsString('$cache');
  }

  static Future<String> readRaceCache() async {
    try {
      final file = await CacheHelper._localFile;

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If we encounter an error, return null
      print(e);
      return null;
    }
  }

  static Future<bool> checkFile() async {
    File file = await CacheHelper._localFile;
    if(file.existsSync()) {
      return file.length().then((len) => len > 5);
    } else {
      return false;
    }
  }
}

class ApiHelper {
  
  static Future<String> getRaces() async {
    var httpClient = new HttpClient();
    var uri = new Uri.https("ergast.com","/api/f1/2018.json");
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var json = await response.transform(UTF8.decoder).join();
      CacheHelper.writeRaceCache(json);
      return JSON.decode(json);
    } else {
      return 'Error getting IP address:\nHttp status ${response.statusCode}';
    }
    //return res;
  }
  
}
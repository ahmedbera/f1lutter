import 'package:flutter/material.dart';
import 'race_card.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'F1utter',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'F1utter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() {
    return new _MyHomePageState();
  }
  
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = true;
  Race closestRace;
  Duration countDown = new Duration();
  String remainingDays = "";
  String remainingMinutes = "";
  String remainingHours = "";
  String remainingSeconds = "";
  Duration oneSecond = new Duration(seconds: 1);
  List raceList = new List();

  TextStyle countdownIntStyle = new TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white);
  TextStyle countdownStrStyle = new TextStyle(fontSize: 16.0, color: Colors.white70);
  TextStyle smallTextStyle = new TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.white70);

  var res;
  
  getRaces() async {
    var httpClient = new HttpClient();
    var uri = new Uri.https("ergast.com","/api/f1/2018.json");
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var json = await response.transform(UTF8.decoder).join();
      res = JSON.decode(json);
      var races = res["MRData"]["RaceTable"]["Races"];
      for (var race in races) {
        print(race["Circuit"]);
        Race _race = new Race(race["Circuit"]["circuitId"], race["raceName"], race["date"], race["time"], race["Circuit"]["Location"]["locality"], race["Circuit"]["Location"]["country"]);
        if(closestRace == null && !_race.isCompleted) {
          setState(() {
            closestRace = _race;
          });
        }
        raceList.add(_race);
        _calculateRemaningTime();
      }
    } else {
      res = 'Error getting IP address:\nHttp status ${response.statusCode}';
    }


  }

  _calculateRemaningTime() {
    new Timer.periodic(oneSecond, (Timer t) {
      setState((){
        countDown = closestRace.raceTime.toUtc().difference(new DateTime.now().toUtc()).abs();
        remainingDays = countDown.inDays.toString();
        remainingHours = (countDown.inHours % 24).toString();
        remainingMinutes = (-countDown.inMinutes % 60).toString();
        remainingSeconds = (countDown.inSeconds % 60).toString();
      });
    });
    setState(() {
      isLoading = false;
    });
  }


  @override
  initState() {
    super.initState();
    getRaces();
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Column(
        children: <Widget>[
          this.isLoading ? new Text("Loading") :
          new Container(
            color: Colors.grey.shade800,
            child: new Padding(
              padding: new EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child : new Row(
                children: <Widget>[
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          new Image.asset('assets/flags/'+ closestRace.country+'.png', height: 16.0,),
                          new Text(" " + closestRace.city + " ", style: smallTextStyle),
                          new Text(closestRace.country, style: smallTextStyle)
                        ],
                      ),
                      new Container(
                        margin: new EdgeInsets.symmetric(vertical: 4.0),
                        child: new Column(
                          children: <Widget>[
                            new Text(closestRace.title, style: new TextStyle(fontSize: 22.0, color: Colors.white)),
                            new Text(closestRace.raceTime.toLocal().toString(), style: new TextStyle(fontSize: 18.0, color: Colors.white70)),
                          ],
                        ),
                      ),
                      new Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          new Text(remainingDays, style: countdownIntStyle),
                          new Text(" D ", style: countdownStrStyle,),
                          new Text(remainingHours, style: countdownIntStyle),
                          new Text(" H ", style: countdownStrStyle,),
                          new Text(remainingMinutes, style: countdownIntStyle),
                          new Text(" M ", style: countdownStrStyle,),
                          new Text(remainingSeconds, style: countdownIntStyle),
                          new Text(" S ", style: countdownStrStyle)
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          new Flexible (
            child: new ListView.builder(
              itemCount: raceList.length,
              itemBuilder: (context,int index) {
                Race currentRace = raceList[index];
                return new RaceCard(race: currentRace);
              },
            ),
          ),
        ],
      ),
    );
  }
}

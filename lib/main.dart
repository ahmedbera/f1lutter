import 'package:flutter/material.dart';
import 'race_card.dart';
import 'dart:convert';
import 'cache.dart';
import 'current_race.dart';
import 'flag_background.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'F1utter',
      home: new MyHomePage(title: 'F1utter', swatch: Colors.blue),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.swatch}) : super(key: key);

  final String title;
  final ColorSwatch swatch;

  @override
  _MyHomePageState createState() {
    return new _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  Brightness brightness = Brightness.light;
  bool isLoading = true;
  Race closestRace;
  Duration countDown = new Duration();
  String remainingDays = "";
  String remainingMinutes = "";
  String remainingHours = "";
  String remainingSeconds = "";
  Duration oneSecond = new Duration(seconds: 1);
  List raceList = new List();
 
  instantiateRaces(races) {
    races = races["MRData"]["RaceTable"]["Races"];

    for (var race in races) {
      Race _race = new Race(
        race["Circuit"]["circuitId"], 
        race["raceName"], race["date"], 
        race["time"], 
        race["Circuit"]["Location"]["locality"], 
        race["Circuit"]["Location"]["country"]
      );
      
      if(closestRace == null && !_race.isCompleted) {
        setState(() {
          closestRace = _race;
          isLoading = false;
        });
      }
      raceList.add(_race);
    }
  }
  
  getRaces() async {
    CacheHelper.checkFile().then((fileExists) {
      if(fileExists) {
        CacheHelper.readRaceCache().then((json) {
          var races = JSON.decode(json);
          instantiateRaces(races);
        });
      } else {
        ApiHelper.getRaces().then((res) {
          instantiateRaces(res);
        });
      }
    });
  }

  _toggleTheme() {
    if(this.brightness == Brightness.light) {
      setState(() {
        this.brightness = Brightness.dark;
      });
    } else {
      setState(() {
        this.brightness = Brightness.light;
      });
    }
  }

  void _handleRaceTap(Race race) {
    setState(() {
      this.closestRace = race;
    });
  }

  @override
  initState() {
    super.initState();
    getRaces();
  }
  
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData( 
        brightness: brightness,
        primarySwatch: widget.swatch,
        accentColor: Colors.tealAccent,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
           actions: <Widget>[
             new IconButton(
               icon: new Icon(Icons.lightbulb_outline),
               tooltip: "Toggle Theme",
               onPressed: this._toggleTheme,
             )
           ],
        ),
        body: new Column(
          children: <Widget>[
            this.isLoading ? new Text("Loading") :
            new Container(
              color: Colors.grey.shade800,
              child: new Stack(
                children: <Widget>[
                  new Positioned(
                    left: 0.0,
                    right: 0.0,
                    bottom: 0.0,
                    top: 0.0,
                    child: new FlagBackground(closestRace: this.closestRace)
                  ),
                  this.closestRace == null ? 
                    null : 
                    new CurrentRace(race: this.closestRace),
                ],
              ),
            ),
            new Flexible (
              child: new ListView.builder(
                itemCount: raceList.length,                 
                itemBuilder: (context,int index) {
                  Race currentRace = raceList[index];
                  return new RaceCard(race: currentRace, onChanged: this._handleRaceTap);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

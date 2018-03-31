import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:f1utter/race_card.dart';
import 'package:f1utter/cache.dart';
import 'package:f1utter/current_race.dart';
import 'package:f1utter/flag_background.dart';
import 'package:f1utter/api.dart';
import 'package:f1utter/models/Race.dart';

class CountdownPage extends StatefulWidget {
  CountdownPage({Key key}) : super(key: key);

  @override
  _CountdownPageState createState() {
    return new _CountdownPageState();
  }
}

class _CountdownPageState extends State<CountdownPage> {
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
 
  instantiateRaces(res) {
    res = json.decode(res);
    var races = res["MRData"]["RaceTable"]["Races"];

    for (var race in races) {
      Race _race = new Race(
        race["Circuit"]["circuitId"], 
        race["round"],
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
          instantiateRaces(json);
        });
      } else {
        ApiHelper.getRaces().then((res) {
          instantiateRaces(res);
        });
      }
    }); 
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
    return new Column(
      children: <Widget>[
        this.isLoading ? new Center(child: new CircularProgressIndicator()) :
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
    );
  }
}

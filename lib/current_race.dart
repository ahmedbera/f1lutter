import 'package:flutter/material.dart';
import 'race_card.dart';
import 'dart:async';

class CurrentRace extends StatefulWidget {
  CurrentRace({Key key, this.race}) : super(key: key);

  final Race race;

  @override
  _CurrentRaceState createState() {
    return new _CurrentRaceState();
  }
}

class _CurrentRaceState extends State<CurrentRace> {  
  Duration countDown = new Duration();
  String remainingDays = "";
  String remainingMinutes = "";
  String remainingHours = "";
  String remainingSeconds = "";
  Duration oneSecond = new Duration(seconds: 1);
  Timer timer;

  TextStyle countdownIntStyle = new TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white);
  TextStyle countdownStrStyle = new TextStyle(fontSize: 16.0, color: Colors.white70);
  TextStyle smallTextStyle = new TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.white70);
  
  void _updateRemainingTime() {
    setState(() {
      countDown = widget.race.raceTime.toUtc().difference(new DateTime.now().toUtc()).abs();
      remainingDays = countDown.inDays.toString();
      remainingHours = (countDown.inHours % 24).toString();
      remainingMinutes = (countDown.inMinutes % 60).toString();
      remainingSeconds = (countDown.inSeconds % 60).toString();
    });
  }

  void _initTimer() {
    this.timer = new Timer.periodic(oneSecond, (Timer t) {
      _updateRemainingTime();
    });
  }


  @override
  void initState() {
    this._updateRemainingTime();
    super.initState();
    this._initTimer();
  }

  @override
  void dispose() {
    super.dispose();
    this.timer.cancel();
  }
  

  @override
  Widget build(BuildContext context) {
  
    return new Container(
      padding: new EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child : new Row(
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Flag + Country + City
              new Row(
                children: <Widget>[
                  new Image.asset('assets/flags/'+ widget.race.country+'.png', height: 16.0,),
                  new Text(" " + widget.race.city + ", ", style: smallTextStyle),
                  new Text(widget.race.country, style: smallTextStyle)
                ],
              ),
              // Name, Date
              new Container(
                margin: new EdgeInsets.symmetric(vertical: 4.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(widget.race.title, style: new TextStyle(fontSize: 22.0, color: Colors.white)),
                    new Text(widget.race.raceTime.toLocal().toString(), style: new TextStyle(fontSize: 18.0, color: Colors.white70)),
                  ],
                ),
              ),
              // Countdown
              widget.race.isCompleted ?
                new Text("Race Completed", style: countdownIntStyle) :
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
    );
  }
}
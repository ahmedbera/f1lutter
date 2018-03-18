import 'package:flutter/material.dart';

class Race {
  String id;
  String title;
  String date;
  String time;
  String country;
  String city;
  DateTime raceTime;
  bool isCompleted = false;

  Race(this.id, this.title, this.date, this.time, this.city, this.country) {
    try {
      raceTime = DateTime.parse(date + " " + time).toLocal();
      if(raceTime.difference(new DateTime.now()) < new Duration(seconds: 1)) {
        this.isCompleted = true;
      }
    } catch (e) {
      raceTime = new DateTime(2018);
      print(e);
    }
  }

}

class RaceCard extends StatefulWidget{
  RaceCard({Key key, this.race, this.onChanged}) : super(key: key);

  final Race race;
  final ValueChanged<Race> onChanged;

  @override
  _RaceCardState createState() => new _RaceCardState();
}

class _RaceCardState extends State<RaceCard> {
  Duration countDown = new Duration();
  String _days = "";

  void _handleTap() {
    widget.onChanged(this.widget.race);
  }

  void _calculateRemainingDays() {
    if(!mounted)
      return;
      setState((){
        countDown = widget.race.raceTime.toUtc().difference(new DateTime.now().toUtc()).abs();
        _days = countDown.inDays.toString();
    });
  }

  @override
  initState(){
    super.initState();
    _calculateRemainingDays();
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: this._handleTap,
      child: new Container(
        decoration: new BoxDecoration(border: new Border(bottom: new BorderSide(color: Theme.of(context).dividerColor))),
        child: new Padding(padding: new EdgeInsets.all(12.0),
          child:new Row(
            children: <Widget>[
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 8.0),
                width: 90.0,
                height: 48.0,
                child: new Image.asset(
                  'assets/flags/' + widget.race.country + '.png',
                  height: 48.0,
                  width: 90.0,
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.fill,
                ),
              ),
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(widget.race.title, textAlign: TextAlign.left,),
                  new Text(widget.race.raceTime.toLocal().toString()),
                  widget.race.isCompleted ?
                    new Text("Race Completed") :
                    new Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      new Text(_days, style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                      new Text(" Days ", style: new TextStyle(fontSize: 18.0),)
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      )
    );
  }

}
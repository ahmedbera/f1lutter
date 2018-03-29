import 'package:flutter/material.dart';
import 'package:f1utter/models/Race.dart';
import 'package:f1utter/pages/raceResults_page.dart';

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
    return new Container(
      decoration: new BoxDecoration(border: new Border(bottom: new BorderSide(color: Theme.of(context).dividerColor))),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Expanded (
            child: new InkWell(
              onTap: this._handleTap,
              child: new Padding(
                padding: new EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Container(
                      margin: new EdgeInsets.only(right: 8.0),
                      width: 90.0,
                      height: 48.0,
                      child: new Image.asset(
                        'assets/flags/' + widget.race.country + '.png',
                        width: 90.0,
                        height: 48.0,
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
              )
            ),
          ),
          this.widget.race.isCompleted ? 
            new FlatButton(
              child: new Text("Results"),
              onPressed: () {
                Navigator.push(context, new MaterialPageRoute(builder: (context) => new RaceResultPage(raceData: this.widget.race)));
              },
            )
          : new Container()
        ],
      ),
    );
  }
}
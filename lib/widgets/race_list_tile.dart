import 'package:flutter/material.dart';
import 'package:f1lutter/models/race.dart';
import 'package:f1lutter/static/country_code.dart';
import 'package:dash_flags/dash_flags.dart';

class RaceListTile extends StatefulWidget {
  RaceListTile({required this.race, required this.onChanged}) : super();

  final Race race;
  final ValueChanged<Race> onChanged;

  @override
  _RaceListTileState createState() => new _RaceListTileState();
}

class _RaceListTileState extends State<RaceListTile> {
  Duration countDown = new Duration();
  String _days = "";

  void _handleTap() {
    widget.onChanged(this.widget.race);
  }

  void _calculateRemainingDays() {
    if (!mounted) return;
    setState(() {
      countDown = widget.race.raceTime.toUtc().difference(new DateTime.now().toUtc()).abs();
      _days = countDown.inDays.toString();
    });
  }

  @override
  initState() {
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
          new Expanded(
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
                        height: 60.0,
                        child: CountryFlag(country: Country.fromCode(CountryCodeByString.getCode(widget.race.country))),
                      ),
                      new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                            widget.race.title,
                            textAlign: TextAlign.left,
                          ),
                          new Text(MaterialLocalizations.of(context).formatFullDate(widget.race.raceTime.toLocal())),
                          widget.race.isCompleted
                              ? new Text("Race Completed")
                              : new Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    new Text(_days, style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                                    new Text(
                                      " Days ",
                                      style: new TextStyle(fontSize: 18.0),
                                    )
                                  ],
                                ),
                        ],
                      ),
                    ],
                  ),
                )),
          ),
          this.widget.race.isCompleted
              ? new TextButton(
                  child: new Text("Results"),
                  onPressed: () {
                    // Navigator.push(context, new MaterialPageRoute(builder: (context) => new RaceResultPage(raceData: this.widget.race)));
                  },
                )
              : new Container()
        ],
      ),
    );
  }
}

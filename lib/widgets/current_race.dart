import 'package:dash_flags/dash_flags.dart';
import 'package:f1lutter/static/country_code.dart';
import 'package:flutter/material.dart';
import 'package:f1lutter/models/race.dart';
import 'dart:async';

import 'package:intl/intl.dart';

class CurrentRace extends StatefulWidget {
  CurrentRace({required this.race}) : super();

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
  bool isExpanded = false;
  late Timer timer;

  TextStyle countdownIntStyle =
      new TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, textBaseline: TextBaseline.alphabetic);
  TextStyle countdownStrStyle = new TextStyle(fontSize: 16.0, textBaseline: TextBaseline.alphabetic);
  TextStyle smallTextStyle =
      new TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, textBaseline: TextBaseline.alphabetic);

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

  toggleCard() {
    setState(() {
      isExpanded = !isExpanded;
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
    TextStyle countdownIntStyle = new TextStyle(
      fontSize: 36.0,
      fontWeight: FontWeight.bold,
      textBaseline: TextBaseline.alphabetic,
      color: Theme.of(context).colorScheme.tertiary,
    );
    TextStyle countdownStrStyle = new TextStyle(
      fontSize: 32.0,
      textBaseline: TextBaseline.alphabetic,
      color: Theme.of(context).colorScheme.tertiary,
    );

    TextStyle smallTextStyle = new TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      textBaseline: TextBaseline.alphabetic,
      color: Theme.of(context).colorScheme.tertiary,
    );

    return new InkWell(
        onTap: toggleCard,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: new Padding(
          padding: new EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          // color: Colors.transparent,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Flag + Country + City
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      new CountryFlag(
                          country: Country.fromCode(CountryCodeByString.getCode(widget.race.country)), height: 24.0),
                      new Text(" " + widget.race.city + ", ", style: smallTextStyle),
                      new Text(widget.race.country, style: smallTextStyle),
                    ],
                  ),
                  Icon(isExpanded ? Icons.expand_less : Icons.expand_more)
                ],
              ),
              // Name, Date
              Padding(padding: EdgeInsets.all(4.0)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.race.title,
                    style: new TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      Padding(padding: EdgeInsets.all(2.0)),
                      Text(
                        MaterialLocalizations.of(context).formatFullDate(widget.race.raceTime.toLocal()),
                        style: new TextStyle(fontSize: 18.0, color: Theme.of(context).colorScheme.secondary),
                      ),
                    ],
                  )
                ],
              ),
              Padding(padding: EdgeInsets.all(4.0)),
              // Countdown
              widget.race.isCompleted
                  ? new Text("Race Completed", style: countdownIntStyle)
                  : new Row(
                      textBaseline: TextBaseline.alphabetic,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: <Widget>[
                        new Text(
                          remainingDays,
                          style: countdownIntStyle,
                        ),
                        new Padding(
                          padding: new EdgeInsets.only(right: 6.0, left: 2.0),
                          child: new Text(
                            "D ",
                            style: countdownStrStyle,
                          ),
                        ),
                        new Text(remainingHours, style: countdownIntStyle),
                        new Padding(
                          padding: new EdgeInsets.only(right: 6.0, left: 2.0),
                          child: new Text(
                            "H ",
                            style: countdownStrStyle,
                          ),
                        ),
                        new Text(remainingMinutes, style: countdownIntStyle),
                        new Padding(
                          padding: new EdgeInsets.only(right: 6.0, left: 2.0),
                          child: new Text(
                            "M ",
                            style: countdownStrStyle,
                          ),
                        ),
                        new Text(remainingSeconds, style: countdownIntStyle),
                        new Padding(
                          padding: new EdgeInsets.only(right: 6.0, left: 2.0),
                          child: new Text("S ", style: countdownStrStyle),
                        ),
                      ],
                    ),
              isExpanded
                  ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Divider(),
                      ...widget.race.sessionList
                          .map(
                            (e) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text(
                                e.name,
                                style: new TextStyle(fontSize: 18.0, color: Theme.of(context).colorScheme.secondary),
                              ),
                              Text(
                                DateFormat('EEEE - H:mm').format(e.sessionStart.toLocal()).toString(),
                                style: new TextStyle(fontSize: 18.0, color: Theme.of(context).colorScheme.secondary),
                              )
                            ]),
                          )
                          .toList(),
                    ])
                  : Container()
            ],
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:f1utter/models/Race.dart';
import 'package:f1utter/api.dart';

class RaceResultPage extends StatefulWidget {
  RaceResultPage({Key key, this.raceData }) : super(key: key);

  final Race raceData;

  @override
  State<StatefulWidget> createState() => new RaceResultsPageState();
}

class RaceResultsPageState extends State<RaceResultPage> {
  
  @override
  void initState() {
    super.initState();
    ApiHelper.getRaceResultsByRound(year: widget.raceData.raceTime.year.toString(), round: widget.raceData.round).then((res) {

    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Second Screen"),
      ),
      body: new Center(
        child: new RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: new Text(widget.raceData.round),
        ),
      ),
    );
  }

}
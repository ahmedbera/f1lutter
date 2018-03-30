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
  List<RaceResult> raceResults = new List();
  List<DataRow> dataRows = new List();

  @override
  void initState() {
    super.initState();
    ApiHelper.getRaceResultsByRound(year: widget.raceData.raceTime.year.toString(), round: widget.raceData.round).then((res) {

      List<DataRow> rows = new List();
      
      for(var row in res) {
        rows.add(
          new DataRow(
            cells: [
              new DataCell(new Text(row.position)),
              new DataCell(new Text(row.driver.givenName + " " + row.driver.familyName)),
              new DataCell(new Text(row.grid)),
              new DataCell(new Text(row.laps)),
              new DataCell(new Text(row.status)),
              new DataCell(new Text(row.time)),
              new DataCell(new Text(row.fastestLapTime)),
              new DataCell(new Text(row.avgSpeed))
            ]
          )
        );
      }
      
      this.setState(() {
        raceResults = res;
        this.dataRows = rows;
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.raceData.title),
      ),
      body: new SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: new SingleChildScrollView(
         scrollDirection: Axis.vertical,
          child: new DataTable(
            columns: [
              new DataColumn(label: new Text("Pos")),
              new DataColumn(label: new Text("Driver")),
              new DataColumn(label: new Text("Grid")),
              new DataColumn(label: new Text("Laps")),
              new DataColumn(label: new Text("Status")),
              new DataColumn(label: new Text("Time")),
              new DataColumn(label: new Text("Fastest Lap")),
              new DataColumn(label: new Text("Average Speed")),
            ],
            rows: this.dataRows,
          ),
        )
      ),
    );
  }

}
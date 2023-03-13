import 'package:f1lutter/models/race_result.dart';
import 'package:flutter/material.dart';
import 'package:f1lutter/models/race.dart';
import 'package:f1lutter/api.dart';

class RaceResultPage extends StatefulWidget {
  RaceResultPage({required this.raceData});

  final Race raceData;

  @override
  State<StatefulWidget> createState() => new RaceResultsPageState();
}

class RaceResultsPageState extends State<RaceResultPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  List<DataRow> dataRows = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    Api.getRaceResultsByRound(widget.raceData.raceTime.year.toString(), widget.raceData.round).then((res) {
      RaceResultList result = RaceResultList.fromJson(res);
      _fillRows(result);
    }).catchError((onError) {
      // _snackBar(onError);
    });
  }

  void _fillRows(RaceResultList res) {
    List<DataRow> rows = [];

    for (RaceResult row in res.resultList) {
      rows.add(new DataRow(cells: [
        new DataCell(new Text(row.position)),
        new DataCell(new Text(row.driver.givenName + " " + row.driver.familyName)),
        new DataCell(new Text(row.grid)),
        new DataCell(new Text(row.laps)),
        new DataCell(new Text(row.status)),
        new DataCell(new Text(row.time)),
        new DataCell(new Text(row.fastestLapTime)),
        new DataCell(new Text(row.avgSpeed))
      ]));
    }

    this.setState(() {
      this.dataRows = rows;
      this.isLoading = false;
    });
  }

  // void _snackBar(msg) {
  //   scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(msg.toString())));
  // }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: this.scaffoldKey,
        appBar: new AppBar(
          title: new Text(widget.raceData.title),
        ),
        body: this.isLoading
            ? new Center(child: new CircularProgressIndicator())
            : new Builder(
                builder: (BuildContext context) {
                  return new SingleChildScrollView(
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
                      ));
                },
              ));
  }
}

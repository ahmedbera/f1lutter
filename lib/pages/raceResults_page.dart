import 'package:flutter/material.dart';
import 'package:f1utter/models/Race.dart';
import 'package:f1utter/api.dart';
import 'package:f1utter/persistent_state.dart';

class RaceResultPage extends StatefulWidget {
  RaceResultPage({Key key, this.raceData }) : super(key: key);

  final Race raceData;

  @override
  State<StatefulWidget> createState() => new RaceResultsPageState();
}

class RaceResultsPageState extends State<RaceResultPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  List<DataRow> dataRows = new List();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if(GlobalData.raceResults.value[widget.raceData.round] != null) {
      _fillRows();
      return;
    }
    
    GlobalData.raceResults.addListener(_fillRows);

    ApiHelper.getRaceResultsByRound(year: widget.raceData.raceTime.year.toString(), round: widget.raceData.round).then((res) {
      //GlobalData.raceResults.value = res;
    }).catchError((onError){
      _snackBar(onError);
    });
  }

  void _fillRows() {
    var res = GlobalData.raceResults.value[widget.raceData.round];
        
    if(res?.length == 0) {
      return; 
    }
    
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
        this.dataRows = rows;
        this.isLoading = false;
    });
  }

  void _snackBar(msg) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(msg.toString())));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: this.scaffoldKey,
      appBar: new AppBar(
        title: new Text(widget.raceData.title),
      ),
      body: this.isLoading ? 
      new Center(child: new CircularProgressIndicator()) :
      new Builder(
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
            )
          );
        },
      )
    );
  }
}
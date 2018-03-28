import 'package:flutter/material.dart';
import 'package:f1utter/api.dart';
import 'package:f1utter/models/Driver.dart';
import 'dart:convert';

class StandingsPage extends StatefulWidget {
  StandingsPage({Key key}) : super(key: key);

  @override
  _StandingsPageState createState() {
    return new _StandingsPageState();
  }
}

class _StandingsPageState extends State<StandingsPage> {
  List<StandingsModel> standingsList = new List();
  String round = "0";
  String year = "2018";

  bool isExpanded = false;

  void _driverStandings() {
    ApiHelper.getDriverStandings().then((res) {
      var response = JSON.decode(res);
      var standings = response["MRData"]["StandingsTable"]["StandingsLists"][0];

      var driverStandings = standings["DriverStandings"];

      for(var driver in driverStandings) {
        this.standingsList.add(
          new StandingsModel(
            new Driver(
              driver["Driver"]["driverId"],
              driver["Driver"]["permanentNumber"],
              driver["Driver"]["code"],
              driver["Driver"]["familyName"],
              driver["Driver"]["givenName"],
              driver["Driver"][new DateTime.now()],
              driver["Driver"]["nationality"]
            ),
            driver["position"],
            driver["points"],
            driver["wins"],          
          ),
        );
        
        this.setState(() {
          this.standingsList = standingsList;
          this.round = standings["round"];
          this.year = standings["season"];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _driverStandings();
  }
    
  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Container(
          padding: new EdgeInsets.all(4.0),
          color: Theme.of(context).brightness == Brightness.light ? Colors.orangeAccent.shade700 : Colors.transparent,
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Expanded(
                child: new Card(
                  child: new Padding(
                    padding: new EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                    child: new Text("${this.year} | Round: ${this.round} | Driver Standings"),
                  )
                ),
              ),
            ],
          ),
        ),
        new Flexible (
          child: new ListView.builder(
            itemCount: standingsList.length,                 
            itemBuilder: (context,int index) {
              StandingsModel currentDriver = standingsList[index];
              return new Container(
                color: index % 2 == 1 ? Colors.grey.shade100 : Colors.transparent,
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Padding(
                      padding: new EdgeInsets.all(6.0),
                      child: new Container(
                        alignment: Alignment.centerRight,
                        width: 24.0,
                        child: new Text( currentDriver.position, 
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0
                          ),
                        ),
                      ),
                    ),
                    new Expanded(
                      child: new Padding(
                        padding: new EdgeInsets.all(8.0),
                        child: new Text("${currentDriver.driver.givenName} ${currentDriver.driver.familyName}", textAlign: TextAlign.start,),
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.all(8.0),
                      child: new Text(currentDriver.points + " pts", textAlign: TextAlign.end,)
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}


class StandingsModel {
  Driver driver;
  String position;
  String points;
  String wins;
  
  StandingsModel(this.driver, this.position, this.points, this.wins);
}
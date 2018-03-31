import 'package:flutter/material.dart';
import 'package:f1utter/api.dart';
import 'package:f1utter/models/Driver.dart';
import 'package:f1utter/models/Constructors.dart';

class StandingsPage extends StatefulWidget {
  StandingsPage({Key key}) : super(key: key);

  @override
  _StandingsPageState createState() {
    return new _StandingsPageState();
  }
}

class _StandingsPageState extends State<StandingsPage> {
  List<DriverStandingModel> driverStandingsList = new List();
  List<ConstructorStandingModel> constructorStandingsList = new List();
  String round = "0";
  String year = "2018";
  String standingType = "Driver Standings";

  bool isLoading = true;

  void _driverStandings() {
    ApiHelper.getDriverStandings().then((res) {
        this.setState(() {
          this.driverStandingsList = res["standings"];
          this.round = res["round"];
          this.year = res["year"];
          this.isLoading = false;
        });
    });
  }

  void _constructorStandings() {
    ApiHelper.getConstructorStandings().then((res) {
        this.setState(() {
          this.constructorStandingsList = res["standings"];
        });
    });
  }

  _standingTypeSelected(String type) {
    print(type);
    this.setState((){
      this.standingType = type;
    });
  }

  Widget _getStandings() {
    return this.isLoading ? new Center(child: new CircularProgressIndicator()) :
    new Flexible (
      child: new ListView.builder(
        itemCount: this.standingType == "Driver Standings" ? driverStandingsList.length : constructorStandingsList.length,
        itemBuilder: (context,int index) {
          var currentItem;
          if(this.standingType == "Driver Standings") {
            currentItem = driverStandingsList[index];
          } else if(this.standingType == "Constructor Standings") {
            currentItem = constructorStandingsList[index];
          }
          return new Container(
            color: index % 2 == 1 ?
              Theme.of(context).brightness == Brightness.light ? Colors.grey.shade100 : Colors.grey.shade800 : 
              Colors.transparent,
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.all(6.0),
                  child: new Container(
                    alignment: Alignment.centerRight,
                    width: 24.0,
                    child: new Text(currentItem.position, textAlign: TextAlign.center, style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                  ),
                ),
                new Expanded(
                  child: new Padding(
                    padding: new EdgeInsets.all(8.0),
                    child: this.standingType == "Driver Standings" ? 
                      new Text("${currentItem.driver.givenName} ${currentItem.driver.familyName}", textAlign: TextAlign.start) :
                      new Text("${currentItem.constructor.name}", textAlign: TextAlign.start)
                  ),
                ),
                new Padding(
                  padding: new EdgeInsets.all(8.0),
                  child: new Text(currentItem.points + " pts", textAlign: TextAlign.end,)
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _driverStandings();
    _constructorStandings();
  }
    
  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Container(
          padding: new EdgeInsets.all(4.0),
          color: Theme.of(context).accentColor,
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new FlatButton(
                onPressed: () => print("hello"),
                child: new Text("Round: " + this.round),
              ),
              new Expanded(
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new Text(this.standingType, style: new TextStyle(fontWeight: FontWeight.w500),),
                    new Flexible(
                      child: new PopupMenuButton(
                        onSelected: _standingTypeSelected,
                        itemBuilder: (BuildContext context) {
                          return [
                            new PopupMenuItem(
                              value: "Driver Standings",
                              child: new Text("Driver Standings"),
                            ),
                            new PopupMenuItem(
                              value: "Constructor Standings",
                              child: new Text("Constructor Standings"),
                            ),
                          ];
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _getStandings(),
      ],
    );
  }
}

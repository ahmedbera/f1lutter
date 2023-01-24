import 'dart:convert';
import 'package:f1lutter/api.dart';
import 'package:f1lutter/models/constructor.dart';
import 'package:f1lutter/models/driver.dart';
import 'package:f1lutter/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StandingsRoute extends StatefulWidget {
  const StandingsRoute({super.key});

  @override
  State<StandingsRoute> createState() => _StandingsRouteState();
}

class _StandingsRouteState extends State<StandingsRoute> {
  int _year = new DateTime.now().year;
  List<DriverStandingModel> driversStandingList = [];
  List<ConstructorStandingModel> constructorStandingList = [];
  TabType displayedStandings = TabType.Driver;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var settings = Provider.of<Settings>(context, listen: false);
      settings.setScaffoldActions([Container()]);
    });
    getDriversStandings();
    getConstructorStandings();
  }

  getDriversStandings() async {
    var res = await Api.getDriversStandings(_year);
    var response = json.decode(res);
    List<DriverStandingModel> standingsList = [];

    var standings = response["MRData"]["StandingsTable"]["StandingsLists"][0];

    var driverStandings = standings["DriverStandings"];

    for (var driver in driverStandings) {
      standingsList.add(new DriverStandingModel(
        new Driver.fromJson(driver["Driver"]),
        driver["position"],
        driver["points"],
        driver["wins"],
      ));
    }

    this.setState(() {
      driversStandingList = standingsList;
    });
  }

  getConstructorStandings() async {
    var res = await Api.getConstructorsStandings(_year);
    var response = json.decode(res);
    List<ConstructorStandingModel> standingsList = [];

    var standings = response["MRData"]["StandingsTable"]["StandingsLists"][0];

    var constructorStandings = standings["ConstructorStandings"];

    for (var ctor in constructorStandings) {
      standingsList.add(new ConstructorStandingModel(
        new Constructor.fromJson(ctor["Constructor"]),
        ctor["position"],
        ctor["points"],
        ctor["wins"],
      ));
    }

    this.setState(() {
      constructorStandingList = standingsList;
    });
  }

  setTab(TabType type) {
    this.setState(() {
      displayedStandings = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    setTab(TabType.Driver);
                  },
                  child: Text("Drivers")),
              TextButton(
                  onPressed: () {
                    setTab(TabType.Constructor);
                  },
                  child: Text("Constructors")),
            ],
          ),
        ),
        Flexible(
          fit: FlexFit.tight,
          child: displayedStandings == TabType.Driver
              ? ListView.builder(
                  itemCount: driversStandingList.length,
                  itemBuilder: (context, index) {
                    DriverStandingModel item = driversStandingList[index];
                    return ListTile(
                      leading: Text(item.position),
                      title: Text(item.driver.getName()),
                      trailing: Text(item.points),
                    );
                  },
                )
              : ListView.builder(
                  itemCount: constructorStandingList.length,
                  itemBuilder: (context, index) {
                    ConstructorStandingModel item = constructorStandingList[index];
                    return ListTile(
                      leading: Text(item.position),
                      title: Text(item.constructor.name),
                      trailing: Text(item.points),
                    );
                  },
                ),
        )
      ],
    );
  }
}

enum TabType { Driver, Constructor }

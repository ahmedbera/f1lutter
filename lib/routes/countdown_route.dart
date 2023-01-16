import 'package:f1lutter/widgets/current_race.dart';
import 'package:f1lutter/widgets/race_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:f1lutter/api.dart';
import 'package:f1lutter/models/race.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:f1lutter/models/settings_model.dart';

class CountdownRoute extends StatefulWidget {
  const CountdownRoute({super.key});

  @override
  State<CountdownRoute> createState() => _CountdownRouteState();
}

class _CountdownRouteState extends State<CountdownRoute> {
  List raceList = [];
  late Race closestRace;
  bool isLoading = true;
  int _year = new DateTime.now().year;

  @override
  initState() {
    super.initState();
    getRaces();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var settings = Provider.of<Settings>(context, listen: false);
      settings.setScaffoldActions([
        IconButton(onPressed: getRaces, icon: Icon(Icons.refresh)),
      ]);
    });
  }

  instantiateRaces(res) {
    res = json.decode(res);
    var races = res["MRData"]["RaceTable"]["Races"];
    print(races);
    for (var race in races) {
      try {
        Race _race = new Race.fromJson(race);
        if (!_race.isCompleted && isLoading) {
          setState(() {
            closestRace = _race;
            isLoading = false;
          });
        }
        raceList.add(_race);
      } catch (e) {
        print("-----------------------");
        print(e);
        print("-----------------------");
      }
    }
  }

  getRaces() async {
    Api.getRacesByYear(_year).then((value) => instantiateRaces(value));
  }

  void _handleRaceTap(Race race, Settings context) {
    context.setColor(race.primaryColor);
    setState(() {
      this.closestRace = race;
    });
  }

  @override
  Widget build(BuildContext context) {
    Settings settingsState = Provider.of<Settings>(context, listen: true);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        isLoading
            ? Container(child: Center(child: Text("Loading....")))
            : Padding(padding: EdgeInsets.all(16.0), child: new CurrentRace(race: this.closestRace)),
        Flexible(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.zero,
                  bottomRight: Radius.zero,
                ),
              ),
              shadowColor: Colors.transparent,
              child: ListView.builder(
                itemCount: raceList.length,
                itemBuilder: (context, int index) {
                  Race currentRace = raceList[index];
                  return new RaceListTile(
                    race: currentRace,
                    onChanged: (Race race) {
                      this._handleRaceTap(race, settingsState);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

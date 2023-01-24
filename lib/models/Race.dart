import 'dart:ui';
import 'package:palette_generator/palette_generator.dart';
import 'package:f1lutter/static/country_code.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class Session {
  late DateTime sessionStart;
  late String name;

  Session(date, time, name) {
    this.sessionStart = DateTime.parse(date + "T" + time);
    this.name = name;
  }
}

class Race {
  String id = "";
  String circuitName = "";
  String round = "";
  String title = "";
  String date = "";
  String time = "";
  String city = "";
  String country = "";
  DateTime raceTime = DateTime(DateTime.now().year);
  bool isCompleted = false;
  List<Session> sessionList = [];
  late Session firstPractice;
  late Session secondPractice;
  late Session thirdPractice;
  late Session qualifying;
  late Session sprint;
  bool isSprintWeekend = false;
  late Session grandPrix;
  late Color primaryColor;

  Race(this.id, this.round, this.title, this.date, this.time, this.city, this.country) {
    _calculateDate();
  }

  Race.fromJson(race) {
    this.id = race["Circuit"]["circuitId"];
    this.circuitName = race["Circuit"]["circuitName"];
    this.round = race["round"];
    this.title = race["raceName"];
    this.date = race["date"];
    this.time = race["time"];
    this.city = race["Circuit"]["Location"]["locality"];
    this.country = race["Circuit"]["Location"]["country"];

    sessionList.add(Session(race["FirstPractice"]["date"], race["FirstPractice"]["time"], "Free Practice 1"));

    if (race["Sprint"] != null) {
      this.isSprintWeekend = true;
      sessionList.add(Session(race["Sprint"]["date"], race["Sprint"]["time"], "Sprint"));
      sessionList.add(Session(race["SecondPractice"]["date"], race["SecondPractice"]["time"], "Free Practice 2"));
    } else {
      sessionList.add(Session(race["SecondPractice"]["date"], race["SecondPractice"]["time"], "Free Practice 2"));
      sessionList.add(Session(race["ThirdPractice"]["date"], race["ThirdPractice"]["time"], "Free Practice 3"));
    }

    sessionList.add(Session(race["Qualifying"]["date"], race["Qualifying"]["time"], "Qualifying"));
    sessionList.add(Session(race["date"], race["time"], "Grand Prix"));

    PaletteGenerator.fromImageProvider(
      Svg('packages/dash_flags/assets/svgs/flags/countries/country-${CountryCodeByString.getCode(this.country)}.svg',
          size: Size(90, 60)),
    ).then((value) {
      this.primaryColor = value.paletteColors.first.color;
    });

    _calculateDate();
  }

  _calculateDate() {
    try {
      raceTime = DateTime.parse(this.date + " " + this.time).toLocal();
      if (raceTime.difference(new DateTime.now()) < new Duration(seconds: 1)) {
        this.isCompleted = true;
      }
    } catch (e) {
      raceTime = new DateTime(2018);
      print(e);
    }
  }
}

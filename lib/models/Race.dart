class Race {
  String id;
  String round;
  String title;
  String date;
  String time;
  String city;
  String country;
  DateTime raceTime;
  bool isCompleted = false;

  Race(this.id, this.round, this.title, this.date, this.time, this.city, this.country) {
    _calculateDate();
  }

  Race.fromJson(race) {
    this.id = race["Circuit"]["circuitId"];
    this.round = race["round"];
    this.title = race["raceName"];
    this.date = race["date"];
    this.time = race["time"];
    this.city = race["Circuit"]["Location"]["locality"];
    this.country = race["Circuit"]["Location"]["country"];
    _calculateDate();
  }

  _calculateDate() {
    try {
      raceTime = DateTime.parse(this.date + " " + this.time).toLocal();
      if(raceTime.difference(new DateTime.now()) < new Duration(seconds: 1)) {
        this.isCompleted = true;
      }
    } catch (e) {
      raceTime = new DateTime(2018);
      print(e);
    }
  }
  
}
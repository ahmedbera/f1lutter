class Race {
  String id;
  String round;
  String title;
  String date;
  String time;
  String country;
  String city;
  DateTime raceTime;
  bool isCompleted = false;

  Race(this.id, this.round, this.title, this.date, this.time, this.city, this.country) {
    try {
      raceTime = DateTime.parse(date + " " + time).toLocal();
      if(raceTime.difference(new DateTime.now()) < new Duration(seconds: 1)) {
        this.isCompleted = true;
      }
    } catch (e) {
      raceTime = new DateTime(2018);
      print(e);
    }
  }
}
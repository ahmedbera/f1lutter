class Driver {
  String driverId = "";
  String permanentNumber = "";
  String code = "";
  String givenName = "";
  String familyName = "";
  String nationality = "";

  Driver.fromJson(obj) {
    this.driverId = obj["driverId"];
    this.permanentNumber = obj["permanentNumber"];
    this.code = obj["code"];
    this.givenName = obj["givenName"];
    this.familyName = obj["familyName"];
    this.nationality = obj["nationality"];
  }

  String getName() {
    return this.givenName + " " + this.familyName;
  }

  Driver(this.driverId, this.permanentNumber, this.code, this.familyName, this.givenName, this.nationality);
}

class DriverStandingModel {
  Driver driver;
  String position;
  String points;
  String wins;

  DriverStandingModel(this.driver, this.position, this.points, this.wins);
}

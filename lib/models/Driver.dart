class DriverList {
  static Map driverList = new Map();

  static Driver driver({driverEntry}) {
    if(!driverList.containsKey(driverEntry["driverId"])) {
      driverList[driverEntry["driverId"]] = new Driver.fromJson(driverEntry);
    }
    return driverList[driverEntry["driverId"]];
  }
}

class Driver {
  String driverId;
  String permanentNumber;
  String code;
  String givenName;
  String familyName;
  DateTime dateOfBirth;
  String nationality;

  Driver.fromJson(obj) {
    this.driverId = obj["driverId"];
    this.permanentNumber = obj["permanentNumber"];
    this.code = obj["code"];
    this.givenName = obj["givenName"];
    this.familyName = obj["familyName"];
    this.dateOfBirth = new DateTime.now();
    this.nationality = obj["nationality"];
  }

  Driver(
    this.driverId,
    this.permanentNumber,
    this.code,
    this.familyName,
    this.givenName,
    this.dateOfBirth,
    this.nationality);

}

class DriverStandingModel {
  Driver driver;
  String position;
  String points;
  String wins;
  
  DriverStandingModel(this.driver, this.position, this.points, this.wins);
}
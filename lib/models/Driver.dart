class DriverList {
  static Map driverList = new Map();

  static Driver driver({driverEntry}) {
    if(driverList.containsKey(driverEntry["driverId"])) {
      return driverList[driverEntry["driverId"]];
    }
    driverList[driverEntry["driverId"]] = new Driver(
      driverEntry["driverId"],
      driverEntry["permanentNumber"],
      driverEntry["code"],
      driverEntry["familyName"],
      driverEntry["givenName"],
      new DateTime.now(),
      driverEntry["nationality"]
    );
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
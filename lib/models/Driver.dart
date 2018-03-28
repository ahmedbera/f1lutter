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
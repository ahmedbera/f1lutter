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

  Driver(this.driverId, this.permanentNumber, this.code, this.familyName,
      this.givenName, this.nationality);
}

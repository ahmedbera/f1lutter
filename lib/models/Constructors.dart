class ConstructorList {
  static Map constructorList = new Map();

  static Constructor constructor({constructorEntry}) {
    if(!constructorList.containsKey(constructorEntry["constructorId"])) {
      constructorList[constructorEntry["constructorId"]] = new Constructor.fromJson(constructorEntry);
    }
    return constructorList[constructorEntry["constructorId"]]; 
  }

}
class Constructor {
  String constructorId;
  String name;
  String nationality;

  Constructor.fromJson(obj) {
    this.constructorId = obj["constructorId"];
    this.name = obj["name"];
    this.nationality = obj["nationality"];
  }

  Constructor(
    this.constructorId,
    this.name,
    this.nationality);
}

class ConstructorStandingModel {
  Constructor constructor;
  String position;
  String points;
  String wins;
  
  ConstructorStandingModel(this.constructor, this.position, this.points, this.wins);
}
class Constructor {
  String constructorId;
  String name;
  String nationality;

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
const String playerTable = "playerTable";
const String idColumn = "idColumn";
const String nameColumn = "nameColumn";
const String ageColumn = "ageColumn";
const String positionColumn = "positionColumn";
const String nationalityColumn = "nationalityColumn";
const String clubColumn = "clubColumn";
const String shirtNumberColumn = "shirtNumberColumn";
const String dominantFootColumn = "dominantFootColumn";
const String marketValueColumn = "marketValueColumn";
const String imgColumn = "imgColumn";
const String ratingColumn = "ratingColumn"; 

class Player {
  int? id;
  String name;
  int? age;
  String? position;
  String? nationality;
  String? club;
  int? shirtNumber;
  String? dominantFoot;
  String? marketValue;
  String? img;
  double? rating; 

  Player({
    this.id,
    required this.name,
    this.age,
    this.position,
    this.nationality,
    this.club,
    this.shirtNumber,
    this.dominantFoot,
    this.marketValue,
    this.img,
    this.rating, 
  });

  Player.fromMap(Map<String, dynamic> map)
      : id = map[idColumn],
        name = map[nameColumn],
        age = map[ageColumn],
        position = map[positionColumn],
        nationality = map[nationalityColumn],
        club = map[clubColumn],
        shirtNumber = map[shirtNumberColumn],
        dominantFoot = map[dominantFootColumn],
        marketValue = map[marketValueColumn],
        img = map[imgColumn],
        rating = map[ratingColumn]; 

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      ageColumn: age,
      positionColumn: position,
      nationalityColumn: nationality,
      clubColumn: club,
      shirtNumberColumn: shirtNumber,
      dominantFootColumn: dominantFoot,
      marketValueColumn: marketValue,
      imgColumn: img,
      ratingColumn: rating, 
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Player(id: $id, name: $name, rating: $rating)";
  }
}
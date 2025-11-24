class Player {
  String? id;
  String name;
  int age;
  String position;
  String nationality;
  String club;
  int shirtNumber;
  String dominantFoot;
  String marketValue;
  String? img;
  double rating;

  Player({
    this.id,
    required this.name,
    required this.age,
    required this.position,
    required this.nationality,
    required this.club,
    required this.shirtNumber,
    required this.dominantFoot,
    required this.marketValue,
    this.img,
    required this.rating,
  });

  factory Player.fromMap(Map<String, dynamic> map, String documentId) {
    return Player(
      id: documentId,
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      position: map['position'] ?? '',
      nationality: map['nationality'] ?? '',
      club: map['club'] ?? '',
      shirtNumber: map['shirtNumber'] ?? 0,
      dominantFoot: map['dominantFoot'] ?? '',
      marketValue: map['marketValue'] ?? '',
      img: map['img'],
      rating: (map['rating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'position': position,
      'nationality': nationality,
      'club': club,
      'shirtNumber': shirtNumber,
      'dominantFoot': dominantFoot,
      'marketValue': marketValue,
      'img': img,
      'rating': rating,
    };
  }
}

class CardModel {
  int id;
  String name;
  String imagePath;
  int winCount;
  CardModel({
    required this.id,
    required this.name,
    required this.imagePath,
    this.winCount = 0,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json["id"],
      name: json["name"],
      imagePath: json["imagePath"],
      winCount: json["winCount"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "imagePath": imagePath,
      "winCount": winCount,
    };
  }
}

import 'package:gorsel_programlama_proje/models/card_model.dart';

class GameModel {
  int id;
  int round;
  int playCount;
  String name;
  String username;
  String description;
  String imagePath;
  List<CardModel> cards;
  GameModel({
    required this.id,
    required this.round,
    this.playCount = 0,
    required this.name,
    required this.username,
    required this.cards,
    required this.description,
    required this.imagePath,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json["id"],
      round: json["round"],
      name: json["name"],
      username: json["user"]["userName"],
      description: json["description"],
      imagePath: json["imagePath"],
      playCount: json["playCount"],
      cards:
          (json["cards"] as List)
              .map((cardJson) => CardModel.fromJson(cardJson))
              .toList(),
    );
  }

  //user kısmı eklenebilir
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "round": round,
      "name": name,
      "description": description,
      "imagePath": imagePath,
      "playCount": playCount,
      "cards": cards.map((e) => e.toJson()).toList(),
    };
  }
}

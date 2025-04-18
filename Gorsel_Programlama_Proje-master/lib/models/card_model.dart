class CardModel {
  int id;
  String name;
  String imagePath;
  CardModel({required this.id, required this.name, required this.imagePath});

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json["id"],
      name: json["name"],
      imagePath: json["imagePath"],
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "imagePath": imagePath};
  }
}

import 'dart:html' as html;
import 'package:gorsel_programlama_proje/models/card_model.dart';

class UploadCardModel extends CardModel {
  html.File? rawFile;
  UploadCardModel({
    this.rawFile,
    required super.id,
    required super.name,
    required super.imagePath,
  });

  factory UploadCardModel.fromCard(CardModel card) {
    return UploadCardModel(
      id: card.id,
      name: card.name,
      imagePath: card.imagePath,
    );
  }

  /*
  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "imagePath": imagePath};
  }
*/
}

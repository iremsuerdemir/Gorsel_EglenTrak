import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:gorsel_programlama_proje/models/game_model.dart';
import 'package:gorsel_programlama_proje/models/upload_card_model.dart';
import 'package:gorsel_programlama_proje/services/base_url.dart';
import 'package:gorsel_programlama_proje/services/user_service.dart';
import 'package:http/http.dart' as http;

class GameService {
  static Future<List<GameModel>?> getGames() async {
    final http.Response response = await http.get(
      Uri.parse('${BaseUrl.baseUrl}/Games'),
    );
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((e) => GameModel.fromJson(e))
          .toList();
    } else {
      return null;
    }
  }

  static Future<GameModel?> getGame(int id) async {
    final http.Response response = await http.get(
      Uri.parse("${BaseUrl.baseUrl}/Games/$id"),
    );
    if (response.statusCode == 200) {
      return GameModel.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  static Future<List<GameModel>> getUserGames() async {
    List<GameModel> games = [];
    final http.Response response = await http.get(
      Uri.parse("${BaseUrl.baseUrl}/Games/${UserService.user!.id}"),
    );

    if (response.statusCode != 200) {
      return games;
    }
    return (jsonDecode(response.body) as List<dynamic>)
        .map((e) => GameModel.fromJson(e))
        .toList();
  }

  static Future<void> uploadGameWithCards({
    required String name,
    required String description,
    required int round,
    required int userId,
    required UploadCardModel gameImage,
    required List<UploadCardModel> cards,
  }) async {
    var uri = Uri.parse('${BaseUrl.baseUrl}/Games/UploadGame');
    var request = http.MultipartRequest('POST', uri);

    request.fields['Name'] = name;
    request.fields['Description'] = description;
    request.fields['Round'] = round.toString();
    request.fields['UserId'] = userId.toString();

    // 🎮 Game görseli
    final gameBytes = await fileToBytes(gameImage.rawFile!);
    request.files.add(
      http.MultipartFile.fromBytes(
        'GameImage',
        gameBytes,
        filename: gameImage.name,
      ),
    );

    // 🃏 Kartlar
    for (int i = 0; i < cards.length; i++) {
      final card = cards[i];
      final cardBytes = await fileToBytes(card.rawFile!);

      request.fields['Cards[$i].Name'] = card.name;
      request.fields['Cards[$i].GameId'] = "0"; // örnek değer

      request.files.add(
        http.MultipartFile.fromBytes(
          'Cards[$i].File',
          cardBytes,
          filename: card.name,
        ),
      );
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Başarılı!');
      var resStr = await response.stream.bytesToString();
      print(resStr);
    } else {
      print('Hata kodu: ${response.statusCode}');
    }
  }

  static Future<Uint8List> fileToBytes(html.File file) {
    final reader = html.FileReader();
    final completer = Completer<Uint8List>();

    reader.readAsArrayBuffer(file);
    reader.onLoadEnd.listen((event) {
      completer.complete(reader.result as Uint8List);
    });
    reader.onError.listen((event) {
      completer.completeError(event);
    });

    return completer.future;
  }
}

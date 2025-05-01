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
    if (gameImage.rawFile == null && gameImage.imagePath.isNotEmpty) {
      gameImage.rawFile = await fileFromBase64(
        gameImage.imagePath,
        gameImage.fileName!,
      );
    }

    var uri = Uri.parse('${BaseUrl.baseUrl}/Games/UploadGame');
    var request = http.MultipartRequest('POST', uri);

    request.fields['Name'] = name;
    request.fields['Description'] = description;
    request.fields['Round'] = round.toString();
    request.fields['UserId'] = userId.toString();

    final gameBytes = await fileToBytes(gameImage.rawFile!);
    request.files.add(
      http.MultipartFile.fromBytes(
        'GameImage',
        gameBytes,
        filename: gameImage.fileName,
      ),
    );

    for (int i = 0; i < cards.length; i++) {
      final card = cards[i];

      if (card.rawFile == null && card.imagePath.isNotEmpty) {
        card.rawFile = await fileFromBase64(card.imagePath, card.fileName!);
      }

      final cardBytes = await fileToBytes(card.rawFile!);

      request.fields['Cards[$i].Name'] = card.name;
      request.fields['Cards[$i].GameId'] = "0";
      request.fields['Cards[$i].ImagePath'] =
          card.imagePath; // imagePath eklenmeli

      request.files.add(
        http.MultipartFile.fromBytes(
          'Cards[$i].File',
          cardBytes,
          filename: card.fileName,
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
      var errorStr = await response.stream.bytesToString();
      print('Sunucu yanıtı: $errorStr');
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

  static Future<html.File> fileFromBase64(
    String base64DataUrl,
    String fileName,
  ) async {
    // "data:image/png;base64,..." formatında geliyor, ',' ile bölüyoruz
    final splitted = base64DataUrl.split(',');
    if (splitted.length != 2) {
      throw Exception('Geçersiz Base64 formatı');
    }
    final base64Str = splitted[1]; // ikinci kısım asıl base64 datası
    final bytes = base64Decode(base64Str);
    final blob = html.Blob([bytes]);
    final file = html.File([blob], fileName);
    return file;
  }

  static Future<void> updateCardWinCountAndGamePlayCount(
    int cardId,
    int newWinCount,
  ) async {
    await http.put(
      Uri.parse("${BaseUrl.baseUrl}/Cards/UpdateWinAndPlayCount/$cardId"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(newWinCount),
    );
  }

  static Future<void> updateGame({
    required int gameId,
    String? name,
    String? description,
    int? round,
    UploadCardModel? gameImage,
    List<UploadCardModel>? cards,
  }) async {
    var uri = Uri.parse('${BaseUrl.baseUrl}/Games/Update/$gameId');
    var request = http.MultipartRequest('POST', uri);

    if (name != null) request.fields['Name'] = name;
    if (description != null) request.fields['Description'] = description;
    if (round != null) request.fields['Round'] = round.toString();

    if (gameImage != null && gameImage.rawFile != null) {
      final gameBytes = await fileToBytes(gameImage.rawFile!);
      request.files.add(
        http.MultipartFile.fromBytes(
          'GameImage',
          gameBytes,
          filename: gameImage.fileName,
        ),
      );
    }
    if (cards != null) {
      for (int i = 0; i < cards.length; i++) {
        final card = cards[i];
        final cardBytes = await fileToBytes(card.rawFile!);

        request.fields['Cards[$i].Name'] = card.name;
        request.fields['Cards[$i].id'] = card.id.toString();
        request.fields['Cards[$i].ImagePath'] = card.imagePath;
        request.fields['Cards[$i].GameId'] = gameId.toString(); // örnek değer

        request.files.add(
          http.MultipartFile.fromBytes(
            'Cards[$i].File',
            cardBytes,
            filename: card.fileName,
          ),
        );
      }
    }
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Başarılı!');
      var resStr = await response.stream.bytesToString();
      print(resStr);
    } else {
      print('Hata kodu: ${response.statusCode}');
      print('Hata: ${await response.stream.bytesToString()}');
    }
  }
}

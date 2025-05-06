import 'dart:convert';

import 'package:gorsel_programlama_proje/models/score_history_item.dart';
import 'package:gorsel_programlama_proje/services/base_url.dart';
import 'package:gorsel_programlama_proje/services/user_service.dart';
import 'package:http/http.dart' as http;

class DatabaseService {
  Future<void> saveScore(int score) async {
    print('Skor $score veritabanına kaydediliyor...');
    final Uri apiUrl = Uri.parse(
      '${BaseUrl.baseUrl}/scores',
    ); // Skor kaydetme endpoint'iniz farklıysa onu kullanın
    final Map<String, dynamic> scoreData = {
      'score': score,
      'userId': UserService.user?.id,
      // Backend'in beklediği diğer verileri buraya ekleyin
    };

    try {
      final response = await http.post(
        apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(scoreData),
      );

      if (response.statusCode == 201) {
        print('Skor $score veritabanına başarıyla kaydedildi.');
      } else {
        print('Skor kaydedilirken bir hata oluştu: ${response.statusCode}');
        print('Hata mesajı: ${response.body}');
        // Hata durumunda kullanıcıya bildirimde bulunabilirsiniz
      }
    } catch (error) {
      print('Skor kaydedilirken bir ağ hatası oluştu: $error');
      // Ağ hatası durumunda kullanıcıya bildirimde bulunabilirsiniz
    }
  }

  Future<List<ScoreHistoryItem>> getScoreHistory() async {
    final response = await http.get(Uri.parse('${BaseUrl.baseUrl}/scores'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ScoreHistoryItem.fromJson(json)).toList();
    } else {
      print('Skor geçmişi yüklenirken hata oluştu: ${response.statusCode}');
      print('Hata mesajı: ${response.body}');
      throw Exception('Skor geçmişi yüklenirken hata oluştu');
    }
  }

  Future<List<ScoreHistoryItem>> getScoresByUserId(int userId) async {
    final response = await http.get(
      Uri.parse('${BaseUrl.baseUrl}/scores/user/$userId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ScoreHistoryItem.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      return []; // Kullanıcının skoru bulunamadı
    } else {
      print(
        'Kullanıcının skorları yüklenirken hata oluştu: ${response.statusCode}',
      );
      print('Hata mesajı: ${response.body}');
      throw Exception('Kullanıcının skorları yüklenirken hata oluştu');
    }
  }
}

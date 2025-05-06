import 'dart:convert';

import 'package:http/http.dart' as http;

class ScoreHistoryItem {
  final int scoreId;
  final int questionId;
  final int userId;
  final String? category;
  final int scorePuan;
  final DateTime datetime;
  final String? userName;

  ScoreHistoryItem({
    required this.scoreId,
    required this.questionId,
    required this.userId,
    this.category,
    required this.scorePuan,
    required this.datetime,
    required this.userName,
  });

  factory ScoreHistoryItem.fromJson(Map<String, dynamic> json) {
    return ScoreHistoryItem(
      scoreId: json['scoreId'] as int,
      questionId: json['questionId'] as int,
      userId: json['userId'] as int,
      category: json['category'] as String?,
      scorePuan: json['scorePuan'] as int,
      datetime: DateTime.parse(json['datetime'] as String),
      userName: json['userName'] as String?,
    );
  }

  // İsteğe bağlı olarak, DateTime'ı daha okunabilir bir formata dönüştürmek için bir metot ekleyebilirsiniz.
  String get formattedDatetime {
    return "${datetime.day}.${datetime.month}.${datetime.year} ${datetime.hour}:${datetime.minute}:${datetime.second}";
  }
}

// Backend API'sinden skor geçmişini almak için bir fonksiyon örneği:
Future<List<ScoreHistoryItem>> fetchScoreHistory(int userId) async {
  final response = await http.get(
    Uri.parse(
      'https://localhost:7176/api/scores',
    ), // Backend API endpoint'inizi buraya yazın
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => ScoreHistoryItem.fromJson(json)).toList();
  } else {
    print('API İstek Hatası: ${response.statusCode}');
    print('API Cevabı: ${response.body}');
    throw Exception('Skor geçmişi yüklenirken bir hata oluştu');
  }
}

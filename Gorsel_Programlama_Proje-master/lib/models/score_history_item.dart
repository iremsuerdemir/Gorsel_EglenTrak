import 'package:intl/intl.dart';

class ScoreHistoryItem {
  final String kullaniciAdi;
  final int score;
  final DateTime timestamp;

  ScoreHistoryItem({
    required this.kullaniciAdi,
    required this.score,
    required this.timestamp,
  });
  String get formattedDate =>
      DateFormat('dd MMM yyyy - HH:mm:ss').format(timestamp);
  factory ScoreHistoryItem.fromJson(Map<String, dynamic> json) {
    return ScoreHistoryItem(
      kullaniciAdi: json['kullaniciAdi'],
      score: json['score'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kullaniciAdi': kullaniciAdi,
      'score': score,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

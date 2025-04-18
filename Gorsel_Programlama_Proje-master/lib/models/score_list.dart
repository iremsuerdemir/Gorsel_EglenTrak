import 'package:gorsel_programlama_proje/models/score_history_item.dart';

class ScoreList {
  String kullaniciAdi;
  int score;

  ScoreList({required this.kullaniciAdi, required this.score});

  static List<ScoreList> list = [
    ScoreList(kullaniciAdi: "Ali", score: 1),
    ScoreList(kullaniciAdi: "Veli", score: 4),
    ScoreList(kullaniciAdi: "Ayşe", score: 5),
    ScoreList(kullaniciAdi: "Fatma", score: 8),
    ScoreList(kullaniciAdi: "Mehmet", score: 9),
    ScoreList(kullaniciAdi: "Zeynep", score: 10),
  ];

  static void ekle(ScoreList yeniList) {
    list.add(yeniList);
  }

  /// ScoreHistoryItem listesine dönüştürme fonksiyonu
  static List<ScoreHistoryItem> toScoreHistoryList() {
    final now = DateTime.now();
    return list.asMap().entries.map((entry) {
      int index = entry.key;
      var item = entry.value;
      return ScoreHistoryItem(
        kullaniciAdi: item.kullaniciAdi,
        score: item.score,
        timestamp: now.subtract(
          Duration(days: index),
        ), // Her skora farklı tarih
      );
    }).toList();
  }
}

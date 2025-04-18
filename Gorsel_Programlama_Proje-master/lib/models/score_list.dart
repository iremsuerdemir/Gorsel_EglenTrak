import 'package:gorsel_programlama_proje/models/score_history_item.dart';

class ScoreList {
  String kullaniciAdi;
  int score;

  ScoreList({required this.kullaniciAdi, required this.score});

  static List<ScoreList> list = [
    ScoreList(kullaniciAdi: "Ali", score: 10),
    ScoreList(kullaniciAdi: "Veli", score: 40),
    ScoreList(kullaniciAdi: "Ayşe", score: 50),
    ScoreList(kullaniciAdi: "Fatma", score: 80),
    ScoreList(kullaniciAdi: "Mehmet", score: 90),
    ScoreList(kullaniciAdi: "Zeynep", score: 100),
    ScoreList(kullaniciAdi: "Can", score: 20),
    ScoreList(kullaniciAdi: "Ece", score: 30),
    ScoreList(kullaniciAdi: "Burak", score: 70),
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

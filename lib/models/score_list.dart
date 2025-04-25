import 'package:gorsel_programlama_proje/models/score_history_item.dart';
import 'package:gorsel_programlama_proje/models/user.dart';

class ScoreList {
  User kullanici;
  int score;

  ScoreList({required this.kullanici, required this.score});

  static List<ScoreList> list = [
    ScoreList(
      kullanici: User(id: 1, username: "Beyza", email: "beyza@gmail.com"),
      score: 70,
    ),
    ScoreList(
      kullanici: User(id: 2, username: "İrem", email: "irem@gmail.com"),
      score: 60,
    ),
    ScoreList(
      kullanici: User(id: 3, username: "Berk", email: "berk@gmail.com"),
      score: 50,
    ),
    ScoreList(
      kullanici: User(id: 4, username: "Polat", email: "polat@gmail.com"),
      score: 40,
    ),
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
        kullaniciAdi:
            item.kullanici.username, // kullanıcı adını User'dan alıyoruz
        score: item.score,
        timestamp: now.subtract(
          Duration(days: index),
        ), // Her skora farklı tarih
      );
    }).toList();
  }
}

// lib/models/question_list.dart
import 'package:flutter/material.dart';

class Question {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;
  final String category;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    required this.category,
  });
}

class QuestionList {
  static List<Question> list = [
    // ------------------ BİLİM ------------------
    Question(
      questionText: "Su, kaynama noktasında kaç derecede kaynar?",
      options: ["90°C", "100°C", "110°C", "120°C"],
      correctAnswerIndex: 1,
      category: "Bilim",
    ),
    Question(
      questionText: "Güneş sistemindeki en büyük gezegen hangisidir?",
      options: ["Dünya", "Mars", "Jüpiter", "Satürn"],
      correctAnswerIndex: 2,
      category: "Bilim",
    ),
    Question(
      questionText: "Işığın boşluktaki hızı yaklaşık ne kadardır?",
      options: ["300.000 km/s", "150.000 km/s", "450.000 km/s", "600.000 km/s"],
      correctAnswerIndex: 0,
      category: "Bilim",
    ),
    Question(
      questionText: "Dünyanın yapısında en dış katman hangisidir?",
      options: ["Çekirdek", "Manto", "Kabuk", "Yüzey"],
      correctAnswerIndex: 2,
      category: "Bilim",
    ),
    Question(
      questionText: "DNA'nın yapısı ilk kez kim tarafından tanımlandı?",
      options: ["Newton", "Watson ve Crick", "Einstein", "Curie"],
      correctAnswerIndex: 1,
      category: "Bilim",
    ),
    Question(
      questionText: "Atom numarası 1 olan element nedir?",
      options: ["Helyum", "Oksijen", "Hidrojen", "Azot"],
      correctAnswerIndex: 2,
      category: "Bilim",
    ),
    Question(
      questionText: "Bir yıl kaç gündür (tam sayıyla)?",
      options: ["360", "365", "366", "364"],
      correctAnswerIndex: 1,
      category: "Bilim",
    ),
    Question(
      questionText: "Fotosentez yapan organel hangisidir?",
      options: ["Ribozom", "Mitokondri", "Kloroplast", "Lizozom"],
      correctAnswerIndex: 2,
      category: "Bilim",
    ),
    Question(
      questionText: "Einstein’ın ünlü denklemi nedir?",
      options: ["F=ma", "E=mc²", "a²+b²=c²", "V=I.R"],
      correctAnswerIndex: 1,
      category: "Bilim",
    ),
    Question(
      questionText: "Ses birimi nedir?",
      options: ["Desibel", "Hertz", "Watt", "Newton"],
      correctAnswerIndex: 0,
      category: "Bilim",
    ),

    // ------------------ TARİH ------------------
    Question(
      questionText: "Türkiye Cumhuriyeti hangi yılda ilan edildi?",
      options: ["1918", "1920", "1923", "1925"],
      correctAnswerIndex: 2,
      category: "Tarih",
    ),
    Question(
      questionText: "İstanbul'un fethi hangi yılda gerçekleşmiştir?",
      options: ["1451", "1452", "1453", "1454"],
      correctAnswerIndex: 2,
      category: "Tarih",
    ),
    Question(
      questionText:
          "Meşrutiyet dönemi Osmanlı padişahı aşağıdakilerden hangisidir?",
      options: ["II. Abdülhamid", "V. Mehmet", "IV. Murad", "III. Selim"],
      correctAnswerIndex: 0,
      category: "Tarih",
    ),
    Question(
      questionText: "Çanakkale Savaşı hangi savaş sırasında yaşandı?",
      options: [
        "Balkan Savaşları",
        "Kurtuluş Savaşı",
        "I. Dünya Savaşı",
        "II. Dünya Savaşı",
      ],
      correctAnswerIndex: 2,
      category: "Tarih",
    ),
    Question(
      questionText: "Kurtuluş Savaşı'nı yöneten kişi kimdir?",
      options: [
        "Enver Paşa",
        "Mustafa Kemal Atatürk",
        "İsmet İnönü",
        "Kazım Karabekir",
      ],
      correctAnswerIndex: 1,
      category: "Tarih",
    ),
    Question(
      questionText: "Osmanlı Devleti ne zaman yıkıldı?",
      options: ["1920", "1922", "1923", "1924"],
      correctAnswerIndex: 1,
      category: "Tarih",
    ),
    Question(
      questionText: "Fransız İhtilali hangi yılda gerçekleşti?",
      options: ["1789", "1776", "1804", "1812"],
      correctAnswerIndex: 0,
      category: "Tarih",
    ),
    Question(
      questionText: "II. Dünya Savaşı kaç yılında başladı?",
      options: ["1937", "1939", "1941", "1945"],
      correctAnswerIndex: 1,
      category: "Tarih",
    ),
    Question(
      questionText: "Roma İmparatorluğu ne zaman ikiye ayrıldı?",
      options: ["200", "395", "476", "1453"],
      correctAnswerIndex: 1,
      category: "Tarih",
    ),
    Question(
      questionText: "Osmanlı'nın ilk başkenti neresidir?",
      options: ["İstanbul", "Bursa", "Edirne", "Ankara"],
      correctAnswerIndex: 1,
      category: "Tarih",
    ),

    // ------------------ GENEL KÜLTÜR ------------------
    Question(
      questionText: "Türkiye'nin başkenti neresidir?",
      options: ["İstanbul", "Ankara", "İzmir", "Antalya"],
      correctAnswerIndex: 1,
      category: "Genel Kültür",
    ),
    Question(
      questionText: "Eyfel Kulesi hangi şehirde?",
      options: ["Londra", "Paris", "Berlin", "Roma"],
      correctAnswerIndex: 1,
      category: "Genel Kültür",
    ),
    Question(
      questionText: "Machu Picchu hangi ülkededir?",
      options: ["Ekvador", "Peru", "Bolivya", "Kolombiya"],
      correctAnswerIndex: 1,
      category: "Genel Kültür",
    ),
    Question(
      questionText: "En çok konuşulan dil hangisidir?",
      options: ["İngilizce", "Çince", "İspanyolca", "Arapça"],
      correctAnswerIndex: 1,
      category: "Genel Kültür",
    ),
    Question(
      questionText: "Dünyanın en uzun nehri hangisidir?",
      options: ["Amazon", "Nil", "Yangtze", "Mississippi"],
      correctAnswerIndex: 1,
      category: "Genel Kültür",
    ),
    Question(
      questionText: "Dünyanın en yüksek dağı hangisidir?",
      options: ["Everest", "K2", "Kangchenjunga", "Makalu"],
      correctAnswerIndex: 0,
      category: "Genel Kültür",
    ),
    Question(
      questionText: "Hangi ülke pizzanın anavatanıdır?",
      options: ["Fransa", "İtalya", "İspanya", "Yunanistan"],
      correctAnswerIndex: 1,
      category: "Genel Kültür",
    ),
    Question(
      questionText: "Hangi şehir iki kıtada yer alır?",
      options: ["İstanbul", "Roma", "Tokyo", "Moskova"],
      correctAnswerIndex: 0,
      category: "Genel Kültür",
    ),
    Question(
      questionText: "Bir düzinede kaç adet vardır?",
      options: ["10", "11", "12", "13"],
      correctAnswerIndex: 2,
      category: "Genel Kültür",
    ),
    Question(
      questionText: "Sherlock Holmes'un yazarı kimdir?",
      options: [
        "Agatha Christie",
        "Dan Brown",
        "Arthur Conan Doyle",
        "J.K. Rowling",
      ],
      correctAnswerIndex: 2,
      category: "Genel Kültür",
    ),

    // ------------------ SPOR ------------------
    Question(
      questionText: "Futbol Dünya Kupası ilk kez hangi yıl düzenlendi?",
      options: ["1928", "1930", "1932", "1934"],
      correctAnswerIndex: 1,
      category: "Spor",
    ),
    Question(
      questionText: "NBA'de en çok şampiyonluk kazanan takım hangisidir?",
      options: ["Chicago Bulls", "Lakers", "Celtics", "Warriors"],
      correctAnswerIndex: 2,
      category: "Spor",
    ),
    Question(
      questionText: "Olimpiyat Oyunları kaç yılda bir düzenlenir?",
      options: ["2", "3", "4", "5"],
      correctAnswerIndex: 2,
      category: "Spor",
    ),
    Question(
      questionText: "Messi hangi ülkenin milli takımında oynamaktadır?",
      options: ["İspanya", "Arjantin", "Brezilya", "Fransa"],
      correctAnswerIndex: 1,
      category: "Spor",
    ),
    Question(
      questionText: "Teniste 3 Grand Slam turnuvası hangileridir?",
      options: [
        "Roland Garros, Wimbledon, US Open",
        "Avustralya, Roma, Dubai",
        "Wimbledon, Tokyo, Madrid",
        "US Open, İstanbul, Pekin",
      ],
      correctAnswerIndex: 0,
      category: "Spor",
    ),
    Question(
      questionText: "Halterde kaldırılan ağırlığa ne denir?",
      options: ["Deadlift", "Snatch", "Press", "Jerk"],
      correctAnswerIndex: 1,
      category: "Spor",
    ),
    Question(
      questionText: "Formula 1'de kullanılan lastik türü nedir?",
      options: ["Kış", "Yaz", "Slick", "Turf"],
      correctAnswerIndex: 2,
      category: "Spor",
    ),
    Question(
      questionText: "Basketbolda pota kaç metrede bulunur?",
      options: ["2.75", "3.05", "3.50", "2.50"],
      correctAnswerIndex: 1,
      category: "Spor",
    ),
    Question(
      questionText: "Türkiye Süper Lig’i en çok kazanan takım?",
      options: ["Fenerbahçe", "Beşiktaş", "Galatasaray", "Trabzonspor"],
      correctAnswerIndex: 2,
      category: "Spor",
    ),
    Question(
      questionText: "Hangi spor dalında 'as' terimi kullanılır?",
      options: ["Tenis", "Futbol", "Basketbol", "Voleybol"],
      correctAnswerIndex: 0,
      category: "Spor",
    ),
  ];

  static List<Question> getByCategory(String category) {
    return list.where((q) => q.category == category).toList();
  }

  static List<String> getCategories() {
    return list.map((q) => q.category).toSet().toList();
  }
}

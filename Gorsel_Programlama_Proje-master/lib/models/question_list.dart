class Question {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;

  static var list;

  static var score;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });
}

class QuestionList {
  static List<Question> list = [
    Question(
      questionText: "Türkiye'nin başkenti neresidir?",
      options: ["İstanbul", "Ankara", "İzmir", "Bursa"],
      correctAnswerIndex: 1, // Ankara
    ),
    Question(
      questionText: "Eyfel Kulesi hangi şehirdedir?",
      options: ["Londra", "Paris", "Roma", "Berlin"],
      correctAnswerIndex: 1, // Paris
    ),
    Question(
      questionText: "Piramitler hangi ülkededir?",
      options: ["Mısır", "Yunanistan", "İtalya", "Türkiye"],
      correctAnswerIndex: 0, // Mısır
    ),
    Question(
      questionText: "Özgürlük Heykeli hangi şehirdedir?",
      options: ["Los Angeles", "Chicago", "New York", "Miami"],
      correctAnswerIndex: 2, // New York
    ),
    Question(
      questionText: "Kolezyum hangi şehirdedir?",
      options: ["Venedik", "Floransa", "Roma", "Milano"],
      correctAnswerIndex: 2, // Roma
    ),
    Question(
      questionText: "Çin Seddi hangi ülkededir?",
      options: ["Japonya", "Çin", "Hindistan", "Vietnam"],
      correctAnswerIndex: 1, // Çin
    ),
    Question(
      questionText: "Tac Mahal hangi şehirdedir?",
      options: ["Delhi", "Mumbai", "Agra", "Kalküta"],
      correctAnswerIndex: 2, // Agra
    ),
    Question(
      questionText: "Sidney Opera Evi hangi şehirdedir?",
      options: ["Melbourne", "Sidney", "Brisbane", "Perth"],
      correctAnswerIndex: 1, // Sidney
    ),
    Question(
      questionText: "Kremlin Sarayı hangi şehirdedir?",
      options: ["Kiev", "Moskova", "St. Petersburg", "Minsk"],
      correctAnswerIndex: 1, // Moskova
    ),
    Question(
      questionText: "Machu Picchu hangi ülkededir?",
      options: ["Kolombiya", "Ekvador", "Peru", "Bolivya"],
      correctAnswerIndex: 2, // Peru
    ),
  ];
}

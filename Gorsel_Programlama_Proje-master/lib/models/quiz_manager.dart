class QuizManager {
  static final QuizManager _instance = QuizManager._internal();

  factory QuizManager() => _instance;

  QuizManager._internal();

  int correctAnswers = 0;
  int score = 0;

  final int totalScore = 100;

  double get progress => score / totalScore;
}

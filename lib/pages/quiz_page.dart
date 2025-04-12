import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with TickerProviderStateMixin {
  final player = AudioPlayer();
  int currentQuestionIndex = 0;
  int selectedAnswer = -1;
  int correctAnswer = 1;
  int score = 0;
  int timeLeft = 40;
  late Timer timer;
  bool isTimeUp = false;
  bool questionAnswered = false;
  bool showLottie = false;
  String lottieFile = '';
  late AnimationController pageTransition;
  late AnimationController lottieController;

  // Jokerler
  bool usedFiftyFifty = false;
  bool usedDoubleAnswer = false;
  bool usedSkipQuestion = false;
  int doubleAnswerAttempts = 2;
  List<int> hiddenOptions = [];

  final List<String> answers = [
    'Seçenek A',
    'Seçenek B',
    'Seçenek C',
    'Seçenek D',
  ];

  @override
  void initState() {
    super.initState();
    startTimer();
    pageTransition = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..forward();
    lottieController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    pageTransition.dispose();
    lottieController.dispose();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        setState(() {
          isTimeUp = true;
        });
        timer.cancel();
      }
    });
  }

  void checkAnswer(int index) async {
    if (questionAnswered) return;

    if (usedDoubleAnswer &&
        index != correctAnswer &&
        doubleAnswerAttempts > 1) {
      doubleAnswerAttempts--;
      setState(() {
        selectedAnswer = index;
      });
      await player.play(AssetSource("sounds/wrong.mp3"));
      return;
    }

    timer.cancel();
    setState(() {
      selectedAnswer = index;
      showLottie = true;
      questionAnswered = true;
      lottieFile =
          index == correctAnswer
              ? 'assets/animations/correct.json'
              : 'assets/animations/wrong.json';
    });

    if (index == correctAnswer) {
      await player.play(AssetSource("sounds/correct.mp3"));
      setState(() => score += 10);
    } else {
      await player.play(AssetSource("sounds/wrong.mp3"));
    }

    lottieController.forward(from: 0.0);
    await Future.delayed(Duration(seconds: 2));
    goToNextQuestion();
  }

  void goToNextQuestion() async {
    setState(() {
      isTimeUp = false;
      questionAnswered = false;
      selectedAnswer = -1;
      showLottie = false;
      lottieFile = '';
      hiddenOptions = [];
      doubleAnswerAttempts = 2;
    });
    // Süre dolduysa, sayfayı yenileyin (simülasyon yapın)
    if (isTimeUp) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => QuizPage()),
      );
    } else {
      await pageTransition.reverse();
      setState(() {
        timeLeft = 40;
      });
      await pageTransition.forward();
      startTimer();
    }
  }

  void useFiftyFifty() {
    if (usedFiftyFifty || questionAnswered) return;

    setState(() {
      usedFiftyFifty = true;
      hiddenOptions =
          List.generate(
              answers.length,
              (index) => index,
            ).where((i) => i != correctAnswer).toList()
            ..shuffle();
      hiddenOptions = hiddenOptions.take(2).toList();
    });
  }

  void skipQuestion() {
    if (usedSkipQuestion || questionAnswered) return;
    setState(() => usedSkipQuestion = true);
    timer.cancel();
    goToNextQuestion();
  }

  Widget buildAnswer(int index) {
    // Eğer seçenek gizlenmişse, hiçbir şey render edilmesin
    if (hiddenOptions.contains(index)) return SizedBox.shrink();

    // Cevap doğru ya da yanlış ise arka plan rengini yeşil ya da kırmızı yap
    Color bgColor = Colors.white;
    if (questionAnswered) {
      if (index == correctAnswer) {
        bgColor = Colors.green; // Doğru cevap yeşil
      } else if (index == selectedAnswer) {
        bgColor = Colors.red; // Yanlış cevap kırmızı
      }
    }

    return GestureDetector(
      onTap: () => checkAnswer(index),
      child: Padding(
        padding: const EdgeInsets.all(10.0), // Padding inside the card
        child: Card(
          elevation: 5, // Add shadow to make it look like a card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          margin: const EdgeInsets.all(10), // Margin around the card
          color: bgColor, // Background color based on answer
          child: Padding(
            padding: const EdgeInsets.all(20.0), // Padding inside the card
            child: Text(
              answers[index],
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold, // Bold text
                letterSpacing: 1.2, // Adds some space between letters
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildJokerButton(String assetPath, VoidCallback onTap, bool used) {
    return GestureDetector(
      onTap: used ? null : onTap,
      child: Opacity(
        opacity: used ? 0.4 : 1.0,
        child: Container(
          width: 60,
          height: 60,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset(assetPath, fit: BoxFit.contain),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[700],
      body: SafeArea(
        child: FadeTransition(
          opacity: pageTransition,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              // Taşmayı engellemek için ekledim
              child: Column(
                children: [
                  // Skor ve Süre
                  Card(
                    color: Colors.deepPurple[300],
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.emoji_events,
                                color: Colors.amberAccent,
                              ),
                              SizedBox(width: 6),
                              Text(
                                "Skor: $score",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 24),
                          Row(
                            children: [
                              Icon(Icons.timer, color: Colors.redAccent),
                              SizedBox(width: 6),
                              Text(
                                "Süre: $timeLeft",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Soru Alanı
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 10, // Daha güçlü bir gölge efekti
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            20,
                          ), // Daha yuvarlak köşeler
                        ),
                        color: Colors.deepPurple[300], // Arka plan rengi
                        shadowColor: Colors.black, // Gölgenin rengi
                        child: Padding(
                          padding: const EdgeInsets.all(
                            20.0,
                          ), // İçerideki boşluk
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Soru buraya gelecek",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight:
                                      FontWeight.bold, // Kalın yazı tipi
                                  color: Colors.white,
                                  letterSpacing: 1.5, // Harf aralığı
                                  shadows: [
                                    Shadow(
                                      blurRadius: 5.0,
                                      color: Colors.black,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      for (int i = 0; i < answers.length; i++) buildAnswer(i),
                      const SizedBox(height: 20),

                      // Buraya eklenecek:
                      if (isTimeUp)
                        Text(
                          "Süreniz doldu!",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      if (showLottie)
                        SizedBox(
                          height: 150,
                          child: Lottie.asset(
                            lottieFile,
                            controller: lottieController,
                            repeat: false,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Joker Butonları
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildJokerButton(
                        "assets/icons/fifty.png",
                        useFiftyFifty,
                        usedFiftyFifty,
                      ),
                      buildJokerButton("assets/icons/double.png", () {
                        if (!usedDoubleAnswer && !questionAnswered) {
                          setState(() {
                            usedDoubleAnswer = true;
                            doubleAnswerAttempts = 2;
                          });
                        }
                      }, usedDoubleAnswer),
                      buildJokerButton(
                        "assets/icons/skip.png",
                        skipQuestion,
                        usedSkipQuestion,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

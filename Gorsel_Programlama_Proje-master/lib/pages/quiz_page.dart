import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/models/question_list.dart';
import 'package:gorsel_programlama_proje/models/score_list.dart';
import 'package:gorsel_programlama_proje/pages/score_screen.dart';
import 'package:gorsel_programlama_proje/pages/time_finish_page.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';

class QuizPage extends StatefulWidget {
  final String category;

  const QuizPage({super.key, required this.category});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with TickerProviderStateMixin {
  final player = AudioPlayer();
  int currentQuestionIndex = 0;
  int selectedAnswer = -1;
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
  bool doubleAnswerActive = false;
  int firstSelectedAnswer = -1;

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
    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });

        if (timeLeft == 10) {
          await player.play(AssetSource("sounds/alert.mp3"));
        }
      } else {
        setState(() {
          isTimeUp = true;
        });
        timer.cancel();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TimeFinishPage()),
        );
      }
    });
  }

  void checkAnswer(int index) async {
    if (questionAnswered) return;

    final currentQuestion = QuestionList.list[currentQuestionIndex];
    final correctAnswerIndex = currentQuestion.correctAnswerIndex;

    if (usedFiftyFifty && index != correctAnswerIndex) {
      setState(() {
        selectedAnswer = index;
        questionAnswered = true;
        lottieFile = 'assets/animations/wrong.json';
        showLottie = true;
      });
      await player.play(AssetSource("sounds/wrong.mp3"));
      lottieController.forward(from: 0.0);
      await Future.delayed(Duration(seconds: 2));
      goToNextQuestion();
      return;
    }

    if (doubleAnswerActive) {
      if (firstSelectedAnswer == -1) {
        firstSelectedAnswer = index;

        if (index == correctAnswerIndex) {
          // İlk cevap doğruysa, normal akışa geç
          timer.cancel();
          setState(() {
            selectedAnswer = index;
            showLottie = true;
            questionAnswered = true;
            lottieFile = 'assets/animations/correct.json';
            score += 10;
            doubleAnswerActive = false;
          });
          await player.play(AssetSource("sounds/correct.mp3"));
          await lottieController.forward(from: 0.0);
          await Future.delayed(Duration(seconds: 2));
          goToNextQuestion();
        } else {
          // İlk cevap yanlışsa, kullanıcıya ikinci şansı ver
          setState(() {
            selectedAnswer = index;
          });
          await player.play(AssetSource("sounds/wrong.mp3"));
        }
        return;
      } else {
        // İkinci hakkı kullanıyor
        timer.cancel();
        setState(() {
          selectedAnswer = index;
          showLottie = true;
          questionAnswered = true;
          lottieFile =
              index == correctAnswerIndex
                  ? 'assets/animations/correct.json'
                  : 'assets/animations/wrong.json';
        });

        if (index == correctAnswerIndex) {
          await player.play(AssetSource("sounds/correct.mp3"));
          setState(() => score += 10);
        } else {
          await player.play(AssetSource("sounds/wrong.mp3"));
          setState(() {
            selectedAnswer = correctAnswerIndex; // Doğru cevabı göster
          });
        }

        await lottieController.forward(from: 0.0);
        await Future.delayed(Duration(seconds: 1));
        setState(() => doubleAnswerActive = false);
        goToNextQuestion();
        return;
      }
    }

    timer.cancel();
    setState(() {
      selectedAnswer = index;
      showLottie = true;
      questionAnswered = true;
      lottieFile =
          index == correctAnswerIndex
              ? 'assets/animations/correct.json'
              : 'assets/animations/wrong.json';
    });

    if (index == correctAnswerIndex) {
      await player.play(AssetSource("sounds/correct.mp3"));
      setState(() => score += 10);
    } else {
      await player.play(AssetSource("sounds/wrong.mp3"));
      setState(() {
        selectedAnswer = correctAnswerIndex; // Doğru cevabı göster
      });
      await Future.delayed(Duration(seconds: 1)); // Kısa bir süre göster
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
      firstSelectedAnswer = -1; // Reset first selected answer
    });

    if (currentQuestionIndex < QuestionList.list.length - 1 || isTimeUp) {
      setState(() {
        currentQuestionIndex =
            isTimeUp && currentQuestionIndex < QuestionList.list.length - 1
                ? currentQuestionIndex + 1
                : currentQuestionIndex < QuestionList.list.length - 1
                ? currentQuestionIndex + 1
                : currentQuestionIndex;
        timeLeft = 40;
      });
      await pageTransition.reverse();
      await pageTransition.forward();
      startTimer();
    } else {
      timer.cancel();
      ScoreList.ekle(ScoreList(kullaniciAdi: "İrem", score: score));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ScoreScreen(score: score)),
      );
    }
  }

  void useFiftyFifty() {
    if (usedFiftyFifty || questionAnswered) return;

    final currentQuestion = QuestionList.list[currentQuestionIndex];
    final correctAnswerIndex = currentQuestion.correctAnswerIndex;
    List<int> incorrectOptions = [];
    for (int i = 0; i < currentQuestion.options.length; i++) {
      if (i != correctAnswerIndex) {
        incorrectOptions.add(i);
      }
    }
    incorrectOptions.shuffle();

    setState(() {
      usedFiftyFifty = true;
      hiddenOptions = [incorrectOptions.first, incorrectOptions.last];
    });
  }

  void skipQuestion() {
    if (usedSkipQuestion || questionAnswered) return;
    setState(() => usedSkipQuestion = true);
    timer.cancel();
    goToNextQuestion();
  }

  void useDoubleAnswer() {
    if (usedDoubleAnswer || questionAnswered || doubleAnswerActive) return;

    setState(() {
      usedDoubleAnswer = true;
      doubleAnswerActive = true;
    });
  }

  Widget buildAnswer(int index) {
    final currentQuestion = QuestionList.list[currentQuestionIndex];
    final correctAnswerIndex = currentQuestion.correctAnswerIndex;
    final isCorrect = index == correctAnswerIndex;
    final isSelected = index == selectedAnswer;
    final isFirstSelectedWrong =
        doubleAnswerActive &&
        firstSelectedAnswer != -1 &&
        firstSelectedAnswer != correctAnswerIndex &&
        index == firstSelectedAnswer;
    final isFirstSelected =
        doubleAnswerActive &&
        firstSelectedAnswer == index; // İlk seçilen cevap kontrolü

    if (usedFiftyFifty && hiddenOptions.contains(index)) {
      return const SizedBox.shrink();
    }

    Color bgColor = Colors.white;
    if (questionAnswered) {
      if (isCorrect) {
        bgColor = Colors.green;
      } else if (isSelected && !isFirstSelectedWrong) {
        bgColor = Colors.red;
      } else if (isFirstSelectedWrong && index == firstSelectedAnswer) {
        bgColor = Colors.red.withOpacity(0.7); // İlk yanlış cevap rengi
      }
    } else if (isFirstSelected) {
      // doubleAnswerActive ve ilk seçilen cevap
      bgColor = Colors.orangeAccent;
    }

    return SizedBox(
      width: 200.0,
      child: GestureDetector(
        onTap: () => !questionAnswered ? checkAnswer(index) : null,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: bgColor,

              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                  offset: Offset(3, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 24.0,
                horizontal: 12.0,
              ),
              child: Center(
                child: Text(
                  currentQuestion.options[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color:
                        bgColor == Colors.white
                            ? Color.fromARGB(255, 243, 196, 24)
                            : Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 2,
                        color: Colors.black26.withOpacity(0.7),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildJokerButton(String assetPath, VoidCallback? onTap, bool used) {
    return GestureDetector(
      onTap: used || questionAnswered || doubleAnswerActive ? null : onTap,
      child: Opacity(
        opacity: used || questionAnswered || doubleAnswerActive ? 0.4 : 1.0,
        child: Container(
          width: 60,
          height: 60,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 8,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Image.asset(assetPath, fit: BoxFit.contain),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = QuestionList.list[currentQuestionIndex];

    return Scaffold(
      backgroundColor: Colors.deepPurple[700],
      body: SafeArea(
        child: FadeTransition(
          opacity: pageTransition,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.deepPurple[300],
                    shadowColor: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            currentQuestion.questionText,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
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
                  Column(
                    children:
                        currentQuestion.options.asMap().entries.map((entry) {
                          int index = entry.key;
                          return buildAnswer(index);
                        }).toList(),
                  ),
                  const SizedBox(height: 20),
                  if (isTimeUp)
                    Text(
                      "Süreniz doldu!",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildJokerButton(
                        'assets/icons/fifty.png',
                        useFiftyFifty,
                        usedFiftyFifty,
                      ),
                      buildJokerButton(
                        'assets/icons/double.png',
                        useDoubleAnswer,
                        usedDoubleAnswer,
                      ),
                      buildJokerButton(
                        'assets/icons/skip.png',
                        skipQuestion,
                        usedSkipQuestion,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (showLottie)
                    Lottie.asset(
                      lottieFile,
                      controller: lottieController,
                      onLoaded: (composition) {
                        lottieController.duration = composition.duration;
                      },
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

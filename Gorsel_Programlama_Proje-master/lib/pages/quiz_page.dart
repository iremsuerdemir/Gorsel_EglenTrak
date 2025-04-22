import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/models/question_list.dart';
import 'package:gorsel_programlama_proje/models/score_list.dart';
import 'package:gorsel_programlama_proje/pages/quiz_game_over.dart';
import 'package:gorsel_programlama_proje/pages/quizhomepage.dart';
import 'package:gorsel_programlama_proje/pages/score_screen.dart';
import 'package:gorsel_programlama_proje/pages/time_finish_page.dart';
import 'package:lottie/lottie.dart';

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
        setState(() => timeLeft--);
        if (timeLeft == 10) {
          await player.play(AssetSource("sounds/alert.mp3"));
        }
      } else {
        setState(() => isTimeUp = true);
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

      // İlk yanlışta TimeFinishPage'e yönlendir
      timer.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => QuizGameOver()),
      );
      return;
    }

    if (doubleAnswerActive) {
      if (firstSelectedAnswer == -1) {
        firstSelectedAnswer = index;

        if (index == correctAnswerIndex) {
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
          setState(() => selectedAnswer = index);
          await player.play(AssetSource("sounds/wrong.mp3"));
          await Future.delayed(Duration(seconds: 1));
        }
        return;
      } else {
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
          await lottieController.forward(from: 0.0);
          await Future.delayed(Duration(seconds: 2));
          setState(() => doubleAnswerActive = false);
          goToNextQuestion();
        } else {
          await player.play(AssetSource("sounds/wrong.mp3"));
          await lottieController.forward(from: 0.0);
          await Future.delayed(Duration(seconds: 2));

          // İkinci cevap da yanlışsa oyun bitsin
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => QuizGameOver()),
          );
        }
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
      await lottieController.forward(from: 0.0);
      await Future.delayed(Duration(seconds: 2));
      goToNextQuestion();
    } else {
      await player.play(AssetSource("sounds/wrong.mp3"));
      await lottieController.forward(from: 0.0);
      await Future.delayed(Duration(seconds: 2));

      // Yanlışsa direkt TimeFinishPage'e git
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => QuizGameOver()),
      );
    }
  }

  void goToNextQuestion() async {
    setState(() {
      isTimeUp = false;
      questionAnswered = false;
      selectedAnswer = -1;
      showLottie = false;
      lottieFile = '';
      hiddenOptions = [];
      firstSelectedAnswer = -1;
      usedDoubleAnswer = false;
    });

    if (currentQuestionIndex < QuestionList.list.length - 1) {
      setState(() {
        currentQuestionIndex++;
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
      if (i != correctAnswerIndex) incorrectOptions.add(i);
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
    final isFirstSelected = doubleAnswerActive && firstSelectedAnswer == index;

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
        bgColor = Colors.red.withOpacity(0.7);
      }
    } else if (isFirstSelected) {
      bgColor = Colors.orangeAccent;
    }

    return SizedBox(
      width: 200.0,
      child: GestureDetector(
        onTap: () => !questionAnswered ? checkAnswer(index) : null,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(
                    255,
                    245,
                    231,
                    36,
                  ).withOpacity(0.5),
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
                        bgColor == Colors.white ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 2,
                        color: const Color.fromARGB(
                          255,
                          245,
                          231,
                          36,
                        ).withOpacity(0.5),
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SafeArea(
                  child: FadeTransition(
                    opacity: pageTransition,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.emoji_events,
                                        color: Colors.amberAccent,
                                      ),
                                      Text(
                                        "Skor: $score",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 40),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.timer,
                                        color: Colors.redAccent,
                                      ),
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

                          Column(
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Numara Yuvarlakları
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      QuestionList.list.length,
                                      (index) {
                                        bool isActive =
                                            index == currentQuestionIndex;
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0,
                                          ),
                                          child: AnimatedContainer(
                                            duration: Duration(
                                              milliseconds: 300,
                                            ),
                                            width: isActive ? 30 : 20,
                                            height: isActive ? 30 : 20,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  isActive
                                                      ? Colors.orangeAccent
                                                      : Colors.white,
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              '${index + 1}',
                                              style: TextStyle(
                                                color:
                                                    isActive
                                                        ? Colors.white
                                                        : Colors.deepPurple,
                                                fontWeight: FontWeight.bold,
                                                fontSize: isActive ? 16 : 12,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  const SizedBox(height: 20),
                                ],
                              ),

                              Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                color: Colors.deepPurple[300],
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
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Column(
                            children:
                                currentQuestion.options
                                    .asMap()
                                    .entries
                                    .map((entry) => buildAnswer(entry.key))
                                    .toList(),
                          ),
                          const SizedBox(height: 20),
                          if (isTimeUp) const SizedBox(height: 20),
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
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (showLottie)
            Positioned.fill(
              child: Center(
                child: Opacity(
                  opacity: 0.7,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 2.0,
                    height: MediaQuery.of(context).size.height * 2.0,
                    child: Lottie.asset(
                      lottieFile,
                      controller: lottieController,
                      onLoaded: (composition) {
                        lottieController.duration = composition.duration;
                      },
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            top: 20,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizHomePage(category: 'bilim'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

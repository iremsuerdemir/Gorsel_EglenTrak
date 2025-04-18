import 'package:flutter/material.dart';
import 'package:fl_score_bar/fl_score_bar.dart';
import 'package:gorsel_programlama_proje/models/score_list.dart';
import 'package:gorsel_programlama_proje/pages/category_page.dart';
import 'package:lottie/lottie.dart';
import 'package:gorsel_programlama_proje/pages/quizhomepage.dart';
import 'package:gorsel_programlama_proje/pages/score_history_page.dart';

class ScoreScreen extends StatefulWidget {
  final int score;

  // Varsayılan score 5, ancak bu değer dinamik olarak her oyunda değişebilir
  const ScoreScreen({Key? key, this.score = 0}) : super(key: key);

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  final int totalScore = 100;

  double get progress => widget.score / totalScore;

  Color get barColor {
    if (progress >= 0.8) return Colors.greenAccent;
    if (progress >= 0.5) return Colors.amberAccent;
    return Colors.redAccent;
  }

  String get feedback {
    if (progress >= 0.5) return "Mükemmel!";
    if (progress >= 0.3) return "İyi iş çıkardın!";
    return "Daha iyisini yapabilirsin!";
  }

  // En yüksek skoru hesapla
  int get highScore {
    // ScoreList.list'den en yüksek skoru alıyoruz
    if (ScoreList.list.isEmpty) return 0;
    return ScoreList.list
        .map((e) => e.score)
        .fold(0, (prev, element) => element > prev ? element : prev);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned.fill(
              child: Lottie.asset(
                'assets/animations/background.json',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      'assets/animations/congrats.json',
                      height: 200,
                    ),
                    const SizedBox(height: 20),
                    ShaderMask(
                      shaderCallback:
                          (bounds) => const LinearGradient(
                            colors: [Colors.pinkAccent, Colors.amberAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                      child: const Text(
                        "Tebrikler!",
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black,
                              offset: Offset(2, 3),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    IconScoreBar(
                      scoreIcon: Icons.star_rounded,
                      iconColor: Colors.yellow,
                      score: (widget.score / (totalScore / 5)).clamp(0, 5),
                      maxScore: 5,
                      readOnly: true,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${widget.score} / $totalScore',
                      style: const TextStyle(
                        fontSize: 36,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      feedback,
                      style: TextStyle(
                        color: barColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CategoryPage(),
                          ),
                          (route) => false,
                        );
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Column(
                        children: [
                          Text(
                            "En yüksek skorunuz: $highScore",
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.pink,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 50,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(
                                colors: [Colors.orangeAccent, Colors.amber],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.amber,
                                  blurRadius: 15,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Text(
                              "Tekrar Dene",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ScoreHistoryPage(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 50,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(
                                colors: [Colors.orangeAccent, Colors.amber],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.amber,
                                  blurRadius: 15,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Text(
                              "Skor Geçmişi",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

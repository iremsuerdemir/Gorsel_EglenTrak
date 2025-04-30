//import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/models/score_list.dart';
import 'package:gorsel_programlama_proje/pages/category_page.dart';
import 'package:gorsel_programlama_proje/pages/quizintropage.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizHomePage extends StatefulWidget {
  final String category;
  const QuizHomePage({super.key, required this.category});

  @override
  State<QuizHomePage> createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  //late AudioPlayer _audioPlayer;
  //bool isMusicPlaying = true;

  int get highScore {
    if (ScoreList.list.isEmpty) return 0;
    return ScoreList.list
        .map((e) => e.score)
        .fold(0, (prev, element) => element > prev ? element : prev);
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);

    //_audioPlayer = AudioPlayer();
    //_playBackgroundMusic();

    _loadHighScore();
  }

  /*Future<void> _playBackgroundMusic() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('sounds/encourage.ogg'));
  }

  Future<void> _pauseBackgroundMusic() async {
    await _audioPlayer.pause();
  }
*/
  Future<void> _loadHighScore() async {
    await SharedPreferences.getInstance();
    setState(() {
      // highScore = prefs.getInt('highScore') ?? 0;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    // _audioPlayer.dispose();
    super.dispose();
  }

  void startQuiz() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(const Duration(seconds: 0), () {
          if (!context.mounted) return;
          Navigator.pop(context); // Kapat loading
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CategoryPage()),
          );
        });
        return Center(
          child: Lottie.asset('assets/animations/loading.json', width: 150),
        );
      },
    );
  }
  /* void toggleMusic() {
    if (isMusicPlaying) {
      _pauseBackgroundMusic();
    } else {
      _playBackgroundMusic();
    }
    setState(() {
      isMusicPlaying = !isMusicPlaying;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Lottie.asset('assets/animations/background.json', fit: BoxFit.cover),
          //Geri ikonu
          Positioned(
            top: 10,
            left: 10,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizIntroPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(0),
                shape: const CircleBorder(),
                backgroundColor:
                    Colors
                        .transparent, // Butonun arka plan rengini transparent yapıyoruz, gradyan için
                shadowColor:
                    Colors.transparent, // Gölgeleme görünümünü kaldırmak
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 138, 26, 130), // Koyu mor
                      Color(0xFFBB49D1), // Parlak mor
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Color.fromARGB(255, 231, 235, 8), // Sarı renkli ikon
                    size: 30,
                  ),
                ),
              ),
            ),
          ),

          // 🔊 Ses Butonu Sağ Üstte
          /*Positioned(
            top: 20,
            right: 20,
            child: GestureDetector(
              onTap: toggleMusic,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 8,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(14),
                child: Icon(
                  isMusicPlaying ? Icons.volume_up : Icons.volume_off,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
          */
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      "Seçtiğin Kategori İçin Kolları Sıva Bakalım!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 88, 6, 82),
                        letterSpacing: 2,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "🏆 En Yüksek Skor: $highScore",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.amberAccent,
                      shadows: [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 4,
                          color: Colors.black, // Koyu siyah gölge
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  Lottie.asset(
                    'assets/animations/quiz_start.json',
                    height: 200,
                  ),

                  const SizedBox(height: 40),

                  GestureDetector(
                    onTap: startQuiz,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOutBack,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFFFC93C), // Altın sarısı
                            Color(0xFFFF6F91), // Canlı pembe-turuncu
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.8),
                            offset: Offset(4, 4),
                            blurRadius: 10,
                          ),
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.2),
                            offset: Offset(-4, -4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 18,
                      ),
                      child: Text(
                        "🎮 Oyuna Başla!",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: const Color.fromARGB(
                            255,
                            88,
                            6,
                            82,
                          ), // Mevcut renk KORUNDU
                          letterSpacing: 2,
                          shadows: [
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 4,
                              color: Colors.black54,
                            ),
                            Shadow(
                              offset: Offset(-1, -1),
                              blurRadius: 2,
                              color: Colors.white24,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

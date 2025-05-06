import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/pages/quizintropage.dart';
import 'package:gorsel_programlama_proje/pages/score_history_page.dart';
import 'package:gorsel_programlama_proje/services/user_service.dart';
import 'package:lottie/lottie.dart';

import 'quizhomepage.dart';

class QuizGameOver extends StatefulWidget {
  final int scoreBeforeMistake; // İlk hataya kadar alınan skor

  const QuizGameOver({super.key, this.scoreBeforeMistake = 0});

  @override
  State<QuizGameOver> createState() => _QuizGameOverState();
}

class _QuizGameOverState extends State<QuizGameOver>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation; // <double> eklendi

  @override
  void initState() {
    super.initState();

    // Animasyon kontrolcüsü ve animasyon tanımlamaları
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Yeniden oyun başlatma fonksiyonu (QuizIntroPage sayfasına yönlendirme)
  void _retryGame() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => QuizHomePage(
              category: '',
            ), // category parametresi duruyor, kontrol edin
      ), // QuizHomePage yönlendirmesi
    );
  }

  void _scoreTable() {
    if (UserService.user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ScoreHistoryPage(userId: UserService.user!.id),
        ),
      );
    } else {
      // Kullanıcı giriş yapmamışsa veya kullanıcı bilgisi alınamamışsa
      // buraya bir hata mesajı gösterebilir veya başka bir işlem yapabilirsiniz.
      //DEBUG için koydum . Bir gün elbet yok olacak :(
      //print('Hata: Kullanıcı bilgisi alınamadı.');
      // Örneğin:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent, // Arka plan rengi
          duration: const Duration(seconds: 3), // Ne kadar süre görüneceği
          behavior:
              SnackBarBehavior
                  .floating, // Ekranın altında kaymak yerine yukarıda yüzer
          shape: RoundedRectangleBorder(
            // Köşeleri yuvarlak yapar
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Row(
            children: const [
              Icon(Icons.warning, color: Colors.white), // Uyarı ikonu
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Lütfen giriş yapınız.',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arkaplan ve animasyonlar
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Color.fromARGB(255, 43, 0, 65)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 200,
                      child: FutureBuilder(
                        future: _loadLottieAnimation(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(
                              color: Colors.white,
                            );
                          } else if (snapshot.hasError) {
                            return Text(
                              'Animasyon yüklenemedi',
                              style: TextStyle(color: Colors.white),
                            );
                          } else {
                            return Lottie.asset(
                              'assets/animations/gameover.json',
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "💀 GAME OVER! 💀",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.purpleAccent,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    // Doğru cevap sayısı ve puan bilgileri
                    Text(
                      "✅ Doğru Cevap Sayısı: ${widget.scoreBeforeMistake / 10}", // Eğer her doğru 10 puan ise doğru
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.amberAccent,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "🏆 Skorunuz: ${widget.scoreBeforeMistake}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent,
                      ),
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: ElevatedButton(
                        onPressed: _retryGame, // Yeniden dene butonu
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple[300],
                          foregroundColor: Colors.black,
                          elevation: 8,
                          shadowColor: Colors.amberAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                        ),
                        child: Text(
                          "Yeniden Dene",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Colors.purpleAccent,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: ElevatedButton(
                        onPressed: _scoreTable, // Skor tablosu butonu
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple[300],
                          foregroundColor: Colors.black,
                          elevation: 8,
                          shadowColor: Colors.amberAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                        ),
                        child: Text(
                          "Skor Tablosuna Git",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Colors.purpleAccent,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizIntroPage(),
                  ), // HomePage yönlendirmesi
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 8,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(8),
                child: Icon(Icons.exit_to_app, color: Colors.white, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Animasyon dosyasını yüklemek için yardımcı fonksiyon
  Future<void> _loadLottieAnimation() async {
    // async ve Future<void> eklendi
    Lottie.asset('assets/animations/gameover.json');
  }
}

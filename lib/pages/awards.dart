import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/models/score_history_item.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class Awards extends StatelessWidget {
  final ScoreHistoryItem skorKaydi;
  final int siralama;

  const Awards({super.key, required this.skorKaydi, required this.siralama});

  String? _getOdulAnimasyonu(int siralama) {
    switch (siralama) {
      case 0:
        return 'assets/animations/gold_medal.json';
      case 1:
        return 'assets/animations/silver_medal.json';
      case 2:
        return 'assets/animations/bronz_medal.json';
      default:
        return 'assets/animations/confetti.json';
    }
  }

  String _getOdulAdi(int siralama) {
    switch (siralama) {
      case 0:
        return 'Altın Madalya 🥇';
      case 1:
        return 'Gümüş Madalya 🥈';
      case 2:
        return 'Bronz Madalya 🥉';
      default:
        return 'Tebrikler 🎉';
    }
  }

  @override
  Widget build(BuildContext context) {
    final animasyonYolu = _getOdulAnimasyonu(siralama);
    final odulAdi = _getOdulAdi(siralama);

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade900,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [const Text('🏆 Ödül Kazandınız!')],
        ),
        backgroundColor: Colors.deepPurple.shade700,
        elevation: 10,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurpleAccent.withValues(alpha: 0.7),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (animasyonYolu != null)
                    Lottie.asset(animasyonYolu, width: 220, repeat: true),
                  const SizedBox(height: 30),
                  GradientText(
                    odulAdi,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ComicSans',
                    ),
                    colors: const [Colors.amber, Colors.redAccent],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '🎉 Harika iş çıkardın ${skorKaydi.userName}!\n⭐ Skorun: ${skorKaydi.scorePuan}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new),
                    label: const Text("Geri Dön"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8,
                    ),
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

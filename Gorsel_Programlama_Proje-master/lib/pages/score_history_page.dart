import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/models/score_history_item.dart';
import 'package:gorsel_programlama_proje/models/score_list.dart';
import 'package:gorsel_programlama_proje/pages/score_screen.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class ScoreHistoryPage extends StatelessWidget {
  const ScoreHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ScoreHistoryItem> skorGecmisi =
        ScoreList.toScoreHistoryList()..sort((a, b) {
          int skorKarsilastirma = b.score.compareTo(a.score);
          if (skorKarsilastirma != 0) return skorKarsilastirma;
          return b.timestamp.compareTo(a.timestamp);
        });

    final top5 = skorGecmisi.take(5).toList();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1D2671), Color(0xFFC33764)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            title: const Text(
              'En İyi 5 Skor',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black45,
                    offset: Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScoreScreen(score: 0),
                  ),
                );
              },
            ),
            backgroundColor: Colors.transparent,
            elevation: 4,
            centerTitle: true,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1D2671), Color(0xFFC33764)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: top5.length,
          itemBuilder: (context, index) {
            final skorKaydi = top5[index];
            final formattedDate = DateFormat(
              'dd MMM yyyy - HH:mm:ss',
            ).format(skorKaydi.timestamp);

            // 🥇🥈🥉 Emoji ile ödül simgeleri
            final String? medalEmoji = switch (index) {
              0 => '🥇',
              1 => '🥈',
              2 => '🥉',
              _ => null,
            };

            return Stack(
              clipBehavior: Clip.none, // <-- Bu kısım taşmayı engeller
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 500 + (index * 100)),
                  curve: Curves.easeOutBack,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color:
                          index == 0
                              ? Colors.amberAccent
                              : Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.white24,
                      child: Text(
                        medalEmoji ?? '👤',
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                    title: Text(
                      skorKaydi.kullaniciAdi,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '$formattedDate\nSkor: ${skorKaydi.score}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    isThreeLine: true,
                  ),
                ),

                // 🎉 Lottie animasyonu sadece kazanan için
                if (index == 0)
                  Positioned(
                    right: 0, // Sağ tarafa dayandırıyoruz
                    top: 0, // Üst kısımdan sıfırlıyoruz
                    child: Align(
                      alignment:
                          Alignment.centerRight, // Animasyonu sağa hizalıyoruz
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Lottie.asset(
                          'assets/animations/star.json',
                          repeat: true,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

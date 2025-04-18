import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/pages/quizhomepage.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  void navigateToQuiz(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QuizHomePage(category: category)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Oransal boyutlandırma
    final brainSize = screenWidth * 0.4; // Beynin genişliği
    final iconSize = screenWidth * 0.2; // İkonların boyutu
    final spacingFactor = 1.0;

    final center = Offset(screenWidth / 2, screenHeight * 0.4);
    final double spacing = brainSize / 2 * spacingFactor + iconSize / 2;

    final List<Map<String, dynamic>> categories = [
      {
        "name": "Tarih",
        "image": "assets/icons/tarih.png",
        "position": Offset(90, -spacing),
      },
      {
        "name": "Genel Kültür",
        "image": "assets/icons/genel_kültür.png",
        "position": Offset(-90, spacing),
      },
      {
        "name": "Spor",
        "image": "assets/icons/spor.png",
        "position": Offset(-spacing, -100),
      },
      {
        "name": "Bilim",
        "image": "assets/icons/bilim.png",
        "position": Offset(spacing, 100),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 73, 141, 168)!,
                const Color.fromARGB(255, 100, 8, 92)!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "KATEGORİLER",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          // Degrade arka plan
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 120, 199, 230)!,
                  const Color.fromARGB(255, 100, 8, 92)!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                // Beyin görseli daire içinde ve boşluksuz
                Positioned(
                  left: center.dx - brainSize / 2,
                  top: center.dy - brainSize / 2,
                  child: Container(
                    width: brainSize,
                    height: brainSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        "assets/icons/beyin.png",
                        fit: BoxFit.cover, // Tam daireyi doldursun
                      ),
                    ),
                  ),
                ),

                // Kategoriler
                ...categories.map((category) {
                  final Offset pos = center + category['position'] as Offset;
                  return Positioned(
                    left: pos.dx - iconSize / 2,
                    top: pos.dy - iconSize / 2,
                    child: GestureDetector(
                      onTap:
                          () => navigateToQuiz(
                            context,
                            category['name'] as String,
                          ),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: iconSize,
                        height: iconSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Image.asset(
                              category['image'] as String,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/components/custom_button.dart';
import 'package:gorsel_programlama_proje/components/gradient_border.dart';
import 'package:gorsel_programlama_proje/components/zoom_dialog.dart';
import 'package:gorsel_programlama_proje/models/game.dart';
import 'package:gorsel_programlama_proje/services/base_url.dart';

class GameOverBody extends StatelessWidget {
  final Game game;
  final VoidCallback onRestart;

  const GameOverBody({super.key, required this.game, required this.onRestart});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Oyun Bitti!",
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: game.rankCard.length,
              itemBuilder: (context, index) {
                final card = game.rankCard[index];
                return GestureDetector(
                  onTap: () {
                    ZoomDialog.show(
                      context: context,
                      image:
                          card.name == "Empty"
                              ? Image.asset("assets/icons/cross.png")
                              : Image.network(
                                "${BaseUrl.imageBaseUrl}/${card.imagePath}",
                              ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GradientBorder(
                      padding: 0,
                      height: 100,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                            child:
                                card.name == "Empty"
                                    ? Image.asset("assets/icons/cross.png")
                                    : Image.network(
                                      "${BaseUrl.imageBaseUrl}/${card.imagePath}",
                                      width: 120,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  card.name,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Text("#${index + 1}"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          CustomButton(
            text: "Yeniden başla",
            height: 30,
            icon: Icon(Icons.refresh),
            onPressed: () {
              game.restart();
              onRestart(); // üst widgetı güncellemek için setState çağırır
            },
          ),
        ],
      ),
    );
  }
}

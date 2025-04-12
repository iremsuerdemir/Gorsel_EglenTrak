import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/models/card_items.dart';
import 'package:gorsel_programlama_proje/models/game.dart';
import 'package:gorsel_programlama_proje/pages/choice_page.dart';
import 'package:gorsel_programlama_proje/pages/login_page.dart';

class CohiceGamePage extends StatefulWidget {
  const CohiceGamePage({super.key});

  @override
  State<CohiceGamePage> createState() => _CohiceGamePageState();
}

class _CohiceGamePageState extends State<CohiceGamePage> {
  final Game game = Game(round: 4, cards: CardItems.items);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            icon: Icon(Icons.person),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body:
          game.isGameOver
              ? Center(child: Text("Game Over"))
              : ChoicePage(
                game: game,
                onGameUpdated: () {
                  setState(
                    () {},
                  ); // oyun bittiğinde bu sayfayı güncellemek için
                },
              ),
    );
  }
}

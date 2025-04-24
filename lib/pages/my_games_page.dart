import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/components/custom_card.dart';
import 'package:gorsel_programlama_proje/models/game_model.dart';
import 'package:gorsel_programlama_proje/pages/add_card_page.dart';
import 'package:gorsel_programlama_proje/pages/choice_game_detail_menu_page.dart';
import 'package:gorsel_programlama_proje/services/game_service.dart';

class MyGamesPage extends StatefulWidget {
  const MyGamesPage({super.key});

  @override
  State<MyGamesPage> createState() => _MyGamesPageState();
}

class _MyGamesPageState extends State<MyGamesPage> {
  List<GameModel> games = [];

  @override
  void initState() {
    super.initState();

    GameService.getUserGames().then((g) {
      setState(() {
        games = g;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCardPage()),
          ).then((_) {
            setState(() {});
          });
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
        ),
        itemCount: games.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.all(5),
            child: Stack(
              children: [
                CustomCard(
                  round: 32,
                  cardHeaderImageIndex: 1,
                  cards: games[i].cards,
                  title: games[i].name,
                  description: games[i].description,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ChoiceGameDetailMenuPage(
                              cards: games[i].cards,
                              round: games[i].round,
                              title: games[i].name,
                              description: games[i].description,
                              gamePlayCount: games[i].playCount,
                            ),
                      ),
                    );
                  },
                ),

                Positioned(
                  right: 16,
                  top: 16,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => AddCardPage(
                                cards: games[i].cards,
                                title: games[i].name,
                                description: games[i].description,
                                round: games[i].round,
                              ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.edit),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/components/custom_card.dart';
import 'package:gorsel_programlama_proje/models/game_model.dart';
import 'package:gorsel_programlama_proje/pages/choice_game_detail_menu_page.dart';
import 'package:gorsel_programlama_proje/services/game_service.dart';

class ChoiceGameMenuPage extends StatefulWidget {
  const ChoiceGameMenuPage({super.key});

  @override
  State<ChoiceGameMenuPage> createState() => _ChoiceGameMenuPageState();
}

class _ChoiceGameMenuPageState extends State<ChoiceGameMenuPage> {
  List<GameModel> games = [];

  @override
  void initState() {
    super.initState();

    GameService.getGames().then((g) {
      setState(() {
        if (g != null) {
          games = g;
        } else {
          games = [];
        }
      });
    });
  }

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
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                ),
                itemCount: games.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: EdgeInsets.all(5),
                    child: CustomCard(
                      round: games[i].round,
                      cardHeaderImageIndex: 6,
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
                                ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

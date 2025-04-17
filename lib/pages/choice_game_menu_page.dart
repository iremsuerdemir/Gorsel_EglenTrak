import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/components/custom_card.dart';
import 'package:gorsel_programlama_proje/models/card_items.dart';
import 'package:gorsel_programlama_proje/models/card_model.dart';
import 'package:gorsel_programlama_proje/pages/choice_game_detail_menu_page.dart';

class ChoiceGameMenuPage extends StatelessWidget {
  ChoiceGameMenuPage({super.key});
  final List<List<CardModel>> cards = [
    CardItems.items.toList(),
    CardItems.items.toList(),
    CardItems.items.toList(),
    CardItems.items.toList(),
    CardItems.items.toList(),
    CardItems.items.toList(),
    CardItems.items.toList(),
    CardItems.items.toList(),
    CardItems.items.toList(),
    CardItems.items.toList(),
    CardItems.items.toList(),
  ];

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
                itemCount: cards.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: EdgeInsets.all(5),
                    child: CustomCard(
                      round: 32,
                      cardHeaderImageIndex: 6,
                      cards: cards[i],
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ChoiceGameDetailMenuPage(
                                  cards: cards[i],
                                  round: 4,
                                  title: "title",
                                  description:
                                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
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

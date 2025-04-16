import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/components/custom_card.dart';
import 'package:gorsel_programlama_proje/models/card_items.dart';
import 'package:gorsel_programlama_proje/pages/add_card_page.dart';

class MyGamesPage extends StatelessWidget {
  const MyGamesPage({super.key});

  final int gameCount = 5;

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
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
        ),
        itemCount: gameCount,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.all(5),
            child: Stack(
              children: [
                CustomCard(
                  round: 32,
                  cardHeaderImageIndex: 3,
                  cards: CardItems.items,
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
                                cards: CardItems.items,
                                title: "Title",
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

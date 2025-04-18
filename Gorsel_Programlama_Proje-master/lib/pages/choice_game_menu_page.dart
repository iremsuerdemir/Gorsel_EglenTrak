import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/components/box.dart';
import 'package:gorsel_programlama_proje/models/card_items.dart';
import 'package:gorsel_programlama_proje/models/card_model.dart';

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
                    child: Card(
                      elevation: 10,
                      child: Box(
                        padding: 0,
                        onpressed: () {},
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10),
                                    ),
                                    child: Image.network(
                                      cards[i][6].imagePath,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Title",
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.headlineMedium,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "Descriptrion",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.headlineSmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Sol üst köşedeki küçük kutu
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${cards[i][6].id}', //round sayısı gelecek
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
          ],
        ),
      ),
    );
  }
}

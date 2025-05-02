import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/components/box.dart';
import 'package:gorsel_programlama_proje/models/card_model.dart';
import 'package:gorsel_programlama_proje/services/base_url.dart';

class CustomCard extends StatelessWidget {
  final int round;
  final String title;
  final String description;
  final String headerImage;
  final List<CardModel> cards;
  final Function? onPressed;
  const CustomCard({
    super.key,
    required this.round,
    required this.headerImage,
    required this.cards,
    this.onPressed,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Box(
        padding: 0,
        onpressed: onPressed ?? () {},
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
                      "${BaseUrl.imageBaseUrl}/$headerImage",
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(height: 8),
                        Text(
                          description,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.headlineSmall,
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
                  '$round', //round sayısı gelecek
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/components/box.dart';
import 'package:gorsel_programlama_proje/components/slide_animation.dart';
import 'package:gorsel_programlama_proje/components/zoom_dialog.dart';
import 'package:gorsel_programlama_proje/models/game.dart';
import 'package:gorsel_programlama_proje/services/base_url.dart';

class ChoiceGamePageBody extends StatefulWidget {
  final Game game;
  final VoidCallback onGameUpdated;
  const ChoiceGamePageBody({
    super.key,
    required this.game,
    required this.onGameUpdated,
  });

  @override
  State<ChoiceGamePageBody> createState() => _ChoiceGamePageBodyState();
}

class _ChoiceGamePageBodyState extends State<ChoiceGamePageBody> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Text("${widget.game.currentRound} / ${widget.game.round}"),
          SizedBox(height: 10),
          Expanded(
            flex: 4,
            child: SlideAnimation(
              startOffsetX: 1.5,
              startOffsetY: -1.5,
              child: Box(
                onpressed: () {
                  widget.game.selectFirstCard();
                  setState(() {
                    widget.game.updateCurrentRound();
                  });
                  widget.onGameUpdated();
                },
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child:
                            widget.game.cards[0].name == "Empty"
                                ? Image.asset("assets/icons/cross.png")
                                : Image.network(
                                  "${BaseUrl.imageBaseUrl}/${widget.game.cards[0].imagePath}",
                                  fit: BoxFit.cover,
                                ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.secondary.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 30,
                        child: Center(child: Text(widget.game.cards[0].name)),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: zoomButton(context, 0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Image.asset("assets/icons/vs.png", fit: BoxFit.contain),
          ),
          Expanded(
            flex: 4,
            child: SlideAnimation(
              startOffsetX: -1.5,
              startOffsetY: 1.5,
              child: Box(
                onpressed: () {
                  widget.game.selectSecondCard();
                  setState(() {
                    widget.game.updateCurrentRound();
                  });
                  widget
                      .onGameUpdated(); // oyun bittiğinde gameOver ekranını göstermek için üst widgetı günceller
                },
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child:
                            widget.game.cards[1].name == "Empty"
                                ? Image.asset("assets/icons/cross.png")
                                : Image.network(
                                  "${BaseUrl.imageBaseUrl}/${widget.game.cards[1].imagePath}",
                                  fit: BoxFit.cover,
                                ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 30,
                        child: Center(child: Text(widget.game.cards[1].name)),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: zoomButton(context, 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector zoomButton(BuildContext context, int i) {
    return GestureDetector(
      onTap: () {
        ZoomDialog.show(
          context: context,
          image:
              widget.game.cards[i].name == "Empty"
                  ? Image.asset("assets/icons/cross.png")
                  : Image.network(
                    "${BaseUrl.imageBaseUrl}/${widget.game.cards[i].imagePath}",
                  ),
        );
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
        ),
        child: Icon(Icons.zoom_in),
      ),
    );
  }
}

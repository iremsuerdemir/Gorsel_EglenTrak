import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/components/box.dart';
import 'package:gorsel_programlama_proje/components/slide_animation.dart';
import 'package:gorsel_programlama_proje/models/game.dart';

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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.game.cards[0].imagePath,
                    fit: BoxFit.cover,
                  ),
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.game.cards[1].imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

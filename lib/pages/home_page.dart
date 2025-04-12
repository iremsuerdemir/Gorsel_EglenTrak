import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/components/box.dart';
import 'package:gorsel_programlama_proje/components/slide_animation.dart';
import 'package:gorsel_programlama_proje/pages/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: SlideAnimation(
                startOffsetX: 1.5,
                startOffsetY: -1.5,
                child: Box(
                  onpressed: () {},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRMiRp56ehUts3rR_luctaPGEx7TXd1AH4CiQ&s",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Image.asset(
                "static/images/logo/vs.png",
                fit: BoxFit.contain,
              ),
            ),
            Expanded(
              flex: 4,
              child: SlideAnimation(
                startOffsetX: -1.5,
                startOffsetY: 1.5,
                child: Box(
                  onpressed: () {},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRMiRp56ehUts3rR_luctaPGEx7TXd1AH4CiQ&s",
                      fit: BoxFit.cover,
                    ),
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

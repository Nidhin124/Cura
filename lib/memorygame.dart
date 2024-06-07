import 'dart:async';
import 'package:flutter/material.dart';

class Mind extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Card Game',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MemoryCardGame(),
    );
  }
}

class MemoryCardGame extends StatefulWidget {
  @override
  _MemoryCardGameState createState() => _MemoryCardGameState();
}

class _MemoryCardGameState extends State<MemoryCardGame> {
  var errors = 0;
  List<String> cardList = [
    "darkness",
    "double",
    "fairy",
    "fighting",
    "fire",
    "grass",
    "lightning",
    "metal",
    "psychic",
    "water"
  ];

  List<String> cardSet = [];
  List<String> visibleCards = [];
  bool isProcessing = false;
  int? firstCardIndex;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    cardSet = List.from(cardList)..addAll(cardList);
    cardSet.shuffle();
    visibleCards = List.filled(cardSet.length, "back");
  }

  void selectCard(int index) {
    if (isProcessing || visibleCards[index] != "back") {
      return;
    }

    setState(() {
      visibleCards[index] = cardSet[index];
    });

    if (firstCardIndex == null) {
      firstCardIndex = index;
    } else {
      isProcessing = true;
      if (cardSet[firstCardIndex!] != cardSet[index]) {
        Timer(Duration(milliseconds: 800), () {
          setState(() {
            visibleCards[firstCardIndex!] = "back";
            visibleCards[index] = "back";
            errors++;
            isProcessing = false;
            firstCardIndex = null;
          });
        });
      } else {
        setState(() {
          isProcessing = false;
          firstCardIndex = null;
        });
        if (visibleCards.every((element) => element != 'back')) {
          // All cards have been matched, show congratulations dialog
          showCongratulationsDialog(context);
        }
      }
    }
  }

  void showCongratulationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Congratulations!"),
          content: Text("You've completed the game with $errors errors."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Card Game'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Errors: $errors',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.0,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: cardSet.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    selectCard(index);
                  },
                  child: Container(
                    color: Colors.blue,
                    child: Center(
                      child: visibleCards[index] == "back"
                          ? Image.asset(
                        'assets/back.jpg',
                        fit: BoxFit.cover,
                      )
                          : Image.asset(
                        'assets/${visibleCards[index]}.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(Mind());
}

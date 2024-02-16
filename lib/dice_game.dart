import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class DiceGame extends StatefulWidget {
  const DiceGame({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DiceGameState createState() => _DiceGameState();
}

class _DiceGameState extends State<DiceGame> {
  int playerOne = 1;
  int playerTwo = 1;
  String result = "";

void signOut() async {
  NavigatorState navigator = Navigator.of(context); 
  await FirebaseAuth.instance.signOut();
  navigator.popUntil((route) => route.isFirst); //Handle signout and return to login
}

  void rollDice() {
    setState(() {
      playerOne = Random().nextInt(6) + 1;
      playerTwo = Random().nextInt(6) + 1;
      if (playerOne > playerTwo) {
        result = "Player 1 Wins!";
      } else if (playerTwo > playerOne) {
        result = "Player 2 Wins!";
      } else {
        result = "It's a draw!";
      }
    });
  } // Roll dice and determine winner

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fire Dice'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: signOut,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image.asset('images/dice$playerOne.png', height: 100, width: 100),
                Image.asset('images/dice$playerTwo.png', height: 100, width: 100),
              ],//Display dice equal to roll
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: rollDice,
              child: const Text('Roll Dice'),
            ),//Throw the dice
            const SizedBox(height: 20),
            Text(
              result,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}

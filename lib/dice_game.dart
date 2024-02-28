import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'leaderboard_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


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
  String playerOneLabel = "Player 1";

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async{
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final username = doc.data()?['username'] ?? 'No Username';
      setState(() {
        playerOneLabel = username;  //Fall back to Player 1 if user is null
      });
    }
  }

void signOut() async {
  NavigatorState navigator = Navigator.of(context); 
  await FirebaseAuth.instance.signOut();
  navigator.popUntil((route) => route.isFirst); //Handle signout and return to login
}
Future<void> updateUserData(int wins, int losses, int draws) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    try {
      await userDoc.update({
        'wins': FieldValue.increment(wins),
        'losses': FieldValue.increment(losses),
        'draws': FieldValue.increment(draws),
      });
    } catch (e) {
      // ignore: avoid_print
      print("Error updating user data: $e");
    }
  }
}
void rollDice() {
  setState(() {
    playerOne = Random().nextInt(6) + 1;
    playerTwo = Random().nextInt(6) + 1;
    if (playerOne > playerTwo) {
      result = "$playerOneLabel Wins!";
      // Update the database for a player win
      updateUserData(1, 0, 0); 
    } else if (playerTwo > playerOne) {
      result = "CPU Wins!";
      // Update the database for a player loss
      updateUserData(0, 1, 0); 
    } else {
      result = "It's a draw!";
      // Update the database for a draw
      updateUserData(0, 0, 1); 
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
            ElevatedButton(
              onPressed: () {
    // Navigate to the LeaderboardScreen
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LeaderboardScreen()),
            );
          },
          child: const Text('Show Leaderboard'),
        ),
          ],
          
        ),
      ),
    );
  }
}

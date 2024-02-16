import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'auth_gate.dart'; // Handles auth logic and decides the initial route
import 'dice_game.dart'; 
import 'sign_up_screen.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    runApp(const MyApp());
  } catch (e) {
    // ignore: avoid_print
    print("Firebase initialization error: $e");
    // Handle Firebase errors during testing
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dice Game App', 
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AuthGate(), // Utilize rout handler to navigate based on authentication state
      routes: {
        '/diceGame': (context) => const DiceGame(),
        '/signUp': (context) => const SignUpScreen(),
      },
    );
  }
}

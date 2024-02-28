import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_record.dart'; 

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  LeaderboardScreenState createState() => LeaderboardScreenState();
}

class LeaderboardScreenState extends State<LeaderboardScreen> {
  Future<List<UserRecord>> fetchLeaderboard() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('users').get();
    List<UserRecord> users = querySnapshot.docs.map((doc) {
      final data = doc.data();
      return UserRecord(
        userId: doc.id,
        username: data['username'] ?? '',
        email: data['email'] ?? '',
        wins: data['wins'] ?? 0,
        losses: data['losses'] ?? 0,
        draws: data['draws'] ?? 0,
      );
    }).toList();

    users.sort((a, b) => b.winPercentage.compareTo(a.winPercentage));
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
      ),
      body: FutureBuilder<List<UserRecord>>(
        future: fetchLeaderboard(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading leaderboard'));
          }

          final users = snapshot.data ?? [];
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user.username), // Change from 'email' to 'username'
                subtitle: Text('Wins: ${user.wins}, Losses: ${user.losses}, Draws: ${user.draws}'),
                trailing: Text('Win%: ${user.winPercentage.toStringAsFixed(2)}'),
              );
            },
          );
        },
      ),
    );
  }
}

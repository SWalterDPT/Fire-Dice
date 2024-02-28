
class UserRecord {
  final String userId;
  final String username;
  final String email;
  final int wins;
  final int losses;
  final int draws;
  double get winPercentage => (wins+losses+draws) > 0 ? wins / (wins+losses+draws) * 100 : 0;

  UserRecord({
    required this.userId,
    required this.username,
    required  this.email,
    required this.wins,
    required this.losses,
    required this.draws,
  });

  factory UserRecord.fromFirestore(Map<String, dynamic> firestoreDoc, String docId) {
    return UserRecord(
      userId: docId,
      username: firestoreDoc['username'] ?? 'No Username', 
      email: firestoreDoc['email'] ?? 'No Email', 
      wins: firestoreDoc['wins'] ?? 0, 
      losses: firestoreDoc['losses'] ?? 0, 
      draws: firestoreDoc['draws'] ?? 0,
      );
  }
}
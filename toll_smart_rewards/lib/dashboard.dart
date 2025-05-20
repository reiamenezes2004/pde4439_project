import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  final String username;
  final int points;
  final String firstName;
  final String lastName;

  const Dashboard({
    super.key,
    required this.username,
    required this.points,
    required this.firstName,
    required this.lastName,
  });

  String getTier(int points) {
    if (points >= 300) return "Platinum";
    if (points >= 200) return "Gold";
    if (points >= 100) return "Silver";
    return "Bronze";
  }

  @override
  Widget build(BuildContext context) {
    final String tier = getTier(points);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Your Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, $firstName $lastName!',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Points: $points',
              style: const TextStyle(fontSize: 20, color: Colors.white70),
            ),
            const SizedBox(height: 20),
            Text(
              'Tier: $tier',
              style: TextStyle(
                fontSize: 22,
                color: Colors.deepPurple[200],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 40),
            Icon(
              Icons.emoji_events,
              size: 60,
              color: Colors.deepPurple[100],
            ),
          ],
        ),
      ),
    );
  }
}

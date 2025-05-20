import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Dashboard extends StatefulWidget {
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

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  late AnimationController _animationController;
  List<Map<String, dynamic>> cart = [];
  late int remainingPoints;

  @override
  void initState() {
    super.initState();
    remainingPoints = widget.points;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void showTierInfo() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1B003B),
        title: const Text('Tier Information', style: TextStyle(color: Colors.white, fontSize: 20)),
        content: const Text(
          '• Bronze: 0–49 pts\n• Silver: 50–99 pts\n• Gold: 100–199 pts\n• Platinum: 200+ pts',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.deepPurpleAccent)),
          )
        ],
      ),
    );
  }

  void showLogoutConfirm() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // go back to login
            },
            child: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String tier = 'Bronze';
    Color tierColor = Colors.brown;
    if (remainingPoints >= 200) {
      tier = 'Platinum';
      tierColor = Colors.blueGrey;
    } else if (remainingPoints >= 100) {
      tier = 'Gold';
      tierColor = Colors.amber;
    } else if (remainingPoints >= 50) {
      tier = 'Silver';
      tierColor = Colors.grey;
    }
    double progress = (remainingPoints % 50) / 50;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF240046), Color(0xFF3C096C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Welcome, ${widget.firstName} ${widget.lastName}!',
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const Text('👋', style: TextStyle(fontSize: 26)),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: showLogoutConfirm,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5F33A7), Color(0xFF3F0071)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amberAccent),
                          const SizedBox(width: 8),
                          const Text('Points:', style: TextStyle(fontSize: 18, color: Colors.white70)),
                          const Spacer(),
                          GestureDetector(
                            onTap: showTierInfo,
                            child: const Icon(Icons.info_outline, color: Colors.white60),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: Colors.purpleAccent,
                        child: Text(
                          '$remainingPoints',
                          style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.verified_user, color: Colors.white),
                          const SizedBox(width: 6),
                          Text('Tier: $tier', style: TextStyle(color: tierColor, fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 10,
                          color: tierColor,
                          backgroundColor: Colors.white24,
                        ),
                      ),
                      Text('${(progress * 50).round()}/50 pts to next tier',
                          style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

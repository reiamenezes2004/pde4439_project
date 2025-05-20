import 'package:flutter/material.dart';
// import 'login_screen.dart';
import 'dashboard_placeholder.dart';

void main() {
  runApp(const TollSmartRewardsApp());
}

class TollSmartRewardsApp extends StatelessWidget {
  const TollSmartRewardsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toll Smart Rewards',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF1E1E2C),
      ),
      home: const DashboardPlaceholder(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome to Toll Smart Rewards!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

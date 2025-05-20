import 'package:flutter/material.dart';
import 'helpers/db_helper.dart';
import 'screens/dashboard.dart';

void main() {
  runApp(const SalikApp());
}

class SalikApp extends StatelessWidget {
  const SalikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salik SmartRewards',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _obscurePassword = true;
  String error = '';
  bool _isLoading = false;

  void login() async {
    setState(() {
      _isLoading = true;
      error = '';
    });

    final user = _username.text.trim();
    final pass = _password.text.trim();

    final result = await DBHelper.authenticateUser(user, pass);

    if (!mounted) return;

    if (result != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => Dashboard(
            username: result['username'],
            points: result['points'],
            firstName: result['first_name'],
            lastName: result['last_name'],
          ),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
        error = 'Invalid credentials.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B003B),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Salik SmartRewards',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              const Text(
                'because your commute deserves a reward :)',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _username,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Salik ID',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.deepPurple.shade900,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _password,
                obscureText: _obscurePassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.deepPurple.shade900,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.white),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator(color: Colors.deepPurpleAccent)
                  : ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text('LOGIN', style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
              if (error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(error, style: const TextStyle(color: Colors.redAccent)),
                )
            ],
          ),
        ),
      ),
    );
  }
}

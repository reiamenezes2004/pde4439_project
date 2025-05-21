import 'package:flutter/material.dart';
import 'screens/dashboard.dart';
import 'helpers/db_helper.dart';

void main() {
  runApp(const TollApp());
}

class TollApp extends StatelessWidget {
  const TollApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toll SmartRewards',
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

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _obscurePassword = true;
  String error = '';
  bool _isLoading = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_fadeController);
    _fadeController.forward();
  }

  void login() async {
    setState(() {
      _isLoading = true;
      error = '';
    });

    await Future.delayed(const Duration(seconds: 2));
    final user = _username.text.trim();
    final pass = _password.text.trim();

    final result = await DBHelper.authenticateUser(user, pass);

    if (!mounted) return;

    if (result != null) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (context, animation, secondaryAnimation) => FadeTransition(
            opacity: animation,
            child: Dashboard(
              username: result['username'],
              points: result['points'],
              firstName: result['first_name'],
              lastName: result['last_name'],
            ),
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

  void showAppInfo() {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: const Color(0xFF2C003E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'About Us   ',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.info_outline,
                  color: Colors.purpleAccent,
                  size: 26,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Toll SmartRewards is a next-generation reward redemption kiosk designed to enhance the experience '
              'of toll road users. By combining smart technology with seamless interaction, our system allows users '
              'to redeem rewards effortlessly. With a focus on innovation, security, and user satisfaction, Toll SmartRewards brings convenience and appreciation to your everyday commute—because every journey deserves a reward :)',
              style: TextStyle(fontSize: 18, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9F5FFF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 6,
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}



  void showResetPasswordDialog() {
  final usernameController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      bool usernameChecked = false;
      bool userFound = false;

      return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color(0xFF1B003B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Reset Password', style: TextStyle(color: Colors.white, fontSize: 22)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!usernameChecked) ...[
                TextField(
                  controller: usernameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Enter Username',
                    hintStyle: TextStyle(color: Colors.white38),
                  ),
                ),
              ] else if (userFound) ...[
                TextField(
                  controller: oldPasswordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Old Password',
                    hintStyle: TextStyle(color: Colors.white38),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'New Password',
                    hintStyle: TextStyle(color: Colors.white38),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Confirm Password',
                    hintStyle: TextStyle(color: Colors.white38),
                  ),
                ),
              ] else ...[
                const Text(
                  'Username not found. Please try again.',
                  style: TextStyle(color: Colors.redAccent, fontSize: 16),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              child: Text(usernameChecked ? 'Update' : 'Check', style: const TextStyle(color: Colors.white)),
              onPressed: () async {
                final username = usernameController.text.trim();

                if (!usernameChecked) {
                  final exists = await DBHelper.doesUserExist(username);
                  setState(() {
                    usernameChecked = true;
                    userFound = exists;
                  });
                } else if (userFound) {
                  final oldPass = oldPasswordController.text.trim();
                  final newPass = newPasswordController.text.trim();
                  final confirmPass = confirmPasswordController.text.trim();

                  final valid = await DBHelper.authenticateUser(username, oldPass);
                  if (valid == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Old password incorrect.')));
                    return;
                  }

                  if (newPass != confirmPass) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match.')));
                    return;
                  }

                  final success = await DBHelper.updatePassword(username, newPass);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(success ? 'Password updated!' : 'Failed to update.')),
                  );
                }
              },
            ),
          ],
        ),
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2C003E), Color(0xFF1B003B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Toll SmartRewards',
                          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFFEADCFD)),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          iconSize: 30,
                          icon: const Icon(Icons.info_outline, color: Colors.white70),
                          onPressed: showAppInfo,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'because your commute deserves a reward :)',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic, color: Color(0xFFB9A2D8)),
                    ),
                    const SizedBox(height: 50),
                    TextField(
                      controller: _username,
                      style: const TextStyle(color: Colors.white, fontSize: 22),
                      decoration: InputDecoration(
                        hintText: 'Username',
                        hintStyle: const TextStyle(color: Color(0xFFD3B8FF), fontSize: 20),
                        filled: true,
                        fillColor: const Color(0xB33A206B),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _password,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: Colors.white, fontSize: 22),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: const TextStyle(color: Color(0xFFD3B8FF), fontSize: 20),
                        filled: true,
                        fillColor: const Color(0xB33A206B),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.white),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: showResetPasswordDialog,
                        child: const Text('Forgot Password?', style: TextStyle(fontSize: 20, color: Colors.purpleAccent)),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _isLoading
                        ? const CircularProgressIndicator(color: Color(0xFF9F5FFF))
                        : SizedBox(
                            width: size.width * 0.4,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF9F5FFF),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                elevation: 12,
                                shadowColor: Colors.purpleAccent.withOpacity(0.4),
                              ),
                              child: const Text('LOGIN', style: TextStyle(fontSize: 20, color: Colors.white)),
                            ),
                          ),
                    if (error.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(error, style: const TextStyle(color: Colors.redAccent, fontSize: 18)),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

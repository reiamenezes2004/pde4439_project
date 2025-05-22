import 'package:flutter/material.dart';
import 'helpers/db_helper.dart';
import 'screens/dashboard.dart';

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

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  String error = '';
  bool _isLoading = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_fadeController);
    _fadeController.forward();
  }

  void login() async {
    setState(() {
      _isLoading = true;
      error = '';
    });

    await Future.delayed(const Duration(seconds: 1));
    final user = _username.text.trim();
    final pass = _password.text.trim();

    final result = await DBHelper.authenticateUser(user, pass);
    if (!mounted) return;

    if (result != null) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder:
              (context, animation, _) => FadeTransition(
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
      builder:
          (_) => Dialog(
            backgroundColor: const Color(0xFF2C003E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'About Us',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.info_outline,
                        size: 26,
                        color: Colors.purpleAccent,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'Toll SmartRewards is a next-generation reward redemption kiosk designed to enhance the experience '
                    'of toll road users. By combining smart technology with seamless interaction, our system allows users '
                    'to redeem rewards effortlessly. With a focus on innovation, security, and user satisfaction, Toll SmartRewards '
                    'brings convenience and appreciation to your everyday commute—because every journey deserves a reward :)',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9F5FFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
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
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    bool usernameChecked = false;
    bool userExists = false;

    showDialog(
      context: context,
      builder:
          (_) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  backgroundColor: const Color(0xFF1B003B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: const Text(
                    'Reset Password',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!usernameChecked) ...[
                        TextField(
                          controller: usernameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Enter Username',
                            hintStyle: TextStyle(color: Colors.white54),
                          ),
                        ),
                      ] else if (userExists) ...[
                        const Icon(
                          Icons.check_circle,
                          color: Colors.greenAccent,
                          size: 28,
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: newPasswordController,
                          obscureText: _obscureNew,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'New Password',
                            hintStyle: const TextStyle(color: Colors.white54),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureNew
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white,
                              ),
                              onPressed:
                                  () => setState(
                                    () => _obscureNew = !_obscureNew,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: confirmPasswordController,
                          obscureText: _obscureConfirm,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Confirm Password',
                            hintStyle: const TextStyle(color: Colors.white54),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirm
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white,
                              ),
                              onPressed:
                                  () => setState(
                                    () => _obscureConfirm = !_obscureConfirm,
                                  ),
                            ),
                          ),
                        ),
                      ] else ...[
                        const Text(
                          'Username not found.',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ],
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final user = usernameController.text.trim();
                        if (!usernameChecked) {
                          final exists = await DBHelper.doesUserExist(user);
                          setState(() {
                            usernameChecked = true;
                            userExists = exists;
                          });
                        } else if (userExists) {
                          final newPass = newPasswordController.text;
                          final confirmPass = confirmPasswordController.text;
                          if (newPass != confirmPass) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Passwords do not match'),
                              ),
                            );
                            return;
                          }
                          final reused = await DBHelper.authenticateUser(
                            user,
                            newPass,
                          );
                          if (reused != null) {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('New password must be different'),
                              ),
                            );
                            return;
                          }
                          if (!mounted) return;
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          showDialog(
                            // ignore: use_build_context_synchronously
                            context: context,
                            builder:
                                (_) => AlertDialog(
                                  backgroundColor: Colors.deepPurple[900],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: const Text(
                                    'Success!',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  content: const Text(
                                    'Password updated. You can now log in.',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                      child: Text(usernameChecked ? 'Update' : 'Check'),
                    ),
                  ],
                ),
          ),
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
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFEADCFD),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          color: Colors.white70,
                          onPressed: showAppInfo,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'because your commute deserves a reward :)',
                      style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFFB9A2D8),
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      controller: _username,
                      style: const TextStyle(color: Colors.white, fontSize: 22),
                      decoration: InputDecoration(
                        hintText: 'Username',
                        hintStyle: const TextStyle(
                          color: Color(0xFFD3B8FF),
                          fontSize: 20,
                        ),
                        filled: true,
                        fillColor: const Color(0xB33A206B),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _password,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: Colors.white, fontSize: 22),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: const TextStyle(
                          color: Color(0xFFD3B8FF),
                          fontSize: 20,
                        ),
                        filled: true,
                        fillColor: const Color(0xB33A206B),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                          ),
                          onPressed:
                              () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: showResetPasswordDialog,
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.purpleAccent,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _isLoading
                        ? const CircularProgressIndicator(
                          color: Color(0xFF9F5FFF),
                        )
                        : ElevatedButton(
                          onPressed: login,
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(size.width * 0.5, 55),
                            backgroundColor: const Color(0xFF9F5FFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'LOGIN',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                    if (error.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          error,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 18,
                          ),
                        ),
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

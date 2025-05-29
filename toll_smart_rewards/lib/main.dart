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
      title: 'Toll Smart Rewards',
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
  String error = '';
  bool _isLoading = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  bool _obscureNew = true;
  bool _obscureConfirm = true;

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
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (_) => AlertDialog(
              backgroundColor: const Color(0xFF2C003E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                'Login Successful!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              content: const Text(
                'Welcome back to Toll Smart Rewards!',
                style: TextStyle(color: Color(0xFFD3B8FF), fontSize: 16),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
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
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9F5FFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
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
                    'Toll Smart Rewards is a next-generation reward redemption kiosk designed to enhance the experience '
                    'of toll road users. By combining smart technology with seamless interaction, our system allows users '
                    'to redeem rewards effortlessly. With a focus on innovation, security, and user satisfaction, Toll Smart Rewards '
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

  void showPasswordResetSuccessDialog() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (_) => AlertDialog(
              backgroundColor: const Color(0xFF2C003E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                'Success!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              content: const Text(
                'Your new password has been updated.\nPlease log in again.',
                style: TextStyle(color: Color(0xFFD3B8FF), fontSize: 16),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    setState(() {
                      _username.text = '';
                      _password.text = '';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9F5FFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
      );
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  //   @override
  //   Widget build(BuildContext context) {
  //     return const Placeholder(); // Replace this with your actual UI
  //   }
  // }

  void showResetPasswordDialog() {
    final usernameController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    bool usernameChecked = false;
    bool userExists = false;
    String feedbackMessage = '';
    Color feedbackColor = Colors.transparent;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  backgroundColor: const Color(0xFF1B003B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  title: const Text(
                    'Reset Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!usernameChecked) ...[
                          TextField(
                            controller: usernameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Enter Username',
                              hintStyle: const TextStyle(color: Colors.white54),
                              filled: true,
                              fillColor: const Color(0xB33A206B),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          TextField(
                            controller: newPasswordController,
                            obscureText: _obscureNew,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'New Password',
                              hintStyle: const TextStyle(color: Colors.white54),
                              filled: true,
                              fillColor: const Color(0xB33A206B),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureNew
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white,
                                ),
                                onPressed:
                                    () => setState(() {
                                      _obscureNew = !_obscureNew;
                                    }),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: confirmPasswordController,
                            obscureText: _obscureConfirm,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Confirm Password',
                              hintStyle: const TextStyle(color: Colors.white54),
                              filled: true,
                              fillColor: const Color(0xB33A206B),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirm
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white,
                                ),
                                onPressed:
                                    () => setState(() {
                                      _obscureConfirm = !_obscureConfirm;
                                    }),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        if (feedbackMessage.isNotEmpty)
                          Text(
                            feedbackMessage,
                            style: TextStyle(color: feedbackColor),
                          ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final user = usernameController.text.trim();

                        if (!usernameChecked) {
                          if (user.isEmpty) {
                            setState(() {
                              feedbackMessage = 'Enter a valid username';
                              feedbackColor = Colors.redAccent;
                            });
                            return;
                          }

                          final exists = await DBHelper.doesUserExist(user);
                          setState(() {
                            usernameChecked = true;
                            userExists = exists;
                            feedbackMessage =
                                exists
                                    ? 'Username found'
                                    : 'Username not found';
                            feedbackColor =
                                exists ? Colors.greenAccent : Colors.redAccent;
                          });
                        } else if (usernameChecked && !userExists) {
                          setState(() {
                            usernameChecked = false;
                            userExists = false;
                            usernameController.clear();
                            feedbackMessage = '';
                            feedbackColor = Colors.transparent;
                          });
                        } else if (userExists) {
                          final newPass = newPasswordController.text;
                          final confirmPass = confirmPasswordController.text;

                          if (newPass != confirmPass) {
                            setState(() {
                              feedbackMessage = 'Passwords do not match';
                              feedbackColor = Colors.redAccent;
                            });
                            return;
                          }

                          final reused = await DBHelper.authenticateUser(
                            user,
                            newPass,
                          );
                          if (reused != null) {
                            setState(() {
                              feedbackMessage =
                                  'New password must be different';
                              feedbackColor = Colors.redAccent;
                            });
                            return;
                          }

                          final success = await DBHelper.updatePassword(
                            user,
                            newPass,
                          );
                          if (!success) {
                            setState(() {
                              feedbackMessage =
                                  'Failed to update password. Try again.';
                              feedbackColor = Colors.redAccent;
                            });
                            return;
                          }

                          if (!mounted) return;
                          Navigator.pop(context);
                          showPasswordResetSuccessDialog();

                          Future.delayed(const Duration(milliseconds: 200), () {
                            if (!mounted) return;
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder:
                                  (_) => AlertDialog(
                                    backgroundColor: const Color(0xFF2C003E),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: const Text(
                                      'Success!',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                    ),
                                    content: const Text(
                                      'Password updated. You can now log in.',
                                      style: TextStyle(
                                        color: Color(0xFFD3B8FF),
                                        fontSize: 16,
                                      ),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(
                                            context,
                                            rootNavigator: true,
                                          ).pop();
                                          setState(() {
                                            _username.text = '';
                                            _password.text = '';
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF9F5FFF,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 10,
                                          ),
                                        ),
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            );
                          });
                        }
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9F5FFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        !usernameChecked
                            ? 'Check'
                            : userExists
                            ? 'Update'
                            : 'Try Again',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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
                      children: const [
                        Text(
                          'Toll Smart Rewards',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFEADCFD),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'because your commute deserves a reward :)',
                      textAlign: TextAlign.center,
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
                        onPressed: () {
                          // Add reset password logic here
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.purpleAccent,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

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

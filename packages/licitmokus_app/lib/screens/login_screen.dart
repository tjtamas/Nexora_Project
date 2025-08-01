import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'welcome_screen.dart';
import '../widgets/change_password_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      final user = FirebaseAuth.instance.currentUser;

      if (!mounted || user == null) return;

      // Ellenőrizzük: ez az első belépés?
      final creationTime = user.metadata.creationTime;
      final lastSignInTime = user.metadata.lastSignInTime;

      final isFirstLogin =
          creationTime != null &&
          lastSignInTime != null &&
          creationTime == lastSignInTime;

      if (isFirstLogin) {
        // Megjelenítjük a jelszócsere dialógust
        await showDialog(
          context: context,
          builder: (_) => ChangePasswordDialog(user: user),
        );
      }

      // Belépés után mindig továbbmegyünk WelcomeScreen-re
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      // 🔥 Itt a DEBUG print
      print("🔥 FirebaseAuthException");
      print("Code: ${e.code}");
      print("Message: ${e.message}");

      String errorMsg = switch (e.code) {
        'invalid-email' => 'Hibás e-mail cím.',
        'user-not-found' => 'Nem található ilyen felhasználó.',
        'wrong-password' => 'Hibás jelszó.',
        _ => 'Bejelentkezési hiba: ${e.message}',
      };

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMsg)));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/images/bidsquarrel_main.svg',
                  height: 220,
                  width: 220,
                  semanticsLabel: 'Licitmókus logo',
                ),
                const SizedBox(height: 16),
                Text(
                  'Licitmókus',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'E-mail'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Jelszó'),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                      onPressed: _login,
                      child: const Text('Bejelentkezés'),
                    ),
                TextButton(
                  onPressed: () {
                    // Jelszó reset jön majd később
                    print('Elfelejtett jelszó');
                  },
                  child: const Text('Elfelejtetted a jelszavad?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

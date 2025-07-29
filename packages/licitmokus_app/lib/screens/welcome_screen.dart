import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_screen.dart'; // 👈 importáljuk a login képernyőt

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Üdvözöl a Licitmókus'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Kijelentkezés',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child:
            user == null
                ? const Text('Nem vagy bejelentkezve.')
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Szia!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user.email ?? 'Ismeretlen email',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
      ),
    );
  }
}

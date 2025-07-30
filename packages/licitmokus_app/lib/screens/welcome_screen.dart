import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String? displayName;
  String? role;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (doc.exists) {
      final data = doc.data();
      setState(() {
        displayName = doc.data()?['displayName'] ?? user.email;
        role = data?['role'] ?? 'user';
      });
    } else {
      setState(() {
        displayName = user.email;
         role = 'user';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        leading: role == 'admin'
            ? IconButton(
                icon: const Icon(Icons.person_add),
                tooltip: 'Felhasználó rögzítése',
                onPressed: () {
                  // TODO: ide jön majd a felhasználó felvitel oldala
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Felhasználó létrehozás képernyő jön majd ide.")),
                  );
                },
              )
            : null,
        title: Text(
        displayName != null ? 'Üdvözöllek, $displayName!' : 'Üdvözöllek...',
      ),
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
        child: user == null
            ? const Text('Nem vagy bejelentkezve.')
              : const Text(
              'Jó munkát kíván a Licitmókus csapata! 🐿️',
              style: TextStyle(fontSize: 18),
            ),
      ),
    );
  }
}

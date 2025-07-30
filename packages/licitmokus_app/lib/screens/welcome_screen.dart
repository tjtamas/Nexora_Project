import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_screen.dart';
import '../widgets/admin_action_button.dart';
import '../widgets/update_points_dialog.dart'; // ✨ külön widgetként kezeljük

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
        displayName = data?['displayName'] ?? user.email;
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
      backgroundColor: const Color(0xFFE8F1F5), 
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          displayName != null ? 'Üdvözöllek, $displayName!' : 'Üdvözöllek...',
          style: const TextStyle(fontSize: 20),
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
      body: user == null
          ? const Center(child: Text('Nem vagy bejelentkezve.'))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (role == 'admin') ...[
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        AdminActionButton(
                          icon: Icons.person_add,
                          label: "Felhasználó hozzáadása",
                          color: Colors.blue,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Felhasználó létrehozás jön majd ide.")),
                            );
                          },
                        ),
                        AdminActionButton(
                          icon: Icons.star,
                          label: "Licitpontok beállítása",
                          color: Colors.orange,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => const UpdatePointsDialog(),
                            );
                          },
                        ),
                        AdminActionButton(
                          icon: Icons.access_time,
                          label: "Munkaidők",
                          color: Colors.teal,
                          onTap: () {},
                        ),
                        AdminActionButton(
                          icon: Icons.beach_access,
                          label: "Szabadságok",
                          color: Colors.green,
                          onTap: () {},
                        ),
                        AdminActionButton(
                          icon: Icons.settings,
                          label: "Beállítások",
                          color: Colors.grey,
                          onTap: () {},
                        ),
                        AdminActionButton(
                          icon: Icons.analytics,
                          label: "Kimutatások",
                          color: Colors.deepPurple,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 32),
                  const Center(
                    child: Text(
                      'Jó munkát kíván a Licitmókus csapata! 🐿️',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

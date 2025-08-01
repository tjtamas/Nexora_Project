import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({super.key});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _role = 'user';
  DateTime? _joinedDate;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Új felhasználó hozzáadása'),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Felhasználónév'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Jelszó'),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              const Text(
                'Jogkör',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: _role,
                isExpanded: true,
                onChanged: (value) => setState(() => _role = value!),
                items:
                    ['user', 'admin']
                        .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                        .toList(),
              ),
              const SizedBox(height: 16),
              TextButton(
                child: Text(
                  _joinedDate == null
                      ? 'Munkába állás dátuma'
                      : _joinedDate!.toLocal().toString().split(' ')[0],
                  style: const TextStyle(fontSize: 16),
                ),
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => _joinedDate = picked);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Mégse'),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child:
              _isLoading
                  ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : const Text('Mentés'),
          onPressed: _isLoading ? null : _createUser,
        ),
      ],
    );
  }

  Future<void> _createUser() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final joinedDate = _joinedDate;

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        joinedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kérlek tölts ki minden mezőt!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Auth user létrehozása
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      String uid = userCredential.user!.uid;

      // 2. Firestore dokumentum létrehozása
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'username': username,
        'email': email,
        'role': _role,
        'joinedDate': Timestamp.fromDate(joinedDate),
        'createdAt': Timestamp.now(),
        'points': 0,
      });

      // 3. Visszajelzés + kilépés
      if (context.mounted) {
        await showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text('Sikeres művelet'),
                content: const Text('A felhasználó sikeresen létrehozva.'),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
        );

        // És ezután zárjuk be az AddUserDialog-ot is
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hiba: ${e.message}'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ismeretlen hiba történt!'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

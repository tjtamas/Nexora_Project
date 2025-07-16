import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'screens/login_screen.dart';
import 'themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase inicializálás platformfüggően
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAHqbVlARnFm-kBSLrSMdJ8WHYjY7utQFs", // <- FRISSÍTETT API kulcs
        authDomain: "licitmokusapp.firebaseapp.com",
        projectId: "licitmokusapp",
        storageBucket: "licitmokusapp.firebasestorage.app", // <- FRISSÍTETT storageBucket
        messagingSenderId: "494348798446",
        appId: "1:494348798446:web:1b3313e054bd1c9bbaa6ff",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Licitmókus',
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

import 'package:antrean_app/screens/auth_screen/login_screen.dart';
import 'package:antrean_app/screens/start_screen/opening_screen.dart';
import 'package:antrean_app/utils/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Antrean',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const OpeningScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}

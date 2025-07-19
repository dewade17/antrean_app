import 'package:antrean_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class OpeningScreen extends StatefulWidget {
  const OpeningScreen({super.key});

  @override
  State<OpeningScreen> createState() => _OpeningScreenState();
}

class _OpeningScreenState extends State<OpeningScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Center(
              child: Text(
                "SELAMAT DATANG",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w800,
                  shadows: [
                    Shadow(
                      offset: Offset(
                          2, 2), // posisi bayangan (horizontal, vertikal)
                      blurRadius: 5.0, // seberapa blur bayangannya
                      color: Colors.black.withOpacity(0.25), // 25% transparansi
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Image.asset(
                "assets/public/images/opening_screen/Image_stetoskop.png")
          ],
        ),
      ),
    );
  }
}

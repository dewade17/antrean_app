// ignore_for_file: deprecated_member_use

import 'package:antrean_app/constraints/colors.dart';
import 'package:flutter/material.dart';

class HeaderContent extends StatelessWidget {
  const HeaderContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "INFORMASI KESEHATAN",
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        color: AppColors.textDefaultColor,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
        fontSize: 25,
        shadows: [
          Shadow(
            offset: Offset(2, 2), // posisi bayangan (horizontal, vertikal)
            blurRadius: 5.0, // seberapa blur bayangannya
            color: Colors.black.withOpacity(0.25), // 25% transparansi
          ),
        ],
      ),
    );
  }
}

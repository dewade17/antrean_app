import 'package:antrean_app/constraints/colors.dart';
import 'package:flutter/material.dart';

class ButtonKonfirmasi extends StatelessWidget {
  final VoidCallback onTap;
  const ButtonKonfirmasi({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
          color: AppColors.primaryColor,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 150, vertical: 15),
            child: Text(
              "Perbarui",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.accentColor),
            ),
          )),
    );
  }
}

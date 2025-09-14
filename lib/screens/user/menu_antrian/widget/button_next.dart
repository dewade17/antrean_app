import 'package:antrean_app/constraints/colors.dart';
import 'package:flutter/material.dart';

class ButtonNext extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  const ButtonNext({super.key, required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
          elevation: 2,
          color: AppColors.primaryColor,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 150, vertical: 15),
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: AppColors.accentColor),
            ),
          )),
    );
  }
}

import 'package:antrean_app/constraints/colors.dart';
import 'package:flutter/material.dart';

class ButtonBack extends StatelessWidget {
  final VoidCallback onTap;

  const ButtonBack({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
          elevation: 2,
          color: AppColors.primaryColor,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 160, vertical: 15),
            child: Text(
              "Kembali",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: AppColors.accentColor),
            ),
          )),
    );
  }
}

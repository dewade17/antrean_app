import 'package:antrean_app/constraints/colors.dart';
import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool loading; // <-- tambah

  const RegisterButton({
    super.key,
    required this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
          color: AppColors.primaryColor,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 150, vertical: 15),
            child: Text(
              loading ? "Memproses..." : "Daftar",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.accentColor),
            ),
          )),
    );
  }
}

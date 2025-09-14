import 'package:antrean_app/constraints/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Selamat Datang Kembali",
          style: GoogleFonts.poppins(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryColor,
          ),
        ),
        Text(
          "Masuk sekarang, antri jadi lebih mudah dan cepat",
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: AppColors.textDefaultColor,
          ),
        ),
      ],
    );
  }
}

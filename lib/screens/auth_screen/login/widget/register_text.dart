import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:antrean_app/utils/colors.dart';

class RegisterText extends StatelessWidget {
  const RegisterText({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/register');
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Belum memiliki akun ?",
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textDefaultColor,
            ),
          ),
          Text(
            " Daftar akun baru",
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.secondaryColor,
            ),
          )
        ],
      ),
    );
  }
}

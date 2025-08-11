import 'package:antrean_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderDetailDokter extends StatelessWidget {
  const HeaderDetailDokter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.accentColor,
                AppColors.backgroundColor,
              ],
            ), // Ganti sesuai warna background yang diinginkan
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Image.asset(
              "assets/images/Dokter_1.png",
              width: 40,
              height: 40,
              // fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "dr. Xxxx Xxxx Sp.Xx",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.accentColor,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          "Dokter Spesialis Xx",
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.accentColor,
          ),
        )
      ],
    );
  }
}

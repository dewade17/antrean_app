import 'package:antrean_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderTextInformasi extends StatefulWidget {
  const HeaderTextInformasi({super.key});

  @override
  State<HeaderTextInformasi> createState() => _HeaderTextState();
}

class _HeaderTextState extends State<HeaderTextInformasi> {
  @override
  Widget build(BuildContext context) {
    return Text(
      "INFORMASI \nKETERSEDIAAN DOKTER",
      style: GoogleFonts.poppins(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: AppColors.accentColor,
      ),
      textAlign: TextAlign.center,
    );
  }
}

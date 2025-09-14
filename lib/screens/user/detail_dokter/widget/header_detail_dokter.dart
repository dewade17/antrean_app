import 'package:antrean_app/provider/dokter/detail_dokter_provider.dart';
import 'package:antrean_app/constraints/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class HeaderDetailDokter extends StatelessWidget {
  const HeaderDetailDokter({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<DetailDokterProvider>();
    final d = prov.dokter;

    final nama = d?.namaDokter ?? "dr. Xxxx Xxxx Sp.Xx";
    final spes = d?.spesialisasi ?? "Dokter Spesialis Xx";
    final foto =
        (d?.fotoProfilDokter is String) ? (d!.fotoProfilDokter as String) : '';

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
            ),
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: (foto.isNotEmpty)
                ? Image.network(
                    foto,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    "assets/images/Dokter_1.png",
                    width: 40,
                    height: 40,
                    // fit: BoxFit.cover, // biarkan sama seperti desain awal
                  ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          nama,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.accentColor,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 5),
        Text(
          spes,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.accentColor,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

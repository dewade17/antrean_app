import 'package:antrean_app/provider/Auth/auth_provider.dart';
import 'package:antrean_app/constraints/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HeaderHome extends StatelessWidget {
  const HeaderHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Hi, Ode", //name.user
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textDefaultColor,
            ),
          ),
          PopupMenuButton<int>(
            icon: const Icon(Icons.person),
            color: AppColors.accentColor,
            onSelected: (value) {
              if (value == 2) {
                //   Navigator.pushNamed(context, '/profile-users');
                // } else if (value == 3) {
                Navigator.pushNamed(context, '/info');
              } else if (value == 4) {
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                authProvider.logout(context);
              }
            },
            itemBuilder: (context) => [
              // Item biru: Hi, User
              PopupMenuItem(
                value: 1,
                padding: EdgeInsets.zero, // agar Container bisa full width
                enabled: false, // non-klik
                child: Container(
                  width: double.infinity,
                  color: AppColors.backgroundColor, // latar biru muda
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Text(
                    "Hi, User",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: AppColors.textDefaultColor,
                    ),
                  ),
                ),
              ),
              // Lihat Profil
              PopupMenuItem(
                value: 2,
                child: Row(
                  children: [
                    const Icon(Icons.person_2_outlined),
                    const SizedBox(width: 10),
                    Text(
                      "Lihat Profil",
                      style: GoogleFonts.poppins(),
                    ),
                  ],
                ),
              ),
              // Informasi Aplikasi
              // PopupMenuItem(
              //   value: 3,
              //   child: Row(
              //     children: [
              //       const Icon(Icons.info_outline),
              //       const SizedBox(width: 10),
              //       Text(
              //         "Informasi Aplikasi",
              //         style: GoogleFonts.poppins(),
              //       ),
              //     ],
              //   ),
              // ),
              // Keluar
              PopupMenuItem(
                value: 4,
                child: Row(
                  children: [
                    const Icon(Icons.logout_outlined),
                    const SizedBox(width: 10),
                    Text(
                      "Keluar",
                      style: GoogleFonts.poppins(),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

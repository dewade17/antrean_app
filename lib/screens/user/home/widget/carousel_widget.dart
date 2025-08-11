import 'package:antrean_app/utils/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CarouselWidget extends StatelessWidget {
  const CarouselWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> customItems = [
      // Slide 1
      Padding(
          padding: const EdgeInsets.all(0),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/jadwal-dokter-screen');
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 6,
              margin: const EdgeInsets.all(0),
              clipBehavior: Clip.antiAlias,
              child: Container(
                height: 300,
                width: 350,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primaryColor, AppColors.secondaryColor],
                  ),
                ),
                child: Stack(
                  children: [
                    // Teks kiri atas
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Lihat Jadwal \nDokter",
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accentColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Cek ketersediaan dokter \nyang ingin menangani \nanda!",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppColors.accentColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Gambar kanan bawah
                    Positioned(
                      bottom: 3,
                      right: 10,
                      child: SizedBox(
                        width: 170,
                        height: 200,
                        child: Image.asset(
                          "assets/images/Carousel_2.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
      // Slide 2
      Padding(
        padding: const EdgeInsets.all(0),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/informasi-kesehatan-screen');
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 6,
            margin: const EdgeInsets.all(0),
            clipBehavior: Clip.antiAlias,
            child: Container(
              height: 300,
              width: 350,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primaryColor, AppColors.secondaryColor],
                ),
              ),
              child: Stack(
                children: [
                  // Teks kiri atas
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Informasi Kesehatan Terkini",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accentColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Dapatkan update \nterbaru seputar tips, \ninfo, dan berita \nkesehatan.",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.accentColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Gambar kanan bawah
                  Positioned(
                    bottom: 16,
                    right: 10,
                    child: SizedBox(
                      width: 170,
                      height: 200,
                      child: Image.asset(
                        "assets/images/Carousel_1.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // Slide 3
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/antrian-screen');
        },
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 6,
            margin: const EdgeInsets.all(0),
            clipBehavior: Clip.antiAlias,
            child: Container(
              height: 300,
              width: 350,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primaryColor, AppColors.secondaryColor],
                ),
              ),
              child: Stack(
                children: [
                  // Teks kiri atas
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Rencanakan Jadwal Pemeriksaan",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accentColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Daftarkan diri anda dan atur \njadwal pemeriksaan sesuai \nkeinginan!",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.accentColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Gambar kanan bawah
                  Positioned(
                    bottom: 0,
                    right: 10,
                    child: SizedBox(
                      width: 170,
                      height: 200,
                      child: Image.asset(
                        "assets/images/Register_Screen.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    ];

    final CarouselOptions options = CarouselOptions(
      height: 300,
      enableInfiniteScroll: false,
      enlargeCenterPage: true,
      viewportFraction: 0.85,
    );

    return CarouselSlider(
      items: customItems,
      options: options,
    );
  }
}

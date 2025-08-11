import 'package:antrean_app/screens/user/menu_informasi_kesehatan/more_menu_informasi_kesehatan/news_information/detail_news_information/video_detail_information.dart';
import 'package:antrean_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VideoKesehatan extends StatefulWidget {
  const VideoKesehatan({super.key});

  @override
  State<VideoKesehatan> createState() => _VideoKesehatanState();
}

class _VideoKesehatanState extends State<VideoKesehatan> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        horizontal: 0,
      ),
      child: Card(
        elevation: 5,
        color: AppColors.accentColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Video Kesehatan",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDefaultColor,
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        // Tambahkan logika pengurutan berdasarkan value di sini
                        if (value == 'Terbaru') {
                          // Urutkan berdasarkan terbaru
                        } else if (value == 'Terlama') {
                          // Urutkan berdasarkan terlama
                        }
                      },
                      icon: const Icon(Icons.more_horiz),
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          enabled:
                              false, // Menjadikan ini sebagai judul non-interaktif
                          child: Text(
                            'Urutkan berdasarkan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Terbaru',
                          child: Text('Terbaru'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Terlama',
                          child: Text('Terlama'),
                        ),
                      ],
                    ),
                  ],
                )),
            Padding(
                padding:
                    EdgeInsetsGeometry.symmetric(vertical: 0, horizontal: 5),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VideoDetailInformation()),
                    );
                  },
                  child: Card(
                    elevation: 2,
                    color: AppColors.accentColor,
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    child: Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            "assets/images/Video_Content.png",
                            width: 500,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              "Judul Video Kesehatan",
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDefaultColor,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              "1,4 juta penonton - 2 hari lalu",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textDefaultColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 16),
                      onPressed: () {
                        // Aksi ke halaman sebelumnya
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        // Aksi ke halaman 1
                      },
                      child: const Text(
                        "1",
                        style: TextStyle(color: AppColors.textDefaultColor),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Aksi ke halaman 2
                      },
                      child: const Text(
                        "2",
                        style: TextStyle(color: AppColors.textDefaultColor),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Aksi ke halaman 3
                      },
                      child: const Text(
                        "3",
                        style: TextStyle(color: AppColors.textDefaultColor),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 16),
                      onPressed: () {
                        // Aksi ke halaman selanjutnya
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

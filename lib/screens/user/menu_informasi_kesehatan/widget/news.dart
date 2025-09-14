import 'package:antrean_app/screens/user/menu_informasi_kesehatan/more_menu_informasi_kesehatan/news_information/detail_news_information/news_detail_information.dart';
import 'package:antrean_app/constraints/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Berita Kesehatan",
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
              ),
            ),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 0, horizontal: 5),
              child: Card(
                elevation: 2,
                color: AppColors.accentColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                child: Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            "assets/images/news_content.jpg",
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(
                              width: 10), // jarak antara gambar dan teks
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Judul Berita",
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textDefaultColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "Lorem ipsum dolor sit amet. Ad quas earum est magnam repellendus eum quod...",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textDefaultColor,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "25 Juli 2025",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.hintColor,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NewsDetailInformation()),
                                        );
                                      },
                                      child:
                                          Icon(Icons.arrow_forward, size: 16),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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

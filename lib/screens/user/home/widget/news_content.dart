import 'package:antrean_app/constraints/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsContent extends StatelessWidget {
  const NewsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        horizontal: 20,
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
              child: Text(
                "Berita Kesehatan",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDefaultColor,
                ),
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
                                    Icon(Icons.arrow_forward, size: 16),
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
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Selengkapnya ...",
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    color: AppColors.hintColor,
                  ),
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

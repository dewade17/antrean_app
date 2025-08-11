import 'package:antrean_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsDetailInformation extends StatefulWidget {
  const NewsDetailInformation({super.key});

  @override
  State<NewsDetailInformation> createState() => _NewsDetailInformationState();
}

class _NewsDetailInformationState extends State<NewsDetailInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Berita Kesehatan"),
        actions: [
          IconButton(
            icon: Icon(Icons.switch_access_shortcut),
            onPressed: () {
              // aksi ketika icon ditekan
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.accentColor,
                AppColors.backgroundColor,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "assets/images/news_content.jpg",
                fit: BoxFit.cover,
                // height: 280,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Text(
                  "Menjaga Kesehatan Gigi Sejak Dini, Investasi Seumur Hidup",
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDefaultColor,
                      wordSpacing: 3),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 25,
                ),
                child: Text(
                  "25 Juni 2025",
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.hintColor,
                      wordSpacing: 3),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Text(
                  "Kesehatan gigi sering kali dianggap sepele, padahal kondisi gigi dan mulut sangat memengaruhi kualitas hidup seseorang. Masalah seperti gigi berlubang, bau mulut, hingga penyakit gusi bisa berdampak pada kepercayaan diri dan kenyamanan saat makan ataupun berbicara. Oleh karena itu, menjaga kebersihan mulut sebaiknya dimulai sejak dini dengan kebiasaan menyikat gigi secara teratur dua kali sehari.\nMenurut para ahli kesehatan, menyikat gigi dengan benar dan rutin adalah langkah pertama untuk mencegah berbagai penyakit mulut. Namun, kebanyakan orang masih belum memahami teknik menyikat gigi yang tepat, termasuk jenis sikat dan pasta gigi yang sesuai dengan kondisi gigi masing-masing. Selain itu, penting juga untuk membatasi konsumsi makanan dan minuman tinggi gula yang dapat mempercepat kerusakan gigi.\nPemeriksaan rutin ke dokter gigi minimal enam bulan sekali juga menjadi langkah penting dalam menjaga kesehatan gigi. Dengan pemeriksaan berkala, masalah pada gigi dapat terdeteksi lebih awal dan dicegah sebelum menjadi parah. Ingat, senyum yang sehat dimulai dari gigi yang bersih dan terawat!",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textDefaultColor,
                    wordSpacing: 3,
                  ),
                  textAlign: TextAlign.justify,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

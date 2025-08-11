import 'package:antrean_app/screens/user/menu_jadwal_dokter/widget/content_jadwal_dokter.dart';
import 'package:antrean_app/screens/user/menu_jadwal_dokter/widget/header_text.dart';
import 'package:antrean_app/screens/user/menu_jadwal_dokter/widget/search_box.dart';
import 'package:antrean_app/utils/colors.dart';
import 'package:flutter/material.dart';

class MenuJadwalDokter extends StatefulWidget {
  const MenuJadwalDokter({super.key});

  @override
  State<MenuJadwalDokter> createState() => _MenuJadwalDokterState();
}

class _MenuJadwalDokterState extends State<MenuJadwalDokter> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        decoration: ShapeDecoration(
          shape:
              const RoundedRectangleBorder(), // atau BoxShape lain sesuai kebutuhan
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.accentColor,
              AppColors.backgroundColor,
            ],
          ),
        ),
        child: Stack(
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryColor,
                    AppColors.secondaryColor,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: SizedBox(
                    child: Image.asset(
                      "assets/images/Background_menu_dokter_2.png",
                      width: 700,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 60),
                child: HeaderText(),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 140,
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 32,
                  child: SearchBox(searchController: searchController),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: 230),
                child: ContentJadwalDokter(),
              ),
            ),
            SizedBox(
              height: 1000,
            ),
            Positioned(
              top: 40,
              left: 20,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pop(
                      context); // Atau arahkan ke halaman spesifik dengan Navigator.pushReplacement
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

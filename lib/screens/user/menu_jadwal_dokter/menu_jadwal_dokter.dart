import 'package:antrean_app/provider/dokter/dokter_provider.dart';
import 'package:antrean_app/screens/user/menu_jadwal_dokter/widget/content_jadwal_dokter.dart';
import 'package:antrean_app/screens/user/menu_jadwal_dokter/widget/header_text.dart';
import 'package:antrean_app/screens/user/menu_jadwal_dokter/widget/search_box.dart';
import 'package:antrean_app/constraints/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuJadwalDokter extends StatefulWidget {
  const MenuJadwalDokter({super.key});

  @override
  State<MenuJadwalDokter> createState() => _MenuJadwalDokterState();
}

class _MenuJadwalDokterState extends State<MenuJadwalDokter> {
  final TextEditingController searchController = TextEditingController();

  Future<void> _onRefresh() async {
    // refresh berdasarkan filter terakhir di DokterProvider
    await context.read<DokterProvider>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(), // agar bisa pull meski konten pendek
          child: Container(
            decoration: ShapeDecoration(
              shape: const RoundedRectangleBorder(),
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
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
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
                    padding: const EdgeInsets.only(top: 60),
                    child: const HeaderText(),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 140),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 32,
                      child: SearchBox(searchController: searchController),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 230),
                    child: const ContentJadwalDokter(),
                  ),
                ),
                const SizedBox(height: 1000),
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
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:antrean_app/screens/user/menu_informasi_kesehatan/more_menu_informasi_kesehatan/news_information/news_information.dart';
import 'package:antrean_app/screens/user/menu_informasi_kesehatan/widget/header_text_informasi.dart';
import 'package:antrean_app/screens/user/menu_informasi_kesehatan/widget/searchbox_informasi.dart';
import 'package:antrean_app/constraints/colors.dart';
import 'package:flutter/material.dart';

class InformasiKesehatanScreen extends StatelessWidget {
  const InformasiKesehatanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchinformationController =
        TextEditingController();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Container(
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
          child: Column(
            children: [
              // Header background + Gambar
              Stack(
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
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: HeaderTextInformasi(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 140),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 32,
                        child: SearchboxInformasi(
                          searchController: searchinformationController,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: "Berita"),
                  Tab(text: "Artikel"),
                  Tab(text: "Agenda \nKegiatan"),
                ],
              ),

              // Expanded to allow flexible height + scrollable TabBarView
              Expanded(
                child: TabBarView(
                  children: [
                    // Each child should be scrollable
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: NewsInformation(),
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Center(child: Text('Artikel')),
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Center(child: Text('Agenda Kegiatan')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

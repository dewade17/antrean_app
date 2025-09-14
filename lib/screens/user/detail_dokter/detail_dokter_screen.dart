import 'package:antrean_app/provider/dokter/detail_dokter_provider.dart';
import 'package:antrean_app/screens/user/detail_dokter/widget/calendar_dokter.dart';
import 'package:antrean_app/screens/user/detail_dokter/widget/header_detail_dokter.dart';
import 'package:antrean_app/constraints/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class DetailDokterScreen extends StatefulWidget {
  final String idDokter; // <- diteruskan ke CalendarDokter

  const DetailDokterScreen({super.key, required this.idDokter});

  @override
  State<DetailDokterScreen> createState() => _DetailDokterScreenState();
}

class _DetailDokterScreenState extends State<DetailDokterScreen> {
  Future<void> _onRefresh() async {
    await context.read<DetailDokterProvider>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            // Section: Background Header
            Container(
              height: 280,
              width: double.infinity,
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
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      "assets/images/Background_detail_dokter.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Back Button
                  Positioned(
                    top: 30,
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
                  // Header Dokter
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: const HeaderDetailDokter(),
                    ),
                  ),
                ],
              ),
            ),

            // Expanded scrollable content + pull-to-refresh
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: CalendarDokter(idDokter: widget.idDokter),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

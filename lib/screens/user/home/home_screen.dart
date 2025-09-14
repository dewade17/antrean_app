import 'package:antrean_app/provider/book_antrean/get_booking_antrean.dart';
import 'package:antrean_app/screens/user/home/widget/carousel_widget.dart';
import 'package:antrean_app/screens/user/home/widget/half_oval_painter.dart';
import 'package:antrean_app/screens/user/home/widget/header_content.dart';
import 'package:antrean_app/screens/user/home/widget/header_home.dart';
import 'package:antrean_app/screens/user/home/widget/informasi_antrean_widget.dart';
import 'package:antrean_app/screens/user/home/widget/news_content.dart';
import 'package:antrean_app/screens/user/home/widget/video_content.dart';
import 'package:antrean_app/constraints/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch awal ringkas (aktif)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GetBookingProvider>().fetch(status: 'active', limit: 1);
    });
  }

  Future<void> _onRefresh() async {
    await context.read<GetBookingProvider>().fetch(status: 'active', limit: 1);
  }

  @override
  Widget build(BuildContext context) {
    final bookingProv = context.watch<GetBookingProvider>();
    final bool hasBooking = bookingProv.items.isNotEmpty;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.accentColor,
            AppColors.backgroundColor,
            AppColors.accentColor
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: RefreshIndicator(
            color: AppColors.primaryColor,
            backgroundColor: Colors.white,
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CustomPaint(
                        size: Size(MediaQuery.of(context).size.width, 300),
                        painter: HalfOvalPainter(),
                      ),
                      const HeaderHome(),
                      Align(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 80, bottom: 20),
                          child: const CarouselWidget(),
                        ),
                      ),
                    ],
                  ),

                  // ⬇️ Tampilkan InformasiAntreanWidget hanya jika ada booking
                  if (hasBooking) const InformasiAntreanWidget(),
                  if (hasBooking) const SizedBox(height: 20),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35),
                        ),
                      ),
                      color: AppColors.accentColor,
                    ),
                    child: const Column(
                      children: [
                        SizedBox(height: 20),
                        Center(child: HeaderContent()),
                        SizedBox(height: 30),
                        NewsContent(),
                        SizedBox(height: 20),
                        VideoContent(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

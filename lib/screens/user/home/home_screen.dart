import 'package:antrean_app/screens/user/home/widget/carousel_widget.dart';
import 'package:antrean_app/screens/user/home/widget/half_oval_painter.dart';
import 'package:antrean_app/screens/user/home/widget/header_content.dart';
import 'package:antrean_app/screens/user/home/widget/header_home.dart';
import 'package:antrean_app/screens/user/home/widget/news_content.dart';
import 'package:antrean_app/screens/user/home/widget/video_content.dart';
import 'package:antrean_app/utils/colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
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
            child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  CustomPaint(
                    size: Size(MediaQuery.of(context).size.width, 300),
                    painter: HalfOvalPainter(),
                  ),
                  HeaderHome(),
                  Align(
                    child: Padding(
                      padding: EdgeInsets.only(top: 80, bottom: 20),
                      child: CarouselWidget(),
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: ShapeDecoration(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      ),
                    ),
                    color: AppColors.accentColor),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: HeaderContent(),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    NewsContent(),
                    SizedBox(
                      height: 20,
                    ),
                    VideoContent(),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}

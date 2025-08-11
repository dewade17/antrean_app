import 'package:antrean_app/screens/user/menu_informasi_kesehatan/widget/news.dart';
import 'package:antrean_app/screens/user/menu_informasi_kesehatan/widget/video_kesehatan.dart';
import 'package:flutter/material.dart';

class NewsInformation extends StatefulWidget {
  const NewsInformation({super.key});

  @override
  State<NewsInformation> createState() => _NewsInformationState();
}

class _NewsInformationState extends State<NewsInformation> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        News(),
        SizedBox(
          height: 20,
        ),
        VideoKesehatan()
      ],
    );
  }
}

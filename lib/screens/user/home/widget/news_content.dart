import 'package:antrean_app/constraints/colors.dart';
import 'package:antrean_app/dto/berita_kesehatan/berita_kesehatan.dart';
import 'package:antrean_app/provider/berita_kesehatan/berita_kesehatan_provider.dart';
import 'package:antrean_app/screens/user/menu_informasi_kesehatan/more_menu_informasi_kesehatan/news_information/detail_news_information/news_detail_information.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewsContent extends StatefulWidget {
  const NewsContent({super.key});

  @override
  State<NewsContent> createState() => _NewsContentState();
}

class _NewsContentState extends State<NewsContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<BeritaKesehatanProvider>();
      if (!provider.loading && provider.items.isEmpty) {
        provider.fetch();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BeritaKesehatanProvider>();
    final bool isLoading = provider.loading && provider.items.isEmpty;
    final Data? latestNews =
        provider.items.isNotEmpty ? provider.items.first : null;

    final String? rawTitle = latestNews?.judul;
    final String title = rawTitle != null && rawTitle.trim().isNotEmpty
        ? rawTitle
        : isLoading
            ? 'Memuat berita...'
            : 'Judul Berita';

    final String? rawDescription = latestNews?.deskripsi;
    final String description = rawDescription != null &&
            rawDescription.trim().isNotEmpty
        ? rawDescription
        : provider.error != null && latestNews == null
            ? 'Gagal memuat berita kesehatan.'
            : isLoading
                ? 'Sedang mengambil berita kesehatan terkini.'
                : 'Lorem ipsum dolor sit amet. Ad quas earum est magnam repellendus eum quod...';

    final String dateText = latestNews != null
        ? DateFormat('d MMMM yyyy', 'id_ID')
            .format(latestNews.tanggalPenerbitan)
        : '25 Juli 2025';

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
                          _NewsThumbnail(
                            imageUrl: latestNews?.fotoUrl,
                            isLoading: isLoading,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textDefaultColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  description,
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
                                      dateText,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.hintColor,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: latestNews == null
                                          ? null
                                          : () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      NewsDetailInformation(
                                                    newsId: latestNews.idBerita,
                                                  ),
                                                ),
                                              );
                                            },
                                      child: const Icon(
                                        Icons.arrow_forward,
                                        size: 16,
                                      ),
                                    ),
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

class _NewsThumbnail extends StatelessWidget {
  const _NewsThumbnail({
    required this.imageUrl,
    required this.isLoading,
  });

  final String? imageUrl;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading || imageUrl == null || imageUrl!.isEmpty) {
      return Image.asset(
        "assets/images/news_content.jpg",
        width: 120,
        height: 120,
        fit: BoxFit.cover,
      );
    }

    return SizedBox(
      width: 120,
      height: 120,
      child: FadeInImage.assetNetwork(
        placeholder: "assets/images/news_content.jpg",
        image: imageUrl!,
        fit: BoxFit.cover,
        imageErrorBuilder: (context, error, stackTrace) {
          return Image.asset(
            "assets/images/news_content.jpg",
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}

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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 5,
        color: AppColors.accentColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              child: Card(
                elevation: 2,
                color: AppColors.accentColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
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
                                // Judul: batasi 2 baris agar tidak meluber
                                Text(
                                  title,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textDefaultColor,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                                const SizedBox(height: 12),
                                // Deskripsi: batasi 3 baris
                                Text(
                                  description,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textDefaultColor,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 16),
                                // ROW yang sebelumnya overflow → bungkus tanggal dengan Expanded
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        dateText,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.hintColor,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                      ),
                                    ),
                                    InkWell(
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
                                      child: const Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child:
                                            Icon(Icons.arrow_forward, size: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
            const SizedBox(height: 20),
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
    // Ukuran tetap agar perhitungan Row stabil
    const double size = 120;

    if (isLoading || imageUrl == null || imageUrl!.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          "assets/images/news_content.jpg",
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
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
      ),
    );
  }
}

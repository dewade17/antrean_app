import 'package:antrean_app/constraints/colors.dart';
import 'package:antrean_app/dto/video_kesehatan/video_kesehatan.dart';
import 'package:antrean_app/provider/video_kesehatan/video_kesehatan_provider.dart';
import 'package:antrean_app/screens/user/menu_informasi_kesehatan/more_menu_informasi_kesehatan/news_information/detail_news_information/video_detail_information.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class VideoContent extends StatefulWidget {
  const VideoContent({super.key});

  @override
  State<VideoContent> createState() => _VideoContentState();
}

class _VideoContentState extends State<VideoContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<VideoKesehatanProvider>();
      if (!provider.loading && provider.videos.isEmpty) {
        provider.fetchVideos(resetResultsOnError: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VideoKesehatanProvider>();
    final bool isLoading = provider.loading && provider.videos.isEmpty;
    final Data? latestVideo =
        provider.videos.isNotEmpty ? provider.videos.first : null;

    final String title = _resolveTitle(latestVideo, provider, isLoading);
    final String subtitle = _resolveSubtitle(latestVideo, provider, isLoading);

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
                "Video Kesehatan",
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
                child: InkWell(
                  onTap: latestVideo == null
                      ? null
                      : () => _openVideoDetail(latestVideo),
                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/images/Video_Content.png",
                          width: 500,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            title,
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDefaultColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            subtitle,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textDefaultColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
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
                child: GestureDetector(
                  onTap: latestVideo == null
                      ? null
                      : () => _openVideoDetail(latestVideo),
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
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  String _resolveTitle(
    Data? latestVideo,
    VideoKesehatanProvider provider,
    bool isLoading,
  ) {
    final String? raw = latestVideo?.judul;
    if (raw != null && raw.trim().isNotEmpty) {
      return raw.trim();
    }
    if (isLoading) {
      return 'Memuat video kesehatan...';
    }
    if (provider.error != null) {
      return 'Video Kesehatan';
    }
    return 'Judul Video Kesehatan';
  }

  String _resolveSubtitle(
    Data? latestVideo,
    VideoKesehatanProvider provider,
    bool isLoading,
  ) {
    if (latestVideo != null) {
      final publishedDate = DateFormat('d MMMM yyyy', 'id_ID')
          .format(latestVideo.tanggalPenerbitan);
      final relative = _formatRelative(latestVideo.tanggalPenerbitan);
      return 'Dipublikasikan $publishedDate - $relative';
    }
    if (isLoading) {
      return 'Sedang mengambil video kesehatan terkini.';
    }
    if (provider.error != null) {
      return 'Gagal memuat video kesehatan.';
    }
    return '1,4 juta penonton - 2 hari lalu';
  }

  String _formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays >= 365) {
      final years = (difference.inDays / 365).floor();
      return years == 1 ? '1 tahun lalu' : '$years tahun lalu';
    }
    if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? '1 bulan lalu' : '$months bulan lalu';
    }
    if (difference.inDays >= 7) {
      final weeks = (difference.inDays / 7).floor();
      return weeks == 1 ? '1 minggu lalu' : '$weeks minggu lalu';
    }
    if (difference.inDays >= 1) {
      return difference.inDays == 1
          ? '1 hari lalu'
          : '${difference.inDays} hari lalu';
    }
    if (difference.inHours >= 1) {
      return difference.inHours == 1
          ? '1 jam lalu'
          : '${difference.inHours} jam lalu';
    }
    if (difference.inMinutes >= 1) {
      return difference.inMinutes == 1
          ? '1 menit lalu'
          : '${difference.inMinutes} menit lalu';
    }
    return 'Baru saja';
  }

  void _openVideoDetail(Data video) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoDetailInformation(video: video),
      ),
    );
  }
}

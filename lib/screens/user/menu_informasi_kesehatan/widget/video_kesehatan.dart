import 'package:antrean_app/constraints/colors.dart';
import 'package:antrean_app/dto/video_kesehatan/video_kesehatan.dart';
import 'package:antrean_app/provider/video_kesehatan/video_kesehatan_provider.dart';
import 'package:antrean_app/screens/user/menu_informasi_kesehatan/more_menu_informasi_kesehatan/news_information/detail_news_information/video_detail_information.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class VideoKesehatan extends StatefulWidget {
  const VideoKesehatan({super.key});

  @override
  State<VideoKesehatan> createState() => _VideoKesehatanState();
}

class _VideoKesehatanState extends State<VideoKesehatan> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<VideoKesehatanProvider>()
          .fetchVideos(resetResultsOnError: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VideoKesehatanProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Card(
        elevation: 5,
        color: AppColors.accentColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // 1) Biar judul bisa mengecil/ellipsis saat space mepet
                    Expanded(
                      child: Text(
                        'Video Kesehatan',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDefaultColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // 2) Aksi kanan dibuat kompak & tidak memaksa lebar
                    Wrap(
                      spacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        IconButton(
                          tooltip: 'Muat ulang',
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                          constraints:
                              const BoxConstraints(minWidth: 36, minHeight: 36),
                          icon: provider.loading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.refresh),
                          onPressed: provider.loading
                              ? null
                              : () => provider.fetchVideos(
                                  resetResultsOnError: true),
                        ),
                        PopupMenuButton<String>(
                          tooltip: 'Urutkan',
                          initialValue: provider.sort,
                          onSelected: provider.changeSort,
                          itemBuilder: (context) => const [
                            PopupMenuItem<String>(
                              enabled: false,
                              child: Text(
                                'Urutkan berdasarkan',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            PopupMenuItem<String>(
                                value: 'recent', child: Text('Terbaru')),
                            PopupMenuItem<String>(
                                value: 'oldest', child: Text('Terlama')),
                          ],
                          // 3) Child-nya jangan ambil lebar penuh
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.sort, size: 20),
                              const SizedBox(width: 6),
                              Text(
                                provider.sort == 'oldest'
                                    ? 'Terlama'
                                    : 'Terbaru',
                                style: GoogleFonts.poppins(
                                  color: AppColors.textDefaultColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _VideoContent(provider: provider),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VideoContent extends StatelessWidget {
  const _VideoContent({required this.provider});

  final VideoKesehatanProvider provider;

  @override
  Widget build(BuildContext context) {
    if (provider.loading && provider.videos.isEmpty) {
      return const SizedBox(
        height: 160,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.error != null && provider.videos.isEmpty) {
      return _ErrorState(
        message: provider.error ?? 'Gagal memuat video kesehatan.',
        onRetry: () => provider.fetchVideos(resetResultsOnError: true),
      );
    }

    if (provider.videos.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text('Belum ada video kesehatan yang tersedia.'),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...provider.videos
            .map(
              (video) => _VideoItem(
                video: video,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          VideoDetailInformation(video: video),
                    ),
                  );
                },
              ),
            )
            .toList(),
        const SizedBox(height: 12),
        if (provider.totalPages > 1)
          _Pagination(
            currentPage: provider.currentPage,
            totalPages: provider.totalPages,
            onNext: provider.canGoNext ? provider.nextPage : null,
            onPrevious: provider.canGoPrevious ? provider.previousPage : null,
          ),
        if (provider.error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              provider.error!,
              style: const TextStyle(color: AppColors.errorColor),
            ),
          ),
      ],
    );
  }
}

class _VideoItem extends StatelessWidget {
  const _VideoItem({required this.video, required this.onTap});

  final Data video;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dateText =
        DateFormat('d MMMM yyyy', 'id_ID').format(video.tanggalPenerbitan);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.backgroundColor.withOpacity(0.35),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    color: AppColors.secondaryColor.withOpacity(0.2),
                    child: const Center(
                      child: Icon(
                        Icons.play_circle_fill,
                        size: 64,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  video.judul,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDefaultColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  dateText,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.hintColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  video.deskripsiPlain.isEmpty ? '-' : video.deskripsiPlain,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textDefaultColor,
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Selengkapnya',
                        style: TextStyle(
                          color: AppColors.secondaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios,
                          size: 14, color: AppColors.secondaryColor),
                    ],
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

class _Pagination extends StatelessWidget {
  const _Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.onPrevious,
    required this.onNext,
  });

  final int currentPage;
  final int totalPages;
  final Future<void> Function()? onPrevious;
  final Future<void> Function()? onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPrevious == null ? null : () => onPrevious?.call(),
          icon: const Icon(Icons.arrow_back_ios, size: 16),
        ),
        Text(
          'Halaman $currentPage dari $totalPages',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColors.textDefaultColor,
          ),
        ),
        IconButton(
          onPressed: onNext == null ? null : () => onNext?.call(),
          icon: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            message,
            style: const TextStyle(color: AppColors.errorColor),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Coba lagi'),
          ),
        ),
      ],
    );
  }
}

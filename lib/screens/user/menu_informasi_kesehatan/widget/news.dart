import 'package:antrean_app/constraints/colors.dart';
import 'package:antrean_app/dto/berita_kesehatan/berita_kesehatan.dart';
import 'package:antrean_app/provider/berita_kesehatan/berita_kesehatan_provider.dart';
import 'package:antrean_app/screens/user/menu_informasi_kesehatan/more_menu_informasi_kesehatan/news_information/detail_news_information/news_detail_information.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BeritaKesehatanProvider>().fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BeritaKesehatanProvider>();
    final List<Data> items = provider.items;
    final int currentPage = provider.page;
    final int totalPages = provider.meta?.pages ?? 1;
    final List<int> pageNumbers = _visiblePageNumbers(currentPage, totalPages);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Card(
        elevation: 5,
        color: AppColors.accentColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Berita Kesehatan",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDefaultColor,
                    ),
                  ),
                  PopupMenuButton<String>(
                    tooltip: 'Urutkan',
                    initialValue: provider.sort,
                    onSelected: (value) {
                      if (value != provider.sort) {
                        provider.fetch(sort: value, page: 1);
                      }
                    },
                    icon: provider.loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.more_horiz),
                    itemBuilder: (BuildContext context) => const [
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
                        value: 'recent',
                        child: Text('Terbaru'),
                      ),
                      PopupMenuItem<String>(
                        value: 'oldest',
                        child: Text('Terlama'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              child: Column(
                children: [
                  if (provider.loading && items.isEmpty)
                    const SizedBox(
                      height: 160,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (provider.error != null && items.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Column(
                        children: [
                          Text(
                            provider.error ?? 'Gagal memuat berita kesehatan.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.errorColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: provider.loading
                                ? null
                                : () => provider.fetch(page: 1),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba lagi'),
                          ),
                        ],
                      ),
                    )
                  else if (items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child:
                            Text('Belum ada berita kesehatan yang tersedia.'),
                      ),
                    )
                  else
                    ...items.map(
                      (news) => _NewsCard(
                        news: news,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NewsDetailInformation(newsId: news.idBerita),
                            ),
                          );
                        },
                      ),
                    ),
                  if (provider.error != null && items.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        provider.error!,
                        style: const TextStyle(color: AppColors.errorColor),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 16),
                      onPressed: provider.loading || currentPage <= 1
                          ? null
                          : () => provider.fetch(page: currentPage - 1),
                    ),
                    ...pageNumbers.map(
                      (page) => TextButton(
                        onPressed: provider.loading || page == currentPage
                            ? null
                            : () => provider.fetch(page: page),
                        child: Text(
                          '$page',
                          style: TextStyle(
                            color: AppColors.textDefaultColor,
                            fontWeight: page == currentPage
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 16),
                      onPressed: provider.loading || currentPage >= totalPages
                          ? null
                          : () => provider.fetch(page: currentPage + 1),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  List<int> _visiblePageNumbers(int currentPage, int totalPages) {
    if (totalPages <= 0) return const <int>[1];
    final int start = currentPage - 1 < 1 ? 1 : currentPage - 1;
    int end = start + 2;
    if (end > totalPages) {
      end = totalPages;
    }
    final int adjustedStart = (end - 2) < 1 ? 1 : end - 2;
    return [
      for (int page = adjustedStart; page <= end; page++) page,
    ];
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({required this.news, required this.onTap});

  final Data news;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
        DateFormat('d MMMM yyyy', 'id_ID').format(news.tanggalPenerbitan);

    return Card(
      elevation: 2,
      color: AppColors.accentColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔧 gambar kini fleksibel (bisa mengecil sedikit bila perlu)
            Flexible(
              flex: 0,
              child: _NewsImage(url: news.fotoUrl, maxSide: 120),
            ),
            const SizedBox(width: 10),

            // 🔧 konten teks tetap mengambil sisa lebar
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul: boleh 2 baris agar lebih aman
                  Text(
                    news.judul,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDefaultColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    news.deskripsi,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textDefaultColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // 🔧 tanggal bisa memendek agar ikon tidak mendorong keluar
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          formattedDate,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.hintColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: onTap,
                        child: const Icon(Icons.arrow_forward, size: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewsImage extends StatelessWidget {
  const _NewsImage({required this.url, this.maxSide = 120});

  final String url;
  final double maxSide;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxSide, maxHeight: maxSide),
      child: AspectRatio(
        aspectRatio: 1, // selalu kotak
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/images/news_content.jpg',
            image: url,
            fit: BoxFit.cover,
            imageErrorBuilder: (context, error, stackTrace) {
              return Image.asset('assets/images/news_content.jpg',
                  fit: BoxFit.cover);
            },
          ),
        ),
      ),
    );
  }
}

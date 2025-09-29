import 'package:antrean_app/constraints/colors.dart';
import 'package:antrean_app/dto/berita_kesehatan/berita_kesehatan.dart';
import 'package:antrean_app/provider/berita_kesehatan/berita_kesehatan_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewsDetailInformation extends StatefulWidget {
  const NewsDetailInformation({super.key, required this.newsId});

  final String newsId;

  @override
  State<NewsDetailInformation> createState() => _NewsDetailInformationState();
}

class _NewsDetailInformationState extends State<NewsDetailInformation> {
  bool _hasRequestedFetch = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = context.read<BeritaKesehatanProvider>();
    final Data? news = provider.findById(widget.newsId);
    if (news == null && !_hasRequestedFetch && !provider.loading) {
      _hasRequestedFetch = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.fetch(
          q: provider.query,
          from: provider.from,
          to: provider.to,
          sort: provider.sort,
          page: provider.page,
          pageSize: provider.pageSize,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BeritaKesehatanProvider>();
    final Data? news = provider.findById(widget.newsId);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Berita Kesehatan"),
        actions: [
          IconButton(
            icon: const Icon(Icons.switch_access_shortcut),
            onPressed: () {
              // aksi ketika icon ditekan
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.accentColor,
                AppColors.backgroundColor,
              ],
            ),
          ),
          child: news == null
              ? _EmptyNewsState(
                  isLoading: provider.loading,
                  error: provider.error,
                )
              : _NewsDetailContent(news: news),
        ),
      ),
    );
  }
}

class _NewsDetailContent extends StatelessWidget {
  const _NewsDetailContent({required this.news});

  final Data news;

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
        DateFormat('d MMMM yyyy', 'id_ID').format(news.tanggalPenerbitan);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _NewsDetailImage(imageUrl: news.fotoUrl),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Text(
            news.judul,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textDefaultColor,
              wordSpacing: 3,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Text(
            formattedDate,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.hintColor,
              wordSpacing: 3,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Text(
            news.deskripsi,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: AppColors.textDefaultColor,
              wordSpacing: 3,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }
}

class _NewsDetailImage extends StatelessWidget {
  const _NewsDetailImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return FadeInImage.assetNetwork(
      placeholder: 'assets/images/news_content.jpg',
      image: imageUrl,
      fit: BoxFit.cover,
      imageErrorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/news_content.jpg',
          fit: BoxFit.cover,
        );
      },
    );
  }
}

class _EmptyNewsState extends StatelessWidget {
  const _EmptyNewsState({required this.isLoading, required this.error});

  final bool isLoading;
  final String? error;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 240,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (error != null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              error!,
              style: const TextStyle(color: AppColors.errorColor),
            ),
            const SizedBox(height: 12),
            Text(
              'Berita tidak ditemukan.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textDefaultColor,
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox(
      height: 240,
      child: Center(
        child: Text('Berita tidak ditemukan.'),
      ),
    );
  }
}

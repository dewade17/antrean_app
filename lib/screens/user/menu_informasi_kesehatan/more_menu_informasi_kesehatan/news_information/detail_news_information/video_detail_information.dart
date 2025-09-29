import 'package:antrean_app/constraints/colors.dart';
import 'package:antrean_app/dto/video_kesehatan/video_kesehatan.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

class VideoDetailInformation extends StatefulWidget {
  const VideoDetailInformation({super.key, required this.video});

  final Data video;

  @override
  State<VideoDetailInformation> createState() => _VideoDetailInformationState();
}

class _VideoDetailInformationState extends State<VideoDetailInformation> {
  VideoPlayerController? _controller;
  bool _isInitializing = false;
  String? _videoError;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initializeController() async {
    final url = widget.video.videoUrl.trim();
    if (url.isEmpty) {
      setState(() {
        _videoError = 'Video belum tersedia.';
      });
      return;
    }

    Uri? uri;
    try {
      uri = Uri.parse(url);
      if (!uri.hasScheme) {
        throw const FormatException('invalid scheme');
      }
    } catch (_) {
      setState(() {
        _videoError = 'URL video tidak valid.';
      });
      return;
    }

    setState(() {
      _isInitializing = true;
      _videoError = null;
    });

    final controller = VideoPlayerController.networkUrl(uri);
    try {
      await controller.initialize();
      controller.setLooping(false);
      controller.addListener(() {
        if (!mounted) return;
        setState(() {});
      });
      if (!mounted) {
        controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _isInitializing = false;
      });
    } catch (_) {
      controller.dispose();
      if (!mounted) return;
      setState(() {
        _videoError = 'Gagal memuat video.';
        _isInitializing = false;
      });
    }
  }

  void _togglePlay() {
    final controller = _controller;
    if (controller == null) return;
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
    setState(() {});
  }

  Widget _buildVideoPlayer() {
    if (_videoError != null) {
      return _VideoPlaceholder(
        child: Text(
          _videoError!,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(color: AppColors.errorColor),
        ),
      );
    }

    if (_isInitializing) {
      return const _VideoPlaceholder(
        child: CircularProgressIndicator(),
      );
    }

    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const _VideoPlaceholder(
        child: Icon(
          Icons.play_circle_fill,
          size: 64,
          color: AppColors.secondaryColor,
        ),
      );
    }

    final aspectRatio = controller.value.aspectRatio == 0
        ? (16 / 9)
        : controller.value.aspectRatio;
    final isPlaying = controller.value.isPlaying;
    final isBuffering = controller.value.isBuffering;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: _togglePlay,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: aspectRatio,
                child: VideoPlayer(controller),
              ),
              if (isBuffering)
                const Positioned.fill(
                  child: ColoredBox(
                    color: Colors.black45,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              else if (!isPlaying)
                const Icon(
                  Icons.play_circle_fill,
                  size: 80,
                  color: Colors.white,
                ),
            ],
          ),
        ),
        VideoProgressIndicator(
          controller,
          allowScrubbing: true,
          colors: VideoProgressColors(
            playedColor: AppColors.secondaryColor,
            bufferedColor: AppColors.backgroundColor,
            backgroundColor: AppColors.hintColor.withOpacity(0.3),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isPlaying ? 'Sedang diputar' : 'Jeda',
              style: GoogleFonts.poppins(fontSize: 12),
            ),
            IconButton(
              onPressed: _togglePlay,
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              tooltip: isPlaying ? 'Jeda' : 'Putar',
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('d MMMM yyyy', 'id_ID')
        .format(widget.video.tanggalPenerbitan);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.video.judul),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildVideoPlayer(),
                const SizedBox(height: 20),
                Text(
                  widget.video.judul,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDefaultColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  formattedDate,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.hintColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.video.deskripsi,
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textDefaultColor,
                    wordSpacing: 2,
                    height: 1.5,
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

class _VideoPlaceholder extends StatelessWidget {
  const _VideoPlaceholder({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.secondaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(child: child),
      ),
    );
  }
}

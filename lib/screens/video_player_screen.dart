import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // kIsWeb के लिए
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:ui_web' as ui; // लेटेस्ट वेब सपोर्ट के लिए
import 'package:universal_html/html.dart' as html; 

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;

  const VideoPlayerScreen({super.key, required this.videoUrl, required this.title});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      // --- वेब के लिए IFRAME लॉजिक ---
      final String viewID = 'bunny-video-${widget.videoUrl.hashCode}';
      
      // Iframe का लिंक तैयार करें
      String embedUrl = widget.videoUrl;
      if (embedUrl.contains('.b-cdn.net')) {
         embedUrl = embedUrl.replaceAll('.b-cdn.net', '.mediadelivery.net/embed').replaceAll('/playlist.m3u8', '');
      }
      
      // रजिस्टर व्यू फैक्ट्री
      ui.platformViewRegistry.registerViewFactory(
        viewID,
        (int viewId) {
          final element = html.IFrameElement()
            ..src = embedUrl
            ..style.border = 'none'
            ..allowFullscreen = true
            ..setAttribute("allow", "autoplay; fullscreen");
          return element;
        },
      );
    } else {
      _initMobilePlayer();
    }
  }

  void _initMobilePlayer() async {
    _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    try {
      await _videoController.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: true,
        aspectRatio: 16 / 9,
        allowPlaybackSpeedChanging: true,
      );
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint("Player Error: $e");
    }
  }

  @override
  void dispose() {
    if (!kIsWeb) {
      _videoController.dispose();
      _chewieController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: kIsWeb 
          ? HtmlElementView(viewType: 'bunny-video-${widget.videoUrl.hashCode}') 
          : (_isInitialized 
              ? Chewie(controller: _chewieController!) 
              : const CircularProgressIndicator(color: Colors.orange)),
      ),
    );
  }
}
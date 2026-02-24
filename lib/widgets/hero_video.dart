import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HeroVideo extends StatefulWidget {
  const HeroVideo({super.key});

  @override
  State<HeroVideo> createState() => _HeroVideoState();
}

class _HeroVideoState extends State<HeroVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    debugPrint("🎥 Loading video asset...");

    _controller = VideoPlayerController.asset("assets/videos/hero.mp4")
      ..initialize().then((_) {
        debugPrint("✅ Video loaded successfully!");
        setState(() {});
        _controller
          ..setLooping(true)
          ..setVolume(0)
          ..play();
      }).catchError((e) {
        debugPrint("❌ VIDEO ERROR: $e");
      });
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container(
        height: 320,
        color: Colors.black,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      height: 320,
      width: double.infinity,
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _controller.value.size.width,
          height: _controller.value.size.height,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}

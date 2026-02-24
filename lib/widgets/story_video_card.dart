import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class StoryVideoCard extends StatefulWidget {
  final String videoUrl;
  final String stallName;
  final String vendorName;
  final String storyId;

  const StoryVideoCard({
    super.key,
    required this.storyId,
    required this.videoUrl,
    required this.stallName,
    required this.vendorName,
  });

  @override
  State<StoryVideoCard> createState() => _StoryVideoCardState();
}

class _StoryVideoCardState extends State<StoryVideoCard> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      })
      ..setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 180, // ✅ HALF HEIGHT
      child: Row(
        children: [
          // 🎥 VIDEO — 25% WIDTH
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _controller.value.isInitialized
                  ? MouseRegion(
                onEnter: (_) => _controller.play(),
                onExit: (_) => _controller.pause(),
                child: GestureDetector(
                  onTap: () {
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                  },
                  child: VideoPlayer(_controller),
                ),
              )
                  : Container(color: Colors.black12),
            ),
          ),

          const SizedBox(width: 12),

          // 🧊 GLASS INFO PANEL — REST
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
    color: isDark
    ? Colors.black.withOpacity(0.6)
        : Colors.white.withOpacity(0.6),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
    color: isDark
    ? Colors.white.withOpacity(0.2)
        : Colors.black.withOpacity(0.2),
    ),
    ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.stallName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("Vendor: ${widget.vendorName}"),
                      const Text("Since: 2019"),
                      const Spacer(),

    Row(
    children: [
      IconButton(
        icon: const Icon(Icons.favorite_border),
        onPressed: () async {
          await FirebaseFirestore.instance
              .collection("vendor_stories")
              .doc(widget.storyId)
              .update({
            "likes": FieldValue.increment(1),
          });
        },
      ),
    const Text("0"),
    const SizedBox(width: 16),
    IconButton(
    icon: const Icon(Icons.comment),
    onPressed: () {
        _openCommentDialog(context);
    },
    ),
    const Text("0"),
    ],
    ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _openCommentDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Add Comment"),
          content: TextField(controller: controller),
          actions: [
            TextButton(
              onPressed: () async {
                if (controller.text.trim().isEmpty) return;

                await FirebaseFirestore.instance.collection("story_comments").add({
                  "storyId": widget.storyId,
                  "userId": FirebaseAuth.instance.currentUser!.uid,
                  "text": controller.text.trim(),
                  "timestamp": FieldValue.serverTimestamp(),
                });

                await FirebaseFirestore.instance
                    .collection("vendor_stories")
                    .doc(widget.storyId)
                    .update({
                  "commentsCount": FieldValue.increment(1),
                });

                // ✅ SAFE CLOSE DIALOG
                if (Navigator.canPop(context)) {
                  Navigator.of(context, rootNavigator: true).pop();
                }
              },
              child: const Text("Post"),
            )
          ],
        );
      },
    );
  }
}

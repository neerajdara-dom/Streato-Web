import 'package:flutter/material.dart';
import 'dart:ui';

class SocialFeedPage extends StatefulWidget {
  const SocialFeedPage({super.key});

  @override
  State<SocialFeedPage> createState() => _SocialFeedPageState();
}

class _SocialFeedPageState extends State<SocialFeedPage> {
  bool showVideos = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        const SizedBox(height: 20),

        /// 🔥 POSTS | VIDEOS TOGGLE
        Center(
          child: Container(
            width: 320,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.black.withOpacity(0.05),
            ),
            child: Row(
              children: [
                _toggleButton("Photos", !showVideos),
                _toggleButton("Videos", showVideos),
              ],
            ),
          ),
        ),

        const SizedBox(height: 30),

        /// 🔥 GRID
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: GridView.builder(
              itemCount: 12,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 1.3,
              ),
              itemBuilder: (context, index) {
                return SocialPostCard(
                  image: showVideos
                      ? "https://images.unsplash.com/photo-1555939594-58d7cb561ad1"
                      : "https://images.unsplash.com/photo-1600891964599-f61ba0e24092",
                  isVideo: showVideos,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _toggleButton(String text, bool active) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            showVideos = text == "Videos";
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: active ? Colors.black : Colors.transparent,
          ),
          child: Text(
            text,
            style: TextStyle(
              color: active ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
class SocialPostCard extends StatefulWidget {
  final String image;
  final bool isVideo;

  const SocialPostCard({
    super.key,
    required this.image,
    required this.isVideo,
  });

  @override
  State<SocialPostCard> createState() => _SocialPostCardState();
}

class _SocialPostCardState extends State<SocialPostCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Stack(
        children: [

          /// IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              widget.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          /// VIDEO ICON
          if (widget.isVideo)
            const Positioned(
              top: 16,
              right: 16,
              child: Icon(Icons.play_circle, size: 36, color: Colors.white),
            ),

          /// HOVER GLASS OVERLAY
          if (isHovered)
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      /// ICON ROW
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          _IconText(icon: Icons.favorite_border, text: "2k"),
                          SizedBox(width: 30),
                          _IconText(icon: Icons.comment_outlined, text: "53"),
                          SizedBox(width: 30),
                          _IconText(icon: Icons.share_outlined, text: "100"),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// USER INFO
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircleAvatar(radius: 16),
                          SizedBox(width: 10),
                          Text(
                            "by Ramesh",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String text;

  const _IconText({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
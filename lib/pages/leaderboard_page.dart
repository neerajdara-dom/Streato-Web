import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .orderBy("streatoPoints", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final users = snapshot.data!.docs;

        if (users.isEmpty) {
          return const Center(child: Text("No leaderboard data"));
        }

        final top3 = users.take(3).toList();
        final others = users.skip(3).toList();

        return Stack(
          children: [

            /// 🌟 GOLDEN BACKGROUND GLOW
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.topCenter,
                      radius: 1.3,
                      colors: [
                        const Color(0xFFFFB300).withOpacity(0.15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  /// 🏆 TOP 3 PODIUM
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (top3.length > 1) _podium(top3[1], 2, 140),
                      if (top3.isNotEmpty) _podium(top3[0], 1, 190),
                      if (top3.length > 2) _podium(top3[2], 3, 120),
                    ],
                  ),

                  const SizedBox(height: 40),

                  /// 📋 OTHER RANKS
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: others.length,
                    itemBuilder: (context, index) {
                      final data =
                      others[index].data() as Map<String, dynamic>;

                      return _rankCard(
                        rank: index + 4,
                        name: data["name"] ?? "User",
                        points: data["streatoPoints"] ?? 0,
                      );
                    },
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  /// 🏆 PODIUM CARD
  Widget _podium(DocumentSnapshot doc, int rank, double height) {
    final data = doc.data() as Map<String, dynamic>;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [
          /// AVATAR
          CircleAvatar(
            radius: 36,
            backgroundColor: const Color(0xFFFFB300),
            child: Text(
              data["name"][0].toUpperCase(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            data["name"],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 10),

          /// PODIUM BLOCK
          Container(
            width: 110,
            height: height,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFB300), Color(0xFFFF8F00)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFB300).withOpacity(0.7),
                  blurRadius: 25,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: Text(
                "${data["streatoPoints"]}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          /// RANK BADGE
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "#$rank",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 📋 OTHER RANK CARD (Glass Style)
  Widget _rankCard({
    required int rank,
    required String name,
    required int points,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 80, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),

        /// GLASS BACKGROUND
        color: Colors.white.withOpacity(0.06),

        border: Border.all(
          color: Colors.white.withOpacity(0.12),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          _rankCircle(rank),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),

          Row(
            children: [
              Text(
                "$points",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.local_fire_department,
                color: Colors.orange,
                size: 18,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 🔥 GLOWING RANK CIRCLE
  Widget _rankCircle(int rank) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFFFFB300), Color(0xFFFF8F00)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFB300).withOpacity(0.6),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        "#$rank",
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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

            /// 🌙 Golden Glow ONLY in Dark Mode
            if (isDark)
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

                  /// 🏆 TOP 3
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (top3.length > 1)
                        _podium(context, top3[1], 2, 140),
                      if (top3.isNotEmpty)
                        _podium(context, top3[0], 1, 190),
                      if (top3.length > 2)
                        _podium(context, top3[2], 3, 120),
                    ],
                  ),

                  const SizedBox(height: 40),

                  /// 📋 Others
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: others.length,
                    itemBuilder: (context, index) {
                      final data =
                      others[index].data() as Map<String, dynamic>;

                      return _rankCard(
                        context: context,
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

  /// 🏆 PODIUM
  Widget _podium(
      BuildContext context, DocumentSnapshot doc, int rank, double height) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final data = doc.data() as Map<String, dynamic>;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [
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
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),

          const SizedBox(height: 10),

          Container(
            width: 110,
            height: height,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.06)
                  : const Color(0xFFFFB300),

              borderRadius: BorderRadius.circular(18),

              border: isDark
                  ? Border.all(color: Colors.white.withOpacity(0.15))
                  : null,

              boxShadow: isDark
                  ? [
                BoxShadow(
                  color:
                  const Color(0xFFFFB300).withOpacity(0.6),
                  blurRadius: 20,
                  spreadRadius: 1,
                ),
              ]
                  : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Center(
              child: Text(
                "${data["streatoPoints"]}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isDark ? Colors.black : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "#$rank",
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 📋 RANK CARD
  Widget _rankCard({
    required BuildContext context,
    required int rank,
    required String name,
    required int points,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 80, vertical: 8),
      padding:
      const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.06)
            : Colors.white,

        borderRadius: BorderRadius.circular(14),

        border: isDark
            ? Border.all(color: Colors.white.withOpacity(0.1))
            : Border.all(color: Colors.black.withOpacity(0.05)),

        boxShadow: isDark
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 18,
          ),
        ]
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
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
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),

          Row(
            children: [
              Text(
                "$points",
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
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

  /// 🔥 Rank Circle
  Widget _rankCircle(int rank) {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFFFB300), Color(0xFFFF8F00)],
        ),
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
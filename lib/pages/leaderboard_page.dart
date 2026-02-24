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

        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// 🏆 TOP 3 PODIUM
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (top3.length > 1) _podium(top3[1], 2, 140),
                  if (top3.isNotEmpty) _podium(top3[0], 1, 180),
                  if (top3.length > 2) _podium(top3[2], 3, 120),
                ],
              ),

              const SizedBox(height: 30),

              /// 📋 OTHERS LIST
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
            ],
          ),
        );
      },
    );
  }

  /// 🏆 PODIUM CARD
  Widget _podium(DocumentSnapshot doc, int rank, double height) {
    final data = doc.data() as Map<String, dynamic>;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: const Color(0xFFFFB300),
            child: Text(
              data["name"][0].toUpperCase(),
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data["name"],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),

          /// PODIUM BLOCK
          Container(
            width: 100,
            height: height,
            decoration: BoxDecoration(
              color: const Color(0xFFFFB300),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                )
              ],
            ),
            child: Center(
              child: Text(
                "${data["streatoPoints"]}",
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 8),

          /// RANK BADGE
          CircleAvatar(
            radius: 14,
            backgroundColor: Colors.black,
            child: Text(
              "#$rank",
              style: const TextStyle(
                  color: Colors.white, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  /// 📋 RANK CARD
  Widget _rankCard({
    required int rank,
    required String name,
    required int points,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFFFB300),
            child: Text("#$rank"),
          ),
          const SizedBox(width: 14),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          Text("$points 🔥"),
        ],
      ),
    );
  }
}
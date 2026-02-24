import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/story_video_card.dart';

class VendorStoriesPage extends StatelessWidget {
  const VendorStoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("vendor_stories").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();

            final docs = snapshot.data!.docs;

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, i) {
                final data = docs[i];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: StoryVideoCard(
                    storyId: docs[i].id,   // 🔥 ADD THIS
                    videoUrl: data["videoUrl"],
                    stallName: data["stallName"],
                    vendorName: data["vendorName"],
                  ),
                );

              },
            );
          },
        ),
      ),
    );
  }
}

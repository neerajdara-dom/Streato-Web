import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChroniclesBar extends StatelessWidget {
  const ChroniclesBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// TITLE
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 10),
          child: Text(
            "Chronicles",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
        ),

        /// STORIES
        SizedBox(
          height: 95,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("chronicles")
                .orderBy("createdAt", descending: true)
                .limit(7)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              }

              final docs = snapshot.data!.docs;

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;

                  return Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFFFB300),
                                Color(0xFFFF8F00),
                              ],
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 32,
                            backgroundImage: NetworkImage(
                              data["userPhoto"] ?? "",
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          data["userName"] ?? "User",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
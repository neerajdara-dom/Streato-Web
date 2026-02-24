import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StreatoPointsService {
  static Future<int> getPoints() async {
    final user = FirebaseAuth.instance.currentUser!;
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    return (doc.data()?["streatoPoints"] ?? 0);
  }

  static Future<void> addPoints(int points) async {
    final user = FirebaseAuth.instance.currentUser!;
    final ref = FirebaseFirestore.instance.collection("users").doc(user.uid);

    await ref.set({
      "email": user.email,
      "streatoPoints": FieldValue.increment(points),
    }, SetOptions(merge: true));
  }
}
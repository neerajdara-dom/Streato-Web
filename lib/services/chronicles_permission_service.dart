import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChroniclesPermissionService {
  static Future<bool> canUploadChronicle() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return false;

    final leaderboard = await FirebaseFirestore.instance
        .collection("users")
        .orderBy("streatoPoints", descending: true)
        .limit(3)
        .get();

    for (var doc in leaderboard.docs) {
      if (doc.id == uid) {
        return true;
      }
    }
    return false;
  }
}
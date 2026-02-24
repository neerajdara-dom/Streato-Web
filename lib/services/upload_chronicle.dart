import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChronicleUploader {
  static Future<void> upload({
    required String mediaUrl,
    required String userName,
    required String userPhoto,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection("chronicles").add({
      "userId": uid,
      "userName": userName,
      "userPhoto": userPhoto,
      "mediaUrl": mediaUrl,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }
}
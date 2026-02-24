import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vendor.dart';

class VendorService {
  static Future<List<Vendor>> getAllVendors() async {
    final snap = await FirebaseFirestore.instance.collection("vendors").get();

    return snap.docs.map((doc) {
      return Vendor.fromFirestore(doc.id, doc.data());
    }).toList();
  }

}

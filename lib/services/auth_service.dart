import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  // SIGN UP
  Future<User?> signUp(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Save user to Firestore
    await _db.collection("users").doc(cred.user!.uid).set({
      "email": email,
      "createdAt": FieldValue.serverTimestamp(),
      "points": 0,
    });

    return cred.user;
  }

  // LOGIN
  Future<User?> login(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  // LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }

  // STREAM AUTH STATE
  Stream<User?> authState() {
    return _auth.authStateChanges();
  }
}

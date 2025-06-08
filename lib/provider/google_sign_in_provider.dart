import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleSignInProvider with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;

  GoogleSignInAccount? get user => _user;

  Future<UserCredential?> googleLogin() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      _user = googleUser;
      notifyListeners(); // beri tahu UI kalau user berubah

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Login dengan Firebase menggunakan credential Google
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print('Google login error: $e');
      return null;
    }
  }

  Future<void> logout() async {
    await _googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
    _user = null;
    notifyListeners();
  }
}

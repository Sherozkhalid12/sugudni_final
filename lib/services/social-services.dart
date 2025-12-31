import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SocialServices{
  static final _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final _usersCollection=FirebaseFirestore.instance.collection('users');
 static Future<UserCredential?> signInWithGitHub() async {
    GithubAuthProvider githubProvider = GithubAuthProvider();
    return await FirebaseAuth.instance.signInWithProvider(githubProvider);
  }

  static Future<UserCredential?> signInWithTwitter() async {
    TwitterAuthProvider twitterProvider = TwitterAuthProvider();
    return await FirebaseAuth.instance.signInWithProvider(twitterProvider);
  }

  static Future<User?> signInWithGoogle() async {

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      customPrint("Credential=========================$credential");
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      customPrint(e.toString());
      return null;
    }
  }
  static Future<void> signOutUser() async {
    await _googleSignIn.signOut();
}
}
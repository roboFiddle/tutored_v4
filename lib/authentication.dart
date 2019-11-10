import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class Authentication {

  static final Authentication _authentication = new Authentication._internal();

  factory Authentication() {
    return _authentication;
  }
  Authentication._internal();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  SharedPreferences prefs;
  bool isLoggedIn = false;
  final isLoading = ValueNotifier(false);
  FirebaseUser currentUser;

  Future<Null> isSignedIn(BuildContext context) async {
    isLoading.value = true;
    prefs = await SharedPreferences.getInstance();
    isLoggedIn = await googleSignIn.isSignedIn();
    isLoading.value = false;
    if (isLoggedIn) {
      if (prefs.getInt('role') == null) {
        Navigator.of(context).pushReplacementNamed('/user');
      } else {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    }
  }

  Future<Null> signIn(BuildContext context) async {
    isLoading.value = true;
    prefs = await SharedPreferences.getInstance();
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn()
        .catchError((onError) {
      print('Error $onError');
    });
    if (googleSignInAccount != null) {

      GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;

      isLoggedIn = await googleSignIn.isSignedIn();
      if (user != null && isLoggedIn) {
        final QuerySnapshot result =
        await Firestore.instance.collection('users').where(
            'id', isEqualTo: user.uid).getDocuments();
        final List<DocumentSnapshot> documents = result.documents;
        if (documents.length == 0) {
          Firestore.instance
              .collection('users')
              .document(user.uid)
              .setData({
            'id': user.uid,
            'name': user.displayName,
            'email': user.email,
            'photoUrl': user.photoUrl,
          });
          await prefs.setString('id', user.uid);
          await prefs.setString('email', user.email);
          await prefs.setString('name', user.displayName);
          await prefs.setString('photoUrl', user.photoUrl);

          currentUser = user;
          isLoading.value = false;
          Navigator.of(context).pushReplacementNamed('/user');
        } else {
          await prefs.setString('id', documents[0]['id']);
          await prefs.setString('email', documents[0]['email']);
          await prefs.setString('name', documents[0]['name']);
          await prefs.setString('photoUrl', documents[0]['photoUrl']);
          await prefs.setString('aboutMe', documents[0]['aboutMe']);
          await prefs.setInt('grade', documents[0]['grade']);
          await prefs.setString('contact', documents[0]['contact']);
          await prefs.setString('englishState', documents[0]['englishState']);
          await prefs.setString('mathState', documents[0]['mathState']);
          await prefs.setString('historyState', documents[0]['historyState']);
          await prefs.setString('languageState', documents[0]['languageState']);
          await prefs.setString('scienceState', documents[0]['scienceState']);
          await prefs.setString('selectedLanguage', documents[0]['selectedLanguage']);
          await prefs.setBool("monday", documents[0]['monday']);
          await prefs.setBool("tuesday", documents[0]['tuesday']);
          await prefs.setBool("wednesday", documents[0]['wednesday']);
          await prefs.setBool("thursday", documents[0]['thursday']);
          await prefs.setBool("friday", documents[0]['friday']);
          await prefs.setBool("saturday", documents[0]['saturday']);
          await prefs.setBool("sunday", documents[0]['sunday']);
          if (documents[0]['role'] == null) {
            isLoading.value = false;
            Navigator.of(context).pushReplacementNamed('/user');
          } else {
            await prefs.setInt('role', documents[0]['role']);
            isLoading.value = false;
            Navigator.of(context).pushReplacementNamed('/dashboard');
          }
        }
      }
    }
    isLoading.value = false;
  }

  Future<Null> signOut(BuildContext context) async {
    isLoading.value = true;
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    isLoggedIn = false;
    isLoading.value = false;
    Navigator.of(context).pushReplacementNamed('/');
  }

  Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }
}

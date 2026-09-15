import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/session_service.dart';
import 'firestore_service.dart';

class AuthService {
  final FirestoreService _firestoreService = FirestoreService();
  final SessionService _sessionService = SessionService();

  void login(String email, password, var context) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      await _sessionService.skipBiometricOnce();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //  if (!mounted) return;
        showSnackBarMessage(context, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        // if (!mounted) return;
        showSnackBarMessage(context, 'Wrong password provided for that user.');
      } else {
        //  if (!mounted) return;
        showSnackBarMessage(context, e.message.toString());
      }
    }
  }

  signUp(var context, String name, email, password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      await _sessionService.skipBiometricOnce();
      if (user != null) {
        await _firestoreService.createUserProfile(
          user: user,
          name: name,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBarMessage(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showSnackBarMessage(
            context, 'The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  showSnackBarMessage(var context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  signOut() async {
    FirebaseAuth.instance.signOut();
    await SessionService().clear();
  }
}

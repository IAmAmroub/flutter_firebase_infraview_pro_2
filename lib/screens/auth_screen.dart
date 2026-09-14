import 'package:flutter/material.dart';
import 'package:flutter_firebase_infraview_pro_2/screens/sign-up.dart';
import 'package:flutter_firebase_infraview_pro_2/screens/sign_in.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Auth Page"),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                text: 'LogIn',
              ),
              Tab(
                text: 'Sign-Up',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Center(child: SignInScreen()),
            Center(child: SignUpScreen()),
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/firestore_service.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _keyForm = GlobalKey<FormState>();
  bool _isLogin = true;

  Future<void> login() async {
    final isValid = _keyForm.currentState!.validate();
    if (isValid) {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          if (!mounted) return;
          showSnackBarMessage('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          if (!mounted) return;
          showSnackBarMessage('Wrong password provided for that user.');
        } else {
          if (!mounted) return;
          showSnackBarMessage(e.message.toString());
        }
      }
    } else {
      showSnackBarMessage('Inputs not valid!');
    }
  }

  Future<void> signup() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final isValid = _keyForm.currentState!.validate();
    if (isValid) {
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final user = credential.user;

        if (user != null) {
          await _firestoreService.createUserProfile(
            user: user,
            name: name,
          );
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          showSnackBarMessage('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          showSnackBarMessage('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    } else {
      showSnackBarMessage('The account already exists for that email.');
    }
  }

  showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth Screen'),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Form(
          key: _keyForm,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const CircleAvatar(
                  radius: 60,
                  child: Icon(
                    Icons.person,
                    size: 80,
                  ),
                ),
                const SizedBox(height: 10),
                if (!_isLogin)
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      label: Text('Name'),
                      hintText: 'Enter your name.',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Name is required!";
                      } else {
                        return null;
                      }
                    },
                  ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Email'),
                    hintText: 'Enter your email.',
                  ),
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Email is required!";
                    } else if (!value.contains("@")) {
                      return "Enter a valid email!";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    label: Text('Password'),
                    hintText: 'Enter your password.',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Password is required!";
                    } else if (value.length < 8) {
                      return "Password must contains at least 8 characters!";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 10),
                if (!_isLogin)
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      label: Text('Confirm Password'),
                      hintText: 'Enter your password again.',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Confirm Password is required!";
                      } else if (_passwordController.text != value) {
                        return "Not equals to the password!";
                      } else {
                        return null;
                      }
                    },
                  ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLogin ? login : signup,
                    child:
                        _isLogin ? const Text('Login') : const Text('Signup'),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: !_isLogin
                      ? const Text('Don\'t have an account? SignUp')
                      : const Text('Already have an account? SignIn'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

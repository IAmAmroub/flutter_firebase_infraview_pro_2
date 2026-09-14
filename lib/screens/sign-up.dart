import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _keyForm = GlobalKey<FormState>();

  Future<void> signup() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _keyForm,
        child: ListView(
          children: [
            const SizedBox(height: 20),
            const Center(
              child: CircleAvatar(
                radius: 50,
                child: Icon(
                  Icons.person_add,
                  size: 80,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                label: Text('Name'),
                hintText: 'Enter your name.',
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                label: Text('Email'),
                hintText: 'Enter your email.',
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                label: Text('Password'),
                hintText: 'Enter your password.',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: signup,
              child: const Text('Sign-Up'),
            ),
          ],
        ),
      ),
    );
  }
}

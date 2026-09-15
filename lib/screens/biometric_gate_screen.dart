import 'package:flutter/material.dart';

import '../services/biometric_service.dart';
import 'home_screen.dart';

class BiometricGateScreen extends StatefulWidget {
  const BiometricGateScreen({super.key});

  @override
  State<BiometricGateScreen> createState() => _BiometricGateScreenState();
}

class _BiometricGateScreenState extends State<BiometricGateScreen> {
  final BiometricService _biometricService = BiometricService();

  bool _isChecking = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    setState(() {
      _isChecking = true;
      _errorMessage = null;
    });

    final authenticated = await _biometricService.authenticate();

    if (!mounted) return;

    if (authenticated) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );

      return;
    }

    setState(() {
      _isChecking = false;
      _errorMessage = 'Biometric authentication failed.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.fingerprint,
                  size: 90,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Unlock The App',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Use Face ID or fingerprint to continue.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                if (_isChecking) const CircularProgressIndicator(),
                if (_errorMessage != null) ...[
                  Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _authenticate,
                    icon: const Icon(Icons.fingerprint),
                    label: const Text('Try Again'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

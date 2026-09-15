import 'package:flutter/material.dart';

import '../services/session_service.dart';
import 'biometric_gate_screen.dart';
import 'home_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final SessionService _sessionService = SessionService();

  bool _isLoading = true;
  bool _skipBiometric = false;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final skip = await _sessionService.consumeSkipBiometricOnce();

    if (!mounted) return;

    setState(() {
      _skipBiometric = skip;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_skipBiometric) {
      return const HomeScreen();
    }

    return const BiometricGateScreen();
  }
}

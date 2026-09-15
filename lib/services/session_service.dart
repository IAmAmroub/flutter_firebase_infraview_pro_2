import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _skipBiometricOnceKey = 'skip_biometric_once';

  Future<void> skipBiometricOnce() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_skipBiometricOnceKey, true);
  }

  Future<bool> consumeSkipBiometricOnce() async {
    final prefs = await SharedPreferences.getInstance();

    final shouldSkip = prefs.getBool(_skipBiometricOnceKey) ?? false;

    if (shouldSkip) {
      await prefs.setBool(_skipBiometricOnceKey, false);
    }

    return shouldSkip;
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_skipBiometricOnceKey);
  }
}

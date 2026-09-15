import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isAvailable() async {
    final canCheckBiometrics = await _auth.canCheckBiometrics;
    final isSupported = await _auth.isDeviceSupported();

    print('canCheckBiometrics: $canCheckBiometrics');
    print('isDeviceSupported: $isSupported');

    final biometrics = await _auth.getAvailableBiometrics();
    print('availableBiometrics: $biometrics');

    return canCheckBiometrics && isSupported;
  }

  Future<bool> authenticate() async {
    try {
      final available = await isAvailable();

      if (!available) {
        print('Biometrics are not available.');
        return false;
      }

      final result = await _auth.authenticate(
        localizedReason: 'Authenticate to access the app',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      print('Authentication result: $result');

      return result;
    } on PlatformException catch (error) {
      print('PlatformException code: ${error.code}');
      print('PlatformException message: ${error.message}');
      print('PlatformException details: ${error.details}');

      return false;
    }
  }
}

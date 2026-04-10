import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _biometricsEnabledKey = 'biometrics_enabled';
  static const String _userTokenKey = 'stored_user_token';

  /// Check if the device has biometric hardware (like Fingerprint sensor)
  Future<bool> isBiometricAvailable() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
      return canAuthenticate;
    } on PlatformException catch (_) {
      return false;
    }
  }

  /// Check specifically for Fingerprint support
  Future<bool> hasFingerprintHardware() async {
    try {
      final List<BiometricType> availableBiometrics = await _auth.getAvailableBiometrics();
      return availableBiometrics.contains(BiometricType.fingerprint) || 
             availableBiometrics.contains(BiometricType.strong); // strong often includes fingerprint
    } on PlatformException catch (_) {
      return false;
    }
  }

  /// Request biometric authentication
  Future<bool> authenticate({required String reason}) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true, // Only show biometrics, no PIN/Pattern fallback automatically
        ),
      );
    } on PlatformException catch (_) {
      return false;
    }
  }

  /// Set biometrics status
  Future<void> setBiometricsEnabled(bool enabled) async {
    await _storage.write(key: _biometricsEnabledKey, value: enabled.toString());
  }

  /// Check if biometrics is enabled in app settings
  Future<bool> isBiometricsEnabled() async {
    final value = await _storage.read(key: _biometricsEnabledKey);
    return value == 'true';
  }

  /// Securely store the user's auth token
  Future<void> storeToken(String token) async {
    await _storage.write(key: _userTokenKey, value: token);
  }

  /// Retrieve the stored token after successful biometric auth
  Future<String?> getStoredToken() async {
    return await _storage.read(key: _userTokenKey);
  }

  /// Clear biometric data on logout
  Future<void> clearBiometricData() async {
    await _storage.delete(key: _biometricsEnabledKey);
    await _storage.delete(key: _userTokenKey);
  }
}

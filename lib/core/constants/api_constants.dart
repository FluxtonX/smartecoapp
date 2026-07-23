import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConstants {
  // =========================
  // DEVELOPMENT BASE URL
  // =========================
  static String get _debugBaseUrl {
    // Android Emulator
    if (!kIsWeb && Platform.isAndroid) {
      return 'http://192.168.1.16:3000/api/v1';
    }

    // iOS Simulator / Physical Device / Desktop
    return 'http://192.168.1.16:3000/api/v1';
  }

  // =========================
  // PRODUCTION BASE URL
  // =========================
  static const String _productionBaseUrl =
      'https://api.smarteco.rw/api/v1';

  // =========================
  // ACTIVE BASE URL
  // =========================
  static String get baseUrl => _productionBaseUrl;
  //static String get baseUrl => kReleaseMode ? _productionBaseUrl : _debugBaseUrl;

  // =========================
  // AUTH ENDPOINTS
  // =========================
  static const String sendOtp = '/auth/otp/send';
  static const String verifyOtp = '/auth/otp/verify';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String googleLogin = '/auth/google';

  // =========================
  // GOOGLE SIGN IN
  // =========================
  static const String googleServerClientId =
      '334193579863-9rrqapd4a2f1lg01ba1hehbte7jred6v.apps.googleusercontent.com';
}
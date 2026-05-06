import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConstants {

  static String get _debugBaseUrl {
    if (!kIsWeb && Platform.isAndroid) {

      return 'http://192.168.1.31:3000/api/v1';
    }
    return 'http://192.168.1.31:3000/api/v1';
    //return 'http://127.0.0.1:3000/api/v1';
  }
  // The actual production server IP
  static const String _productionBaseUrl = 'http://13.223.149.5/api/v1';

  static String get baseUrl => kReleaseMode ? _productionBaseUrl : _debugBaseUrl;
  // Auth Endpoints
  static const String sendOtp = '/auth/otp/send';
  static const String verifyOtp = '/auth/otp/verify';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String googleLogin = '/auth/google';
  
  // Google Sign In
  static const String googleServerClientId = '334193579863-9rrqapd4a2f1lg01ba1hehbte7jred6v.apps.googleusercontent.com'; // REPLACE THIS
}

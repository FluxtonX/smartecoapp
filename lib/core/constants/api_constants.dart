import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConstants {

  static String get _debugBaseUrl {
    if (!kIsWeb && Platform.isAndroid) {

      return 'http://192.168.1.10:3000/api/v1'; 
    }
    return 'http://127.0.0.1:3000/api/v1';
  }
  
  // The actual production server IP
  static const String _productionBaseUrl = 'http://13.223.149.5/api/v1';

  static String get baseUrl => kReleaseMode ? _productionBaseUrl : _debugBaseUrl;
  
  // Auth Endpoints
  static const String sendOtp = '/auth/otp/send';
  static const String verifyOtp = '/auth/otp/verify';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
}

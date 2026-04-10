import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../services/api_service.dart';
import '../core/constants/api_constants.dart';
import '../core/errors/app_exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  bool _isLoading = false;
  String? _error;
  UserModel? _user;

  bool get isLoading => _isLoading;
  String? get error => _error;
  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  // 1. Send OTP
  Future<bool> sendOtp(String phone, {bool isLogin = true}) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await _apiService.post(ApiConstants.sendOtp, {
        'phone': phone,
        'isLogin': isLogin,
      });
      
      _setLoading(false);
      return response['success'] == true;
    } catch (e) {
      _setLoading(false);
      _setError(e is AppException ? e.message : e.toString());
      return false;
    }
  }

  // 2. Verify OTP
  Future<bool> verifyOtp(String phone, String code, {String? referralCode, String? fcmToken}) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await _apiService.post(ApiConstants.verifyOtp, {
        'phone': phone,
        'otp': code,
        if (referralCode != null) 'referralCode': referralCode,
        if (fcmToken != null) 'fcmToken': fcmToken,
      });

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        final accessToken = data['accessToken'];
        final refreshToken = data['refreshToken'];
        
        await _apiService.saveTokens(accessToken, refreshToken);
        
        if (data['user'] != null) {
          _user = UserModel.fromJson(data['user']);
        }
        
        _setLoading(false);
        return true;
      } else {
        _setError('Invalid response from server');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setLoading(false);
      _setError(e is AppException ? e.message : e.toString());
      return false;
    }
  }

  // 3. Complete Profile
  Future<bool> completeProfile(String phone, String firstName, String email) async {
    _setLoading(true);
    _setError(null);
    try {
      // The user is already authenticated at this point after verifyOtp
      final response = await _apiService.patch('/users/me', {
        'firstName': firstName,
        'email': email,
      });

      if (response['success'] == true && response['data'] != null) {
        _user = UserModel.fromJson(response['data']);
        _setLoading(false);
        return true;
      } else {
        _setError('Failed to update profile');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setLoading(false);
      _setError(e is AppException ? e.message : e.toString());
      return false;
    }
  }

  // 3. Logout
  Future<void> logout() async {
    _setLoading(true);
    try {
      await _apiService.post(ApiConstants.logout, {});
    } catch (e) {
      // Ignored since we are logging out locally anyway
    } finally {
      await _apiService.clearTokens();
      _user = null;
      _setLoading(false);
    }
  }

  // Auto Login check
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    if (token == null) {
      return false;
    }

    // Ideally, make a call to /auth/me or similar if provided by backend, 
    // or just assume logged in and let subsequent API calls fail with 401.
    return true;
  }

  String? get accessToken => _apiService.accessToken;

  Future<bool> loginWithToken(String token) async {
    _setLoading(true);
    _setError(null);
    try {
      // First, set the token in ApiService
      await _apiService.saveTokens(token, ''); // We might not have a refresh token here
      
      // Then fetch profile to verify it's still valid
      final response = await _apiService.get('/users/me');
      
      if (response['success'] == true && response['data'] != null) {
        _user = UserModel.fromJson(response['data']);
        _setLoading(false);
        return true;
      } else {
        _setError('Session expired. Please log in again.');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setLoading(false);
      _setError(e is AppException ? e.message : e.toString());
      return false;
    }
  }
}

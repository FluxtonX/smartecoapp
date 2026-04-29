import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/user_model.dart';
import '../repositories/user_repository_impl.dart';
import '../services/api_service.dart';
import '../core/constants/api_constants.dart';
import '../core/errors/app_exceptions.dart';
import '../core/services/biometric_service.dart';
import '../services/tracking_socket_service.dart';
import '../services/location_service.dart';

class AuthController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final BiometricService _biometricService = BiometricService();
  
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
        _user = data['user'] != null ? UserModel.fromJson(data['user']) : null;
        await _apiService.saveSession(
          accessToken: data['accessToken'],
          refreshToken: data['refreshToken'] ?? '',
          user: _user,
        );
        
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
        await _apiService.saveUser(_user);
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

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _apiService.post(ApiConstants.logout, {});
    } catch (e) {
      // Ignored since we are logging out locally anyway
    } finally {
      await _apiService.clearSession();
      await _biometricService.clearBiometricData();
      
      // Stop any active tracking/sockets
      LocationService().stopTracking();
      TrackingSocketService().disconnect();

      _user = null;
      _setLoading(false);
    }
  }

  Future<bool> tryAutoLogin() async {
    _setError(null);
    _user = await _apiService.getStoredUser();

    final hasValidSession = await _apiService.validateOrRefreshSession();
    if (!hasValidSession) {
      _user = null;
      notifyListeners();
      return false;
    }

    try {
      final repo = UserRepositoryImpl();
      _user = await repo.getProfile();
      await _apiService.saveUser(_user);
      notifyListeners();
      return true;
    } catch (e) {
      await _apiService.clearSession();
      _user = null;
      _setError(e is AppException ? e.message : 'Session expired. Please log in again.');
      return false;
    }
  }

  String? get accessToken => _apiService.accessToken;
  Future<bool> get hasStoredSession => _apiService.hasStoredSession();

  /// Sync local user state after external profile updates
  void updateLocalUser(UserModel updated) {
    _user = updated;
    unawaited(_apiService.saveUser(updated));
    notifyListeners();
  }

  /// Re-fetch profile from server (e.g. after phone change)
  Future<void> refreshProfile() async {
    try {
      final repo = UserRepositoryImpl();
      _user = await repo.getProfile();
      await _apiService.saveUser(_user);
      notifyListeners();
    } catch (_) {}
  }

  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _setError(null);

    try {
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(
        serverClientId: ApiConstants.googleServerClientId,
      );

      final completer = Completer<GoogleSignInAccount?>();
      
      final subscription = googleSignIn.authenticationEvents.listen((event) {
        final dynamic e = event;
        try {
          if (e.user != null) {
            if (!completer.isCompleted) completer.complete(e.user);
          } else {
            if (!completer.isCompleted) completer.complete(null);
          }
        } catch (_) {
          if (event.runtimeType.toString().contains('SignOut')) {
             if (!completer.isCompleted) completer.complete(null);
          }
        }
      }, onError: (err) {
        if (!completer.isCompleted) completer.completeError(err);
      });

      if (googleSignIn.supportsAuthenticate()) {
        await googleSignIn.authenticate();
      } else {
        _setError("Platform not supported");
        subscription.cancel();
        _setLoading(false);
        return false;
      }

      final googleUser = await completer.future.timeout(
        const Duration(minutes: 2),
        onTimeout: () => null,
      ).catchError((_) => null);
      
      subscription.cancel();

      if (googleUser == null) {
        _setLoading(false);
        return false;
      }

      // Get Identity Token from authentication AND Access Token from authorizeScopes
      final dynamic googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;
      
      final authorization = await googleUser.authorizationClient.authorizeScopes([
        'email',
        'profile',
      ]);
      final String accessToken = authorization.accessToken;

      if (idToken == null) {
        _setError("Google ID token missing");
        _setLoading(false);
        return false;
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accessToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        final String? firebaseIdToken = await firebaseUser.getIdToken();

        final response = await _apiService.post(ApiConstants.googleLogin, {
          'idToken': firebaseIdToken,
          'email': firebaseUser.email,
          'displayName': firebaseUser.displayName,
          'photoUrl': firebaseUser.photoURL,
        });

        if (response['success'] == true && response['data'] != null) {
          final data = response['data'];
          _user = data['user'] != null ? UserModel.fromJson(data['user']) : null;
          await _apiService.saveSession(
            accessToken: data['accessToken'],
            refreshToken: data['refreshToken'] ?? '',
            user: _user,
          );
          _setLoading(false);
          return true;
        }
      }

      _setError("Authentication failed");
      _setLoading(false);
      return false;
    } catch (e) {
      _setLoading(false);
      _setError(e.toString());
      return false;
    }
  }
}

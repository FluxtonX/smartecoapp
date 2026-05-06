import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../model/auth_session.dart';
import '../model/user_model.dart';

class SecureStorageService {
  SecureStorageService._();

  static final SecureStorageService instance = SecureStorageService._();

  static const String _accessTokenKey = 'auth_access_token';
  static const String _refreshTokenKey = 'auth_refresh_token';
  static const String _userKey = 'auth_user';

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  Future<AuthSession?> readSession() async {
    final values = await _storage.readAll();
    final accessToken = values[_accessTokenKey];
    final refreshToken = values[_refreshTokenKey];

    if (accessToken == null || accessToken.isEmpty) {
      return null;
    }

    return AuthSession(
      accessToken: accessToken,
      refreshToken: refreshToken ?? '',
      user: _decodeUser(values[_userKey]),
    );
  }

  Future<void> saveSession(AuthSession session) async {
    await _storage.write(key: _accessTokenKey, value: session.accessToken);
    await _storage.write(key: _refreshTokenKey, value: session.refreshToken);

    if (session.user != null) {
      await _storage.write(
        key: _userKey,
        value: jsonEncode(session.user!.toJson()),
      );
    } else {
      await _storage.delete(key: _userKey);
    }
  }

  Future<void> saveUser(UserModel? user) async {
    if (user == null) {
      await _storage.delete(key: _userKey);
      return;
    }

    await _storage.write(key: _userKey, value: jsonEncode(user.toJson()));
  }

  Future<UserModel?> readUser() async {
    return _decodeUser(await _storage.read(key: _userKey));
  }

  Future<void> clearSession() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _userKey);
  }

  UserModel? _decodeUser(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}

import 'user_model.dart';

class AuthSession {
  final String accessToken;
  final String refreshToken;
  final UserModel? user;

  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    this.user,
  });

  AuthSession copyWith({
    String? accessToken,
    String? refreshToken,
    UserModel? user,
    bool clearUser = false,
  }) {
    return AuthSession(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      user: clearUser ? null : (user ?? this.user),
    );
  }
}

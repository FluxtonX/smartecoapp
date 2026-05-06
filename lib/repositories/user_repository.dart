import '../model/user_model.dart';

abstract class UserRepository {
  Future<UserModel> getProfile();
  Future<UserModel> updateProfile(Map<String, dynamic> data);
  Future<Map<String, dynamic>> getReferralInfo();
  Future<void> updateFcmToken(String fcmToken);
}

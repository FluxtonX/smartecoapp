import '../services/api_service.dart';
import '../model/user_model.dart';
import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final ApiService _apiService = ApiService();

  @override
  Future<UserModel> getProfile() async {
    final response = await _apiService.get('/users/me');
    if (response['success'] == true && response['data'] != null) {
      return UserModel.fromJson(response['data']);
    }
    throw Exception('Failed to load profile');
  }

  @override
  Future<UserModel> updateProfile(Map<String, dynamic> data) async {
    final response = await _apiService.patch('/users/me', data);
    if (response['success'] == true && response['data'] != null) {
      return UserModel.fromJson(response['data']);
    }
    throw Exception('Failed to update profile');
  }

  @override
  Future<Map<String, dynamic>> getReferralInfo() async {
    final response = await _apiService.get('/users/me/referral');
    if (response['success'] == true) {
      return response['data'];
    }
    throw Exception('Failed to load referral info');
  }

  @override
  Future<void> updateFcmToken(String fcmToken) async {
    await _apiService.put('/users/me/fcm-token', {'token': fcmToken});
  }
}

import '../model/eco_point_model.dart';
import '../services/api_service.dart';

abstract class EcoPointsRepository {
  Future<EcoPointsBalance> getBalance();
  Future<List<EcoPointTransaction>> getHistory({int page = 1, int limit = 20});
  Future<bool> redeemReward(String rewardId, int points, String description);
}

class EcoPointsRepositoryImpl implements EcoPointsRepository {
  final ApiService _apiService = ApiService();

  @override
  Future<EcoPointsBalance> getBalance() async {
    final response = await _apiService.get('/eco-points/balance');
    if (response['success'] == true && response['data'] != null) {
      return EcoPointsBalance.fromJson(response['data']);
    }
    throw Exception('Failed to load balance');
  }

  @override
  Future<List<EcoPointTransaction>> getHistory({int page = 1, int limit = 20}) async {
    final response = await _apiService.get('/eco-points/history', queryParameters: {
      'page': page,
      'limit': limit,
    });
    if (response['success'] == true && response['data'] != null) {
      final List<dynamic> data = response['data'];
      return data.map((json) => EcoPointTransaction.fromJson(json)).toList();
    }
    throw Exception('Failed to load history');
  }

  @override
  Future<bool> redeemReward(String rewardId, int points, String description) async {
    final response = await _apiService.post('/eco-points/redeem', {
      'rewardId': rewardId,
      'points': points,
      'description': description,
    });
    return response['success'] == true;
  }
}

import '../model/pickup_model.dart';
import '../services/api_service.dart';

abstract class PickupRepository {
  Future<PickupModel> schedulePickup(Map<String, dynamic> data);
  Future<List<PickupModel>> getPickupHistory({String? status, String? wasteType});
  Future<PickupModel?> getActivePickup();
  Future<void> cancelPickup(String pickupId, String reason);
}

class PickupRepositoryImpl implements PickupRepository {
  final ApiService _apiService = ApiService();

  @override
  Future<PickupModel> schedulePickup(Map<String, dynamic> data) async {
    final response = await _apiService.post('/pickups', data);
    if (response['success'] == true && response['data'] != null) {
      return PickupModel.fromJson(response['data']);
    }
    throw Exception('Failed to schedule pickup');
  }

  @override
  Future<List<PickupModel>> getPickupHistory({String? status, String? wasteType}) async {
    final Map<String, String> queryParams = {};
    if (status != null) queryParams['status'] = status;
    if (wasteType != null) queryParams['wasteType'] = wasteType;
    
    // In current ApiService there's no way to pass query params to get
    // but we can append them manually or add them to the service.
    // For now appending manually.
    String query = '';
    if (queryParams.isNotEmpty) {
      query = '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}';
    }

    final response = await _apiService.get('/pickups$query');
    if (response['success'] == true && response['data'] != null) {
      final List<dynamic> data = response['data'];
      return data.map((json) => PickupModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load history');
  }

  @override
  Future<PickupModel?> getActivePickup() async {
    final response = await _apiService.get('/pickups/active');
    if (response['success'] == true) {
      if (response['data'] == null) return null;
      return PickupModel.fromJson(response['data']);
    }
    throw Exception('Failed to load active pickup');
  }

  @override
  Future<void> cancelPickup(String pickupId, String reason) async {
    await _apiService.patch('/pickups/$pickupId/cancel', {'reason': reason});
  }
}

import '../services/api_service.dart';
import '../model/collector_profile_model.dart';

class CollectorRepository {
  final ApiService _api = ApiService();

  // ─── Profile ────────────────────────────────────
  Future<CollectorProfileModel> getProfile() async {
    final response = await _api.get('/collectors/me/profile');
    return CollectorProfileModel.fromJson(response['data']);
  }

  // ─── Stats ──────────────────────────────────────
  Future<CollectorStatsModel> getStats() async {
    final response = await _api.get('/collectors/me/stats');
    return CollectorStatsModel.fromJson(response['data']);
  }

  // ─── Today's Pickups ────────────────────────────
  Future<List<CollectorPickupModel>> getTodayPickups() async {
    final response = await _api.get('/collectors/me/pickups');
    final list = response['data'] as List;
    return list.map((e) => CollectorPickupModel.fromJson(e)).toList();
  }

  // ─── Pickup Detail ──────────────────────────────
  Future<CollectorPickupModel> getPickupDetail(String pickupId) async {
    final response = await _api.get('/collectors/me/pickups/$pickupId');
    return CollectorPickupModel.fromJson(response['data']);
  }

  // ─── Pickup History ─────────────────────────────
  Future<Map<String, dynamic>> getPickupHistory({
    int page = 1,
    int limit = 20,
    String? status,
    String? wasteType,
    String? from,
    String? to,
  }) async {
    final params = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (status != null) params['status'] = status;
    if (wasteType != null) params['wasteType'] = wasteType;
    if (from != null) params['from'] = from;
    if (to != null) params['to'] = to;

    final queryString = params.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');
    final response = await _api.get('/collectors/me/history?$queryString');
    final list = (response['data'] as List)
        .map((e) => CollectorPickupModel.fromJson(e))
        .toList();
    return {
      'data': list,
      'meta': response['meta'],
    };
  }

  // ─── Update Pickup Status ───────────────────────
  Future<bool> updatePickupStatus(
    String pickupId,
    String status, {
    double? weightKg,
  }) async {
    final body = <String, dynamic>{'status': status};
    if (weightKg != null) body['weightKg'] = weightKg;

    final response = await _api.patch(
      '/collectors/pickups/$pickupId/status',
      body,
    );
    return response['success'] == true;
  }

  // ─── Update Location ────────────────────────────
  Future<bool> updateLocation(double latitude, double longitude) async {
    final response = await _api.patch('/collectors/me/location', {
      'latitude': latitude,
      'longitude': longitude,
    });
    return response['success'] == true;
  }

  // ─── Toggle Availability ────────────────────────
  Future<bool> toggleAvailability(bool isAvailable) async {
    final response = await _api.patch('/collectors/me/availability', {
      'isAvailable': isAvailable,
    });
    return response['success'] == true;
  }

  // ─── Register as Collector ──────────────────────
  Future<bool> registerAsCollector({
    required String vehiclePlate,
    required String zone,
    String? photoUrl,
  }) async {
    final body = <String, dynamic>{
      'vehiclePlate': vehiclePlate,
      'zone': zone,
    };
    if (photoUrl != null) body['photoUrl'] = photoUrl;

    final response = await _api.post('/collectors/register-me', body);
    return response['success'] == true;
  }
}

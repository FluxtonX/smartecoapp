import '../model/bin_model.dart';
import '../services/api_service.dart';

abstract class BinRepository {
  Future<List<BinModel>> getMyBins();
  Future<BinModel> updateFillLevel(String binId, double level);
}

class BinRepositoryImpl implements BinRepository {
  final ApiService _apiService = ApiService();

  @override
  Future<List<BinModel>> getMyBins() async {
    final response = await _apiService.get('/bins');
    if (response['success'] == true && response['data'] != null) {
      final List<dynamic> data = response['data'];
      return data.map((json) => BinModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load bins');
  }

  @override
  Future<BinModel> updateFillLevel(String binId, double level) async {
    final response = await _apiService.patch('/bins/$binId/fill-level', {'fillLevel': level});
    if (response['success'] == true && response['data'] != null) {
      return BinModel.fromJson(response['data']);
    }
    throw Exception('Failed to update fill level');
  }
}

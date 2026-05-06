import '../services/api_service.dart';

abstract class PaymentRepository {
  Future<Map<String, dynamic>> checkPaymentStatus(String paymentId);
}

class PaymentRepositoryImpl implements PaymentRepository {
  final ApiService _apiService = ApiService();

  @override
  Future<Map<String, dynamic>> checkPaymentStatus(String paymentId) async {
    final response = await _apiService.get('/payments/$paymentId/status');
    if (response['success'] == true && response['data'] != null) {
      return response['data'];
    }
    throw Exception('Failed to check payment status');
  }
}

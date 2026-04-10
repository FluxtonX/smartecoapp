import 'package:flutter/material.dart';
import 'dart:async';
import '../model/pickup_model.dart';
import '../repositories/pickup_repository.dart';
import '../repositories/payment_repository.dart';

class PickupController extends ChangeNotifier {
  final PickupRepository _pickupRepository = PickupRepositoryImpl();
  final PaymentRepository _paymentRepository = PaymentRepositoryImpl();

  List<PickupModel> _pickupHistory = [];
  PickupModel? _activePickup;
  bool _isLoading = false;
  String? _error;
  Timer? _trackingTimer;

  List<PickupModel> get pickupHistory => _pickupHistory;
  PickupModel? get activePickup => _activePickup;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchHistory({String? status, String? wasteType}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _pickupHistory = await _pickupRepository.getPickupHistory(
          status: status, wasteType: wasteType);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchActivePickup() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _activePickup = await _pickupRepository.getActivePickup();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void startTracking() {
    _trackingTimer?.cancel();
    _trackingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_activePickup != null && 
          (_activePickup!.status == PickupStatus.COLLECTOR_ASSIGNED || 
           _activePickup!.status == PickupStatus.EN_ROUTE ||
           _activePickup!.status == PickupStatus.ARRIVED)) {
        fetchActivePickup();
      } else {
        stopTracking();
      }
    });
  }

  void stopTracking() {
    _trackingTimer?.cancel();
    _trackingTimer = null;
  }

  @override
  void dispose() {
    stopTracking();
    super.dispose();
  }

  Future<bool> scheduleNewPickup(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final newPickup = await _pickupRepository.schedulePickup(data);
      _activePickup = newPickup; // Assuming it becomes active immediately
      _pickupHistory.insert(0, newPickup);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cancelActivePickup(String pickupId, String reason) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _pickupRepository.cancelPickup(pickupId, reason);
      if (_activePickup?.id == pickupId) {
        _activePickup = null;
      }
      await fetchHistory(); // To update the history with cancelled status
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, String?>> getPaymentStatus(String paymentId) async {
    try {
      final paymentData = await _paymentRepository.checkPaymentStatus(paymentId);
      return {
        'status': paymentData['status'] as String,
        'reason': paymentData['failReason'] as String?,
      };
    } catch (e) {
      debugPrint('Error checking payment status: $e');
      return {'status': 'PENDING', 'reason': null};
    }
  }
}

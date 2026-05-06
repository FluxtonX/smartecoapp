import 'package:flutter/material.dart';
import 'dart:async';
import '../model/pickup_model.dart';
import '../repositories/pickup_repository.dart';
import '../repositories/payment_repository.dart';
import '../services/tracking_socket_service.dart';
import '../services/api_service.dart';

class PickupController extends ChangeNotifier {
  final PickupRepository _pickupRepository = PickupRepositoryImpl();
  final PaymentRepository _paymentRepository = PaymentRepositoryImpl();

  List<PickupModel> _pickupHistory = [];
  PickupModel? _activePickup;
  bool _isLoading = false;
  String? _error;
  
  StreamSubscription? _locationSub;
  StreamSubscription? _statusSub;

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
    if (_activePickup == null) return;
    
    final token = ApiService().accessToken;
    if (token != null) {
      TrackingSocketService().connect(token);
      TrackingSocketService().joinPickupRoom(_activePickup!.id);

      _locationSub?.cancel();
      _locationSub = TrackingSocketService().locationUpdates.listen((data) {
        if (_activePickup != null && data['collectorId'] == _activePickup!.collector?.id) {
          // Update collector location and ETA
          _activePickup!.collector?.latitude = data['latitude'];
          _activePickup!.collector?.longitude = data['longitude'];
          _activePickup!.eta = data['eta'];
          notifyListeners();
        }
      });

      _statusSub?.cancel();
      _statusSub = TrackingSocketService().statusUpdates.listen((data) {
        if (_activePickup != null && data['pickupId'] == _activePickup!.id) {
          fetchActivePickup(); // Refresh full data on status change
        }
      });
    }
  }

  void stopTracking() {
    if (_activePickup != null) {
      TrackingSocketService().leavePickupRoom(_activePickup!.id);
    }
    _locationSub?.cancel();
    _locationSub = null;
    _statusSub?.cancel();
    _statusSub = null;
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

import 'package:flutter/material.dart';
import '../model/collector_profile_model.dart';
import '../repositories/collector_repository.dart';
import '../services/api_service.dart';
import '../services/tracking_socket_service.dart';
import '../services/location_service.dart';

class CollectorController extends ChangeNotifier {
  final CollectorRepository _repo = CollectorRepository();

  bool _isLoading = false;
  String? _error;
  CollectorProfileModel? _profile;
  CollectorStatsModel? _stats;
  List<CollectorPickupModel> _todayPickups = [];
  List<CollectorPickupModel> _pickupHistory = [];
  int _historyPage = 1;
  bool _hasMoreHistory = true;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  CollectorProfileModel? get profile => _profile;
  CollectorStatsModel? get stats => _stats;
  List<CollectorPickupModel> get todayPickups => _todayPickups;
  List<CollectorPickupModel> get pickupHistory => _pickupHistory;
  bool get hasMoreHistory => _hasMoreHistory;
  bool get isApproved => _profile?.isApproved ?? false;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  // ─── Fetch Profile ──────────────────────────────

  Future<void> fetchProfile() async {
    _setLoading(true);
    _setError(null);
    try {
      _profile = await _repo.getProfile();
      
      // Connect to websocket when fetching profile successfully
      final token = ApiService().accessToken;
      if (token != null) {
        TrackingSocketService().connect(token);
      }

      // Start/stop tracking based on profile availability
      if (_profile?.isAvailable == true) {
        LocationService().startTracking();
      } else {
        LocationService().stopTracking();
      }

      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      _setError(e.toString());
    }
  }

  // ─── Fetch Stats ────────────────────────────────

  Future<void> fetchStats() async {
    try {
      _stats = await _repo.getStats();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // ─── Fetch Today's Pickups ──────────────────────

  Future<void> fetchTodayPickups() async {
    _setLoading(true);
    _setError(null);
    try {
      _todayPickups = await _repo.getTodayPickups();
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      _setError(e.toString());
    }
  }

  // ─── Fetch Pickup History ───────────────────────

  Future<void> fetchPickupHistory({bool refresh = false}) async {
    if (refresh) {
      _historyPage = 1;
      _pickupHistory = [];
      _hasMoreHistory = true;
    }

    if (!_hasMoreHistory) return;

    try {
      final result = await _repo.getPickupHistory(page: _historyPage);
      final newPickups = result['data'] as List<CollectorPickupModel>;
      final meta = result['meta'] as Map<String, dynamic>?;

      _pickupHistory.addAll(newPickups);
      _historyPage++;

      if (meta != null) {
        final totalPages = meta['totalPages'] ?? 1;
        _hasMoreHistory = _historyPage <= totalPages;
      } else {
        _hasMoreHistory = newPickups.isNotEmpty;
      }

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // ─── Update Pickup Status ───────────────────────

  Future<bool> updatePickupStatus(
    String pickupId,
    String status, {
    double? weightKg,
  }) async {
    _setError(null);
    try {
      final success = await _repo.updatePickupStatus(
        pickupId,
        status,
        weightKg: weightKg,
      );
      if (success) {
        // Update local state
        final index = _todayPickups.indexWhere((p) => p.id == pickupId);
        if (index != -1 && status == 'COMPLETED') {
          _todayPickups.removeAt(index);
        }
        // Refresh data
        await fetchTodayPickups();
        await fetchProfile();
      }
      return success;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // ─── Toggle Availability ────────────────────────

  Future<bool> toggleAvailability(bool isAvailable) async {
    try {
      final success = await _repo.toggleAvailability(isAvailable);
      if (success && _profile != null) {
        // Optimistic update
        _profile = CollectorProfileModel(
          id: _profile!.id,
          userId: _profile!.userId,
          name: _profile!.name,
          phone: _profile!.phone,
          email: _profile!.email,
          avatarUrl: _profile!.avatarUrl,
          vehiclePlate: _profile!.vehiclePlate,
          zone: _profile!.zone,
          photoUrl: _profile!.photoUrl,
          rating: _profile!.rating,
          totalPickups: _profile!.totalPickups,
          isAvailable: isAvailable,
          isApproved: _profile!.isApproved,
          approvedAt: _profile!.approvedAt,
          todayPickups: _profile!.todayPickups,
          todayCompleted: _profile!.todayCompleted,
          totalWeightKg: _profile!.totalWeightKg,
          createdAt: _profile!.createdAt,
        );

        if (isAvailable) {
          LocationService().startTracking();
        } else {
          LocationService().stopTracking();
        }

        notifyListeners();
      }
      return success;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // ─── Update Location ────────────────────────────

  Future<bool> updateLocation(double lat, double lng) async {
    try {
      return await _repo.updateLocation(lat, lng);
    } catch (e) {
      return false;
    }
  }

  // ─── Load All Dashboard Data ────────────────────

  Future<void> loadDashboard() async {
    _setLoading(true);
    _setError(null);
    try {
      await Future.wait([
        fetchProfile(),
        fetchTodayPickups(),
        fetchStats(),
      ]);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
}

import 'package:flutter/material.dart';
import '../model/eco_point_model.dart';
import '../repositories/eco_points_repository.dart';

class EcoPointsController extends ChangeNotifier {
  final EcoPointsRepository _repository = EcoPointsRepositoryImpl();

  EcoPointsBalance? _balance;
  List<EcoPointTransaction> _history = [];
  bool _isLoading = false;
  String? _error;

  EcoPointsBalance? get balance => _balance;
  List<EcoPointTransaction> get history => _history;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchBalanceAndHistory() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final results = await Future.wait([
        _repository.getBalance(),
        _repository.getHistory(),
      ]);
      _balance = results[0] as EcoPointsBalance;
      _history = results[1] as List<EcoPointTransaction>;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> redeemReward(String rewardId, int points, String description) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final success = await _repository.redeemReward(rewardId, points, description);
      if (success) {
        await fetchBalanceAndHistory();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

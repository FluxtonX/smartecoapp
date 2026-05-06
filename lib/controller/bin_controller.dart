import 'package:flutter/material.dart';
import '../model/bin_model.dart';
import '../repositories/bin_repository.dart';

class BinController extends ChangeNotifier {
  final BinRepository _binRepository = BinRepositoryImpl();

  List<BinModel> _bins = [];
  bool _isLoading = false;
  String? _error;

  List<BinModel> get bins => _bins;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchMyBins() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _bins = await _binRepository.getMyBins();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateBinFillLevel(String binId, double level) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final updatedBin = await _binRepository.updateFillLevel(binId, level);
      final index = _bins.indexWhere((b) => b.id == binId);
      if (index != -1) {
        _bins[index] = updatedBin;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../repositories/user_repository.dart';
import '../repositories/user_repository_impl.dart';

class UserController extends ChangeNotifier {
  final UserRepository _userRepository = UserRepositoryImpl();

  UserModel? _profile;
  Map<String, dynamic>? _referralInfo;
  bool _isLoading = false;
  String? _error;

  UserModel? get profile => _profile;
  Map<String, dynamic>? get referralInfo => _referralInfo;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _profile = await _userRepository.getProfile();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _profile = await _userRepository.updateProfile(data);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchReferralInfo() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _referralInfo = await _userRepository.getReferralInfo();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

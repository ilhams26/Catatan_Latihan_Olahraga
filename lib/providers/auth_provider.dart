import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoggedIn = false;
  UserModel? _currentUser;
  int _weeklyTarget = 1000;

  bool get isLoggedIn => _isLoggedIn;
  UserModel? get currentUser => _currentUser;
  int get weeklyTarget => _weeklyTarget;
  String get username => _currentUser?.username ?? '';

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('is_login') ?? false;
    String savedUsername = prefs.getString('username') ?? '';
    _weeklyTarget = prefs.getInt('weekly_target') ?? 1000;

    if (_isLoggedIn && savedUsername.isNotEmpty) {
      _currentUser = await _apiService.getUserByUsername(savedUsername);
    }
    notifyListeners();
  }

  Future<void> login(String username) async {
    final prefs = await SharedPreferences.getInstance();
    UserModel? user = await _apiService.getUserByUsername(username);
    user ??= await _apiService.createUser(username);

    if (user != null) {
      await prefs.setBool('is_login', true);
      await prefs.setString('username', username);
      _isLoggedIn = true;
      _currentUser = user;
      notifyListeners();
    }
  }

  Future<void> updateBodyData(int weight, int height) async {
    if (_currentUser != null) {
      final updatedUser = UserModel(
        id: _currentUser!.id,
        username: _currentUser!.username,
        weight: weight,
        height: height,
      );

      bool success = await _apiService.updateUser(updatedUser);
      if (success) {
        _currentUser = updatedUser;
        notifyListeners();
      }
    }
  }

  //UPDATE USERNAME ---
  Future<bool> updateUsername(String newName) async {
    if (_currentUser != null) {
      final updatedUser = UserModel(
        id: _currentUser!.id,
        username: newName, // Nama baru
        weight: _currentUser!.weight,
        height: _currentUser!.height,
      );

      // 1. Update ke Server
      bool success = await _apiService.updateUser(updatedUser);

      if (success) {
        // 2. Update Lokal (Provider)
        _currentUser = updatedUser;

        // 3. Update Shared Preferences agar login tetap jalan
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', newName);

        notifyListeners();
        return true;
      }
    }
    return false;
  }

  Future<void> setWeeklyTarget(int target) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('weekly_target', target);
    _weeklyTarget = target;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _isLoggedIn = false;
    _currentUser = null;
    notifyListeners();
  }
}

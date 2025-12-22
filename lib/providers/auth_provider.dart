import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoggedIn = false;
  UserModel? _currentUser; // Menyimpan data user lengkap (ID, BB, TB)
  int _weeklyTarget = 1000; // Default target kalori

  bool get isLoggedIn => _isLoggedIn;
  UserModel? get currentUser => _currentUser;
  int get weeklyTarget => _weeklyTarget;

  get username => null;

  // Cek Status Login & Ambil Data Terbaru dari API
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('is_login') ?? false;
    String username = prefs.getString('username') ?? '';
    _weeklyTarget = prefs.getInt('weekly_target') ?? 1000;

    if (_isLoggedIn && username.isNotEmpty) {
      // Sinkronisasi data dari Server
      _currentUser = await _apiService.getUserByUsername(username);
    }
    notifyListeners();
  }

  // Login: Jika user belum ada di API, otomatis dibuatkan
  Future<void> login(String username) async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Cek apakah user ada di API?
    UserModel? user = await _apiService.getUserByUsername(username);

    // 2. Jika tidak ada, buat baru
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
      // Update object lokal
      final updatedUser = UserModel(
        id: _currentUser!.id,
        username: _currentUser!.username,
        weight: weight,
        height: height,
      );

      // Kirim ke API
      bool success = await _apiService.updateUser(updatedUser);
      if (success) {
        _currentUser = updatedUser;
        notifyListeners();
      }
    }
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

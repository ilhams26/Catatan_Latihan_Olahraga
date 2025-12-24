import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class ExerciseProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Exercise> _exercises = []; // Data milik user yang login
  List<Map<String, dynamic>> _leaderboardData = []; // Data Ranking Global

  bool _isLoading = false;

  List<Exercise> get exercises => _exercises;
  List<Map<String, dynamic>> get leaderboardData => _leaderboardData;
  bool get isLoading => _isLoading;

  // 1. Ambil Data HANYA milik User yang Login
  Future<void> getMyExercises(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _exercises = await _apiService.getExercisesByUser(userId);
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 2. Tambah Data (Simpan ID User)
  Future<bool> addExercise(Exercise exercise) async {
    _isLoading = true;
    notifyListeners();
    bool success = await _apiService.addExercise(exercise);
    if (success) {
      await getMyExercises(exercise.userId);
    } else {
      _isLoading = false;
      notifyListeners();
    }
    return success;
  }

  // 3. HITUNG LEADERBOARD (LOGIKA UTAMA)
  Future<void> fetchRealLeaderboard(String currentUserId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Ambil semua data global
      List<UserModel> allUsers = await _apiService.getAllUsers();
      List<Exercise> allWorkouts = await _apiService.getAllWorkoutsGlobal();

      // Hitung total kalori per User ID
      Map<String, int> calorieMap = {};

      for (var workout in allWorkouts) {
        if (!calorieMap.containsKey(workout.userId)) {
          calorieMap[workout.userId] = 0;
        }
        calorieMap[workout.userId] =
            calorieMap[workout.userId]! + workout.calories;
      }

      // Gabungkan User Info dengan Total Kalori
      List<Map<String, dynamic>> results = [];
      for (var user in allUsers) {
        int total = calorieMap[user.id] ?? 0;
        results.add({
          'name': user.username,
          'calories': total,
          'isMe': user.id == currentUserId, // Tandai diri sendiri
          'rank': 0, // Nanti diisi setelah sort
        });
      }

      // Urutkan dari terbesar
      results.sort((a, b) => b['calories'].compareTo(a['calories']));

      // Isi Ranking
      for (int i = 0; i < results.length; i++) {
        results[i]['rank'] = i + 1;
      }

      _leaderboardData = results;
    } catch (e) {
      debugPrint("Leaderboard Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

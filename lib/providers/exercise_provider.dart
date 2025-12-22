import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../services/api_service.dart';

class ExerciseProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Exercise> _exercises = [];
  bool _isLoading = false;

  List<Exercise> get exercises => _exercises;
  bool get isLoading => _isLoading;

  Future<void> getAllExercises() async {
    _isLoading = true;
    notifyListeners();

    try {
      _exercises = await _apiService.getExercises();
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addExercise(Exercise exercise) async {
    _isLoading = true;
    notifyListeners();

    bool success = await _apiService.addExercise(exercise);
    if (success) {
      await getAllExercises(); // Refresh data jika sukses
    } else {
      _isLoading = false;
      notifyListeners();
    }
    return success;
  }
}
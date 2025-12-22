import 'package:dio/dio.dart';
import '../models/exercise.dart';
import '../models/user_model.dart';

class ApiService {
  final String baseUrl = 'https://6948320d1ee66d04a44eed4d.mockapi.io/api/v1';
  final Dio _dio = Dio();

  // --- EXERCISE ---
  Future<List<Exercise>> getExercises() async {
    try {
      final response = await _dio.get('$baseUrl/workouts');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data
            .map((item) => Exercise.fromJson(item))
            .toList()
            .reversed
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> addExercise(Exercise exercise) async {
    try {
      final response = await _dio.post(
        '$baseUrl/workouts',
        data: exercise.toJson(),
      );
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
  // --- USER (BARU) ---
  Future<UserModel?> getUserByUsername(String username) async {
    try {
      final response = await _dio.get('$baseUrl/users?username=$username');
      if (response.statusCode == 200) {
        List data = response.data;
        if (data.isNotEmpty) {
          return UserModel.fromJson(data.first);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // 2. Buat user baru (Register otomatis)
  Future<UserModel?> createUser(String username) async {
    try {
      final newUser = UserModel(
        id: '',
        username: username,
        weight: 0,
        height: 0,
      );
      final response = await _dio.post(
        '$baseUrl/users',
        data: newUser.toJson(),
      );
      if (response.statusCode == 201) {
        return UserModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // 3. Update data user (Berat/Tinggi)
  Future<bool> updateUser(UserModel user) async {
    try {
      final response = await _dio.put(
        '$baseUrl/users/${user.id}',
        data: user.toJson(),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

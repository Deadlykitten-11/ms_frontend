// File: lib/src/services/user_service.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class UserService {
  Dio? _dio;
  final storage = FlutterSecureStorage();

  UserService() {
    _initDio();
  }

  Future<void> _initDio() async {
    if (_dio != null) {
      return;
    }
    _dio = Dio();
    print('Dio initialized for UserService');
  }

  // Update user role
  Future<bool> updateUserRole(String username, String newRole) async {
    try {
      print('Updating role for user: $username to $newRole');
      final response = await _dio!.put(
        'http://localhost:3000/api/auth/users/$username',
        data: jsonEncode({'role': newRole}),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print('Update role response: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('Error updating user role: $e');
      return false;
    }
  }

  // Fetch user role from backend using HttpOnly cookies
  Future<String?> fetchUserRole() async {
    try {
      print('Fetching user role');
      final response = await _dio!.get(
        'http://localhost:3000/api/auth/userinfo',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print('Fetch user role response: ${response.statusCode}');
      if (response.statusCode == 200) {
        return response.data['role'];
      } else {
        print('Failed to fetch user role: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching user role: $e');
      return null;
    }
  }

  // Fetch user details
  Future<List<dynamic>?> fetchPersonalDetails() async {
    try {
      print('Fetching personal details');
      final response = await _dio!.get(
        'http://localhost:3000/api/auth/users',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print('Fetch personal details response: ${response.statusCode}');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        print('Failed to load user information: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching user details: $e');
      return null;
    }
  }
}
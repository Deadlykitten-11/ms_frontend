// File: lib/src/services/user_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  // Update user role
  Future<bool> updateUserRole(String username, String newRole) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:3000/api/auth/users/$username'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'role': newRole}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating user role: $e');
      return false;
    }
  }

  // Fetch user details
  Future<List<dynamic>?> fetchPersonalDetails() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/auth/users'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
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

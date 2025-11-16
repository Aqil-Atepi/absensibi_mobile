// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'api_config.dart';

class AuthService {
  // LOGIN
  static Future<Map<String, dynamic>> login(String nis, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.login),
        headers: ApiConfig.headers,
        body: json.encode({
          'nis': nis,
          'password': password,
        }),
      );

      // Debug log (bisa dihapus di production)
      print('LOGIN status: ${response.statusCode}');
      print('LOGIN body  : "${response.body}"');

      if (response.body.isEmpty) {
        return {
          'success': false,
          'message': 'Server tidak mengembalikan data (body kosong).',
        };
      }

      Map<String, dynamic> data;
      try {
        data = json.decode(response.body) as Map<String, dynamic>;
      } catch (e) {
        return {
          'success': false,
          'message': 'Respon bukan JSON valid: ${response.body}',
        };
      }

      if (response.statusCode == 200 && data['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_data', json.encode(data['data']));
        await prefs.setString('nis', nis);
        await prefs.setBool('is_logged_in', true);

        return {
          'success': true,
          'message': data['message'] ?? 'Login berhasil',
          'user': UserModel.fromJson(data['data'] as Map<String, dynamic>),
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login gagal',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error koneksi: ${e.toString()}',
      };
    }
  }

  // LOGOUT
  static Future<void> logout() async {
    try {
      await http.post(Uri.parse(ApiConfig.logout));
    } catch (e) {
      print('Logout error: $e');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // CEK LOGIN
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  // AMBIL NIS
  static Future<String?> getCurrentNis() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('nis');
  }

  // AMBIL DATA USER
  static Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');

    if (userData != null) {
      return UserModel.fromJson(
        json.decode(userData) as Map<String, dynamic>,
      );
    }
    return null;
  }
}

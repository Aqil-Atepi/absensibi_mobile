// lib/services/profile_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'api_config.dart';

class ProfileService {
  // Get Profile
  static Future<UserModel?> getProfile(String nis) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.profileGet}?nis=$nis'),
        headers: ApiConfig.headers,
      );

      final data = json.decode(response.body);

      if (data['success'] == true) {
        return UserModel(
          nis: data['data']['nis'],
          nama: data['data']['nama'],
          kelas: data['data']['kelas'],
          kelasId: 0, // Not provided in profile endpoint
          status: data['data']['status'],
          foto: data['data']['foto'],
        );
      }
      return null;
    } catch (e) {
      print('Error get profile: $e');
      return null;
    }
  }

  // Update Foto Profile
  static Future<Map<String, dynamic>> updateFoto(String nis, String fotoBase64) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.profileUpdate),
        headers: ApiConfig.headers,
        body: json.encode({
          'nis': nis,
          'foto': fotoBase64,
        }),
      );

      final data = json.decode(response.body);

      if (data['success'] == true) {
        return {
          'success': true,
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Update foto gagal',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error koneksi: ${e.toString()}',
      };
    }
  }

  // Change Password
  static Future<Map<String, dynamic>> changePassword(
    String nis,
    String passwordLama,
    String passwordBaru,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.changePassword),
        headers: ApiConfig.headers,
        body: json.encode({
          'nis': nis,
          'password_lama': passwordLama,
          'password_baru': passwordBaru,
        }),
      );

      final data = json.decode(response.body);

      if (data['success'] == true) {
        return {
          'success': true,
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Ganti password gagal',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error koneksi: ${e.toString()}',
      };
    }
  }
}
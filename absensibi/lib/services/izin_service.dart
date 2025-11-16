// lib/services/izin_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/izin_model.dart';
import 'api_config.dart';

class IzinService {
  // Submit Izin
  static Future<Map<String, dynamic>> submitIzin({
    required String nis,
    required String alasan, // "Sakit" atau "Izin"
    required String deskripsi,
    required String fotoBase64,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.izinSubmit),
        headers: ApiConfig.headers,
        body: json.encode({
          'siswa': nis,
          'alasan': alasan,
          'deskripsi': deskripsi,
          'foto': fotoBase64,
        }),
      );

      final data = json.decode(response.body);

      if (data['success'] == true) {
        return {
          'success': true,
          'message': data['message'],
          'data': data['data'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Submit izin gagal',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error koneksi: ${e.toString()}',
      };
    }
  }

  // Get History Izin
  static Future<Map<String, dynamic>> getHistoryIzin(String nis) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.izinHistory}?nis=$nis'),
        headers: ApiConfig.headers,
      );

      final data = json.decode(response.body);

      if (data['success'] == true) {
        final List<dynamic> riwayatJson = data['data']['riwayat'];
        final riwayat = riwayatJson.map((item) => IzinModel.fromJson(item)).toList();

        return {
          'success': true,
          'riwayat': riwayat,
          'sisa_izin': data['data']['sisa_izin'],
          'total_digunakan': data['data']['total_digunakan'],
        };
      }
      return {
        'success': false,
        'riwayat': <IzinModel>[],
        'sisa_izin': 0,
        'total_digunakan': 0,
      };
    } catch (e) {
      print('Error get history izin: $e');
      return {
        'success': false,
        'riwayat': <IzinModel>[],
        'sisa_izin': 0,
        'total_digunakan': 0,
      };
    }
  }

  // Get Detail Izin
  static Future<Map<String, dynamic>?> getDetailIzin(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.izinDetail}?id=$id'),
        headers: ApiConfig.headers,
      );

      final data = json.decode(response.body);

      if (data['success'] == true) {
        return data['data'];
      }
      return null;
    } catch (e) {
      print('Error get detail izin: $e');
      return null;
    }
  }
}
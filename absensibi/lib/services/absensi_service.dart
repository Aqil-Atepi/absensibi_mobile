// lib/services/absensi_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/laporan_model.dart';
import '../models/riwayat_absensi_model.dart';
import 'api_config.dart';

class AbsensiService {
  // Check-in Absensi
  static Future<Map<String, dynamic>> checkin(String nis, {String? fotoBase64}) async {
    try {
      final body = {
        'siswa': nis,
      };

      if (fotoBase64 != null) {
        body['foto'] = fotoBase64;
      }

      final response = await http.post(
        Uri.parse(ApiConfig.checkin),
        headers: ApiConfig.headers,
        body: json.encode(body),
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
          'message': data['message'] ?? 'Check-in gagal',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error koneksi: ${e.toString()}',
      };
    }
  }

  // Get Laporan Kehadiran
  static Future<LaporanKehadiranModel?> getLaporanKehadiran(String nis) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.laporanKehadiran}?nis=$nis'),
        headers: ApiConfig.headers,
      );

      final data = json.decode(response.body);

      if (data['success'] == true) {
        return LaporanKehadiranModel.fromJson(data['data']);
      }
      return null;
    } catch (e) {
      print('Error get laporan: $e');
      return null;
    }
  }

  // Get Riwayat Kehadiran
  static Future<List<RiwayatAbsensiModel>> getRiwayatKehadiran(
    String nis, {
    int? bulan,
    int? tahun,
  }) async {
    try {
      final now = DateTime.now();
      final queryBulan = bulan ?? now.month;
      final queryTahun = tahun ?? now.year;

      final response = await http.get(
        Uri.parse('${ApiConfig.riwayatKehadiran}?nis=$nis&bulan=$queryBulan&tahun=$queryTahun'),
        headers: ApiConfig.headers,
      );

      final data = json.decode(response.body);

      if (data['success'] == true) {
        final List<dynamic> riwayat = data['data'];
        return riwayat.map((item) => RiwayatAbsensiModel.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print('Error get riwayat: $e');
      return [];
    }
  }
}
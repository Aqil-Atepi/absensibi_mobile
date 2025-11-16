// lib/services/jadwal_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/jadwal_model.dart';
import 'api_config.dart';

class JadwalService {
  // Get Jadwal Hari Ini
  static Future<JadwalModel?> getJadwalToday() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.jadwalToday),
        headers: ApiConfig.headers,
      );

      final data = json.decode(response.body);

      if (data['success'] == true) {
        return JadwalModel.fromJson(data['data']);
      }
      return null;
    } catch (e) {
      print('Error get jadwal today: $e');
      return null;
    }
  }

  // Get Semua Jadwal Mingguan
  static Future<List<dynamic>> getJadwalMingguan() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.jadwalGet),
        headers: ApiConfig.headers,
      );

      final data = json.decode(response.body);

      if (data['success'] == true) {
        return data['data'];
      }
      return [];
    } catch (e) {
      print('Error get jadwal mingguan: $e');
      return [];
    }
  }

  // Get Event Mendatang
  static Future<List<dynamic>> getEventUpcoming() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.eventUpcoming),
        headers: ApiConfig.headers,
      );

      final data = json.decode(response.body);

      if (data['success'] == true) {
        return data['data'];
      }
      return [];
    } catch (e) {
      print('Error get event upcoming: $e');
      return [];
    }
  }
}
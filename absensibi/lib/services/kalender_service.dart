// lib/services/kalender_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/kalender_marker_model.dart';
import 'api_config.dart';

class KalenderService {
  // Get Kalender Data dengan Marker
  static Future<Map<String, dynamic>> getKalenderData(
    String nis, {
    int? bulan,
    int? tahun,
  }) async {
    try {
      final now = DateTime.now();
      final queryBulan = bulan ?? now.month;
      final queryTahun = tahun ?? now.year;

      final response = await http.get(
        Uri.parse('${ApiConfig.kalenderData}?nis=$nis&bulan=$queryBulan&tahun=$queryTahun'),
        headers: ApiConfig.headers,
      );

      final data = json.decode(response.body);

      if (data['success'] == true) {
        final List<dynamic> markersJson = data['data']['markers'];
        final markers = markersJson.map((item) => KalenderMarkerModel.fromJson(item)).toList();

        // Convert markers ke Map<int, Color> untuk calendar widget
        final Map<int, String> markerColors = {};
        for (var marker in markers) {
          markerColors[marker.hari] = marker.color;
        }

        return {
          'success': true,
          'markers': markers,
          'marker_colors': markerColors,
          'jadwal': data['data']['jadwal'],
          'events': data['data']['events'],
        };
      }
      return {
        'success': false,
        'markers': <KalenderMarkerModel>[],
        'marker_colors': <int, String>{},
      };
    } catch (e) {
      print('Error get kalender data: $e');
      return {
        'success': false,
        'markers': <KalenderMarkerModel>[],
        'marker_colors': <int, String>{},
      };
    }
  }
}



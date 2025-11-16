// lib/services/qr_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class QRService {
  // Generate QR Token
  static Future<Map<String, dynamic>> generateQR(String nis) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.qrGenerate}?nis=$nis'),
        headers: ApiConfig.headers,
      );

      final data = json.decode(response.body);

      if (data['success'] == true) {
        return {
          'success': true,
          'qr_string': data['data']['qr_string'],
          'expire_at': data['data']['expire_at'],
          'valid_for': data['data']['valid_for'],
        };
      }
      return {
        'success': false,
        'message': 'Gagal generate QR',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error koneksi: ${e.toString()}',
      };
    }
  }

  // Validate QR Code (untuk scanner)
  static Future<Map<String, dynamic>> validateQR(String qrString) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.qrValidate),
        headers: ApiConfig.headers,
        body: json.encode({
          'qr_string': qrString,
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
          'message': data['message'] ?? 'QR tidak valid',
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

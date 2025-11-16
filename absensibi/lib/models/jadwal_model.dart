// lib/models/jadwal_model.dart
class JadwalModel {
  final String hari;
  final String tanggal;
  final String status;
  final String? waktu;
  final String keterangan;
  final bool isEvent;

  JadwalModel({
    required this.hari,
    required this.tanggal,
    required this.status,
    this.waktu,
    required this.keterangan,
    required this.isEvent,
  });

  factory JadwalModel.fromJson(Map<String, dynamic> json) {
    return JadwalModel(
      hari: json['hari'] ?? '',
      tanggal: json['tanggal'] ?? '',
      status: json['status'] ?? '',
      waktu: json['waktu'],
      keterangan: json['keterangan'] ?? '',
      isEvent: json['is_event'] ?? false,
    );
  }
}
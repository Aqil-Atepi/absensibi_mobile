// lib/models/laporan_model.dart
class LaporanKehadiranModel {
  final int hariDihadiri;
  final int tepatWaktu;
  final int telat;
  final int sakit;
  final int izin;
  final int alpha;
  final int sisaIzin;
  final int totalIzinDigunakan;
  final double persentaseKehadiran;

  LaporanKehadiranModel({
    required this.hariDihadiri,
    required this.tepatWaktu,
    required this.telat,
    required this.sakit,
    required this.izin,
    required this.alpha,
    required this.sisaIzin,
    required this.totalIzinDigunakan,
    required this.persentaseKehadiran,
  });

  factory LaporanKehadiranModel.fromJson(Map<String, dynamic> json) {
    return LaporanKehadiranModel(
      hariDihadiri: json['hari_dihadiri'] ?? 0,
      tepatWaktu: json['tepat_waktu'] ?? 0,
      telat: json['telat'] ?? 0,
      sakit: json['sakit'] ?? 0,
      izin: json['izin'] ?? 0,
      alpha: json['alpha'] ?? 0,
      sisaIzin: json['sisa_izin'] ?? 0,
      totalIzinDigunakan: json['total_izin_digunakan'] ?? 0,
      persentaseKehadiran: (json['persentase_kehadiran'] ?? 0).toDouble(),
    );
  }
}

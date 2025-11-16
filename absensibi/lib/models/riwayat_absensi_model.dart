// lib/models/riwayat_absensi_model.dart
class RiwayatAbsensiModel {
  final String tanggal;
  final String waktu;
  final String status;
  final String approvalStatus;

  RiwayatAbsensiModel({
    required this.tanggal,
    required this.waktu,
    required this.status,
    required this.approvalStatus,
  });

  factory RiwayatAbsensiModel.fromJson(Map<String, dynamic> json) {
    return RiwayatAbsensiModel(
      tanggal: json['tanggal'] ?? '',
      waktu: json['waktu'] ?? '',
      status: json['status'] ?? '',
      approvalStatus: json['approval_status'] ?? '',
    );
  }
}
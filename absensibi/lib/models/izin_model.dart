// lib/models/izin_model.dart
class IzinModel {
  final int id;
  final String tanggal;
  final String alasan;
  final String deskripsi;
  final String status;
  final String? foto;

  IzinModel({
    required this.id,
    required this.tanggal,
    required this.alasan,
    required this.deskripsi,
    required this.status,
    this.foto,
  });

  factory IzinModel.fromJson(Map<String, dynamic> json) {
    return IzinModel(
      id: json['id'] ?? 0,
      tanggal: json['tanggal'] ?? '',
      alasan: json['alasan'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      status: json['status'] ?? '',
      foto: json['foto'],
    );
  }
}
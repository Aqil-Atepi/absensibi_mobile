// lib/models/user_model.dart
class UserModel {
  final String nis;
  final String nama;
  final String kelas;
  final int kelasId;
  final String status;
  final String? foto;

  UserModel({
    required this.nis,
    required this.nama,
    required this.kelas,
    required this.kelasId,
    required this.status,
    this.foto,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      nis: json['nis'] ?? '',
      nama: json['nama'] ?? '',
      kelas: json['kelas'] ?? '',
      kelasId: json['kelas_id'] ?? 0,
      status: json['status'] ?? '',
      foto: json['foto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nis': nis,
      'nama': nama,
      'kelas': kelas,
      'kelas_id': kelasId,
      'status': status,
      'foto': foto,
    };
  }
}








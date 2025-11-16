// lib/models/kalender_marker_model.dart
class KalenderMarkerModel {
  final int hari;
  final String status;
  final String color;

  KalenderMarkerModel({
    required this.hari,
    required this.status,
    required this.color,
  });

  factory KalenderMarkerModel.fromJson(Map<String, dynamic> json) {
    return KalenderMarkerModel(
      hari: json['hari'] ?? 0,
      status: json['status'] ?? '',
      color: json['color'] ?? '#999999',
    );
  }
}

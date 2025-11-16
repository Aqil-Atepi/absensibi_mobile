// lib/pages/permitdetail.dart
import 'package:flutter/material.dart';

class PermitDetailPage extends StatelessWidget {
  final String title;
  final String? deskripsi;
  final String? status;
  final ImageProvider? image;

  const PermitDetailPage({
    super.key,
    required this.title,
    this.deskripsi,
    this.status,
    this.image,
  });

  static const Color kPrimary = Colors.purple;

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;
    
    switch (status) {
      case 'Diterima':
        statusColor = const Color(0xFF2AAE4A);
        statusIcon = Icons.check_circle;
        break;
      case 'Diproses':
        statusColor = const Color(0xFFFF9800);
        statusIcon = Icons.hourglass_empty;
        break;
      case 'Ditolak':
        statusColor = const Color(0xFFE35151);
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimary,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Detail Izin',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 26,
            letterSpacing: 0.3,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
          children: [
            // Title
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 1)),
                ],
              ),
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
            const SizedBox(height: 12),

            // Status
            if (status != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 1)),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(statusIcon, color: statusColor, size: 24),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Status Pengajuan',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          status!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            
            if (status != null) const SizedBox(height: 12),

            // Deskripsi
            if (deskripsi != null && deskripsi!.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 1)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Deskripsi',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      deskripsi!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),

            if (deskripsi != null && deskripsi!.isNotEmpty) const SizedBox(height: 12),

            // Foto
            Container(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 1)),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Foto Surat Izin',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _PhotoView(image: image),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoView extends StatelessWidget {
  final ImageProvider? image;
  const _PhotoView({this.image});

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return Container(
        height: 240,
        width: double.infinity,
        color: const Color(0xFFF3F4F6),
        alignment: Alignment.center,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported_outlined, size: 64, color: Colors.black26),
            SizedBox(height: 12),
            Text(
              'Tidak ada foto',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      );
    }
    return Image(
      image: image!,
      height: 240,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
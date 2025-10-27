import 'package:flutter/material.dart';

class PermitDetailPage extends StatelessWidget {
  final String title;
  final ImageProvider? image;

  const PermitDetailPage({
    super.key,
    required this.title,
    this.image,
  });

  static const Color kPrimary = Colors.purple;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F6), // <- light background
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimary, // keep top bar purple
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
            // Title pill
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
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 16),

            // Photo card
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
                    'Foto Izin',
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
        child: const Text(
          'Tidak ada foto',
          style: TextStyle(color: Colors.black54),
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

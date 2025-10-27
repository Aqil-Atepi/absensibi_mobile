import 'package:flutter/material.dart';
import 'permitdetail.dart';

class PermitHistoryPage extends StatefulWidget {
  const PermitHistoryPage({super.key});

  @override
  State<PermitHistoryPage> createState() => _PermitHistoryPageState();
}

class _PermitHistoryPageState extends State<PermitHistoryPage> {
  static const Color kPrimary = Colors.purple;

  // Example data
  final List<PermitRecord> _items = const [
    PermitRecord(
      'Izin Acara Keluarga 24/04/25',
      image: AssetImage('assets/images/sample_izin.jpg'),
    ),
    PermitRecord('Izin Tanggal 27/05 2025'),
    PermitRecord('Izin Tanggal 27/05 2025'),
    PermitRecord('Izin Tanggal 27/05 2025'),
    PermitRecord('Izin Tanggal 27/05 2025'),
    PermitRecord('Izin Tanggal 27/05 2025'),
  ];

  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F6), // light background
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimary,               // keep top bar purple
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Riwayat Izin',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 26,
            letterSpacing: 0.3,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
          itemCount: _items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final selected = _selectedIndex == i;
            final item = _items[i];
            return _HistoryTile(
              label: item.title,
              selected: selected,
              onTap: () {
                setState(() => _selectedIndex = i);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PermitDetailPage(
                      title: item.title,
                      image: item.image,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _HistoryTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  static const kPrimary = Colors.purple;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: selected
                ? Border.all(color: kPrimary, width: 3) // use purple when selected
                : null,
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2)),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

// Simple record model
class PermitRecord {
  final String title;
  final ImageProvider? image; // AssetImage / NetworkImage / FileImage
  const PermitRecord(this.title, {this.image});
}

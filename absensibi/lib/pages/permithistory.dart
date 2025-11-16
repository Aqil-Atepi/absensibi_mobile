// lib/pages/permithistory.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:absensibi/services/auth_service.dart';
import 'package:absensibi/services/izin_service.dart';
import 'package:absensibi/models/izin_model.dart';
import 'permitdetail.dart';

class PermitHistoryPage extends StatefulWidget {
  const PermitHistoryPage({super.key});

  @override
  State<PermitHistoryPage> createState() => _PermitHistoryPageState();
}

class _PermitHistoryPageState extends State<PermitHistoryPage> {
  static const Color kPrimary = Colors.purple;

  List<IzinModel> _items = [];
  int _sisaIzin = 0;
  int _totalDigunakan = 0;
  int? _selectedIndex;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);

    try {
      final nis = await AuthService.getCurrentNis();
      if (nis != null) {
        final result = await IzinService.getHistoryIzin(nis);
        
        if (result['success'] == true && mounted) {
          setState(() {
            _items = result['riwayat'];
            _sisaIzin = result['sisa_izin'];
            _totalDigunakan = result['total_digunakan'];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error loading history: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimary,
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadHistory,
                child: Column(
                  children: [
                    // Info sisa izin
                    Container(
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: kPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: kPrimary, width: 2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Sisa Izin',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$_sisaIzin / 7',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: kPrimary,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Sudah Digunakan',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$_totalDigunakan kali',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // List history
                    Expanded(
                      child: _items.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.inbox_outlined, size: 64, color: Colors.black26),
                                  SizedBox(height: 16),
                                  Text(
                                    'Belum ada riwayat izin',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                              itemCount: _items.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, i) {
                                final selected = _selectedIndex == i;
                                final item = _items[i];
                                
                                // Format tanggal
                                final tanggal = DateTime.tryParse(item.tanggal);
                                final tanggalStr = tanggal != null
                                    ? '${tanggal.day}/${tanggal.month}/${tanggal.year}'
                                    : item.tanggal;

                                return _HistoryTile(
                                  label: '${item.alasan} - $tanggalStr',
                                  status: item.status,
                                  selected: selected,
                                  onTap: () {
                                    setState(() => _selectedIndex = i);
                                    
                                    // Navigate ke detail
                                    ImageProvider? imageProvider;
                                    if (item.foto != null) {
                                      try {
                                        final bytes = base64Decode(item.foto!);
                                        imageProvider = MemoryImage(bytes);
                                      } catch (e) {
                                        print('Error decode foto: $e');
                                      }
                                    }

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => PermitDetailPage(
                                          title: '${item.alasan} - $tanggalStr',
                                          deskripsi: item.deskripsi,
                                          status: item.status,
                                          image: imageProvider,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final String label;
  final String status;
  final bool selected;
  final VoidCallback onTap;

  const _HistoryTile({
    required this.label,
    required this.status,
    required this.selected,
    required this.onTap,
  });

  static const kPrimary = Colors.purple;

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
            border: selected ? Border.all(color: kPrimary, width: 3) : null,
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2)),
            ],
          ),
          child: Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.black26),
            ],
          ),
        ),
      ),
    );
  }
}
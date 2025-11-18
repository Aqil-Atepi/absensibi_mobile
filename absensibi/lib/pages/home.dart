// lib/pages/home.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:absensibi/pages/calendar.dart';
import 'package:absensibi/pages/permit.dart';
import 'package:absensibi/pages/permithistory.dart';
import 'package:absensibi/pages/qr.dart';
import 'package:absensibi/pages/settings.dart';
import 'package:absensibi/pages/profile.dart';
import 'package:absensibi/low_spec_animation.dart';
import 'package:absensibi/services/auth_service.dart';
import 'package:absensibi/services/absensi_service.dart';
import 'package:absensibi/services/jadwal_service.dart';
import 'package:absensibi/services/profile_service.dart';
import 'package:absensibi/models/laporan_model.dart';
import 'package:absensibi/models/jadwal_model.dart';
import 'package:absensibi/models/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Colors
  static const Color kPrimary = Colors.purple;
  static const Color kChipRed = Color.fromARGB(235, 255, 2, 2);
  static const Color kChipGreen = Color(0xFF2AAE4A);
  static const Color kLightGrey = Color(0xFFF4F4F6);
  static const Color kTextMuted = Color(0xFF8C8C96);

  // Data variables
  UserModel? _user;
  LaporanKehadiranModel? _laporan;
  JadwalModel? _jadwalToday;
  String _currentTime = '';
  String _currentDate = '';
  String _greeting = '';
  String _statusWaktu = '';
  Color _statusColor = kChipGreen;
  bool _isLoading = true;

  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();
    _loadAllData();
    _startClock();
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  // Load semua data dari API
  Future<void> _loadAllData() async {
    setState(() => _isLoading = true);

    try {
      final nis = await AuthService.getCurrentNis();
      if (nis == null) {
        // Redirect ke login jika belum login
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
        return;
      }

      // Load data parallel
      final results = await Future.wait([
        ProfileService.getProfile(nis),
        AbsensiService.getLaporanKehadiran(nis),
        JadwalService.getJadwalToday(),
      ]);

      if (mounted) {
        setState(() {
          _user = results[0] as UserModel?;
          _laporan = results[1] as LaporanKehadiranModel?;
          _jadwalToday = results[2] as JadwalModel?;
          _isLoading = false;
        });
        
        _updateStatusWaktu();
      }
    } catch (e) {
      print('Error loading data: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Start real-time clock
  void _startClock() {
    _updateClock();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateClock();
      _updateStatusWaktu();
    });
  }

  // Update waktu & greeting
  void _updateClock() {
    final now = DateTime.now();
    final hour = now.hour;

    String greeting;
    if (hour >= 5 && hour < 10) {
      greeting = 'Selamat Pagi!';
    } else if (hour >= 10 && hour < 15) {
      greeting = 'Selamat Siang!';
    } else if (hour >= 15 && hour < 18) {
      greeting = 'Selamat Sore!';
    } else {
      greeting = 'Selamat Malam!';
    }

    setState(() {
      _currentTime = DateFormat('HH:mm').format(now);
      _currentDate = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(now);
      _greeting = greeting;
    });
  }

  // Update status telat/tepat waktu
  void _updateStatusWaktu() {
    if (_jadwalToday?.waktu == null) return;

    try {
      final now = DateTime.now();
      final batasWaktuStr = _jadwalToday!.waktu!; // Format: "07:40:00"
      final parts = batasWaktuStr.split(':');
      
      final batasWaktu = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );

      setState(() {
        if (now.isAfter(batasWaktu)) {
          _statusWaktu = 'Telat';
          _statusColor = kChipRed;
        } else {
          _statusWaktu = 'Tepat Waktu';
          _statusColor = kChipGreen;
        }
      });
    } catch (e) {
      print('Error parsing waktu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF0F2F6),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F6),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadAllData,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 8),
                // Header Card dengan data real
                RepaintBoundary(
                  child: _HeaderCard(
                    nama: _user?.nama ?? 'Loading...',
                    kelas: _user?.kelas ?? '',
                    greeting: _greeting,
                    tanggal: _currentDate,
                    waktu: _currentTime,
                    status: _statusWaktu,
                    statusColor: _statusColor,
                    fotoBase64: _user?.foto,
                  ),
                ),
                const SizedBox(height: 14),
                // Laporan Kehadiran dengan data real
                RepaintBoundary(
                  child: _AttendanceReportCard(
                    hariDihadiri: _laporan?.hariDihadiri ?? 0,
                    hariIzin: _laporan?.izin ?? 0,
                    hariTelat: _laporan?.telat ?? 0,
                    sisaIzin: _laporan?.sisaIzin ?? 0,
                  ),
                ),
                const SizedBox(height: 10),
                // Riwayat Izin dengan sisa izin real
                RepaintBoundary(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.push(
                      context,
                      LowSpecPageRoute(builder: (_) => const PermitHistoryPage()),
                    ),
                    child: _BigSectionCard.clock(
                      title: 'Riwayat Izin',
                      subtitleTop: 'SISA IZIN ${_laporan?.sisaIzin ?? 0}/7',
                      subtitleBottom: 'Semester Ganjil 25/26',
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _navBar(context),
    );
  }

  Widget _navBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _BottomItem(
            asset: 'assets/svg/home.svg',
            active: true,
            onTap: () {},
          ),
          _BottomItem(
            asset: 'assets/svg/calendar.svg',
            onTap: () => Navigator.push(context, LowSpecPageRoute(builder: (_) => const CalendarPage())),
          ),
          GestureDetector(
            onTap: () => Navigator.push(context, LowSpecPageRoute(builder: (_) => const QRPage())),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: kPrimary,
                boxShadow: [BoxShadow(color: Color(0x33000000), blurRadius: 8)],
              ),
              child: SvgPicture.asset(
                'assets/svg/qr.svg',
                width: 26,
                height: 26,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ),
          _BottomItem(
            asset: 'assets/svg/permit.svg',
            onTap: () => Navigator.push(context, LowSpecPageRoute(builder: (_) => const PermitPage())),
          ),
          _BottomItem(
            asset: 'assets/svg/settings.svg',
            onTap: () => Navigator.push(context, LowSpecPageRoute(builder: (_) => const SettingsPage())),
          ),
        ],
      ),
    );
  }
}

// ===================================================================
// Widgets
// ===================================================================

class _BottomItem extends StatelessWidget {
  final String asset;
  final bool active;
  final VoidCallback onTap;
  const _BottomItem({required this.asset, required this.onTap, this.active = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SvgPicture.asset(
        asset,
        width: 26,
        height: 26,
        colorFilter: ColorFilter.mode(
          active ? _HomePageState.kPrimary : Colors.grey,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final String nama;
  final String kelas;
  final String greeting;
  final String tanggal;
  final String waktu;
  final String status;
  final Color statusColor;
  final String? fotoBase64;

  const _HeaderCard({
    required this.nama,
    required this.kelas,
    required this.greeting,
    required this.tanggal,
    required this.waktu,
    required this.status,
    required this.statusColor,
    this.fotoBase64,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.push(
          context,
          LowSpecPageRoute(builder: (_) => const ProfilePage()),
        ),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: _HomePageState.kPrimary.withOpacity(0.1),
                    child: const Icon(Icons.person, color: _HomePageState.kPrimary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(greeting, style: const TextStyle(fontSize: 12, color: _HomePageState.kTextMuted)),
                        const SizedBox(height: 2),
                        Text(nama,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black),
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        Text(kelas, style: const TextStyle(fontSize: 12, color: _HomePageState.kTextMuted)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 96),
                ],
              ),
            ),
            Positioned(
              right: 12,
              top: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    tanggal,
                    style: const TextStyle(fontSize: 10, color: _HomePageState.kTextMuted),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _HomePageState.kLightGrey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(waktu,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16, letterSpacing: 0.5, color: Colors.black)),
                  ),
                  const SizedBox(height: 6),
                  Text(status, style: TextStyle(fontSize: 11, color: statusColor, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttendanceReportCard extends StatelessWidget {
  final int hariDihadiri;
  final int hariIzin;
  final int hariTelat;
  final int sisaIzin;

  const _AttendanceReportCard({
    required this.hariDihadiri,
    required this.hariIzin,
    required this.hariTelat,
    required this.sisaIzin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _HomePageState.kPrimary.withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
        ),
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white, height: 1.4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Laporan Kehadiran', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 8),
              _ReportRow(label: 'Hari Dihadiri', value: '$hariDihadiri'),
              _ReportRow(label: 'Hari Izin', value: '$hariIzin'),
              _ReportRow(label: 'Hari Telat', value: '$hariTelat'),
              _ReportRow(label: 'Sisa Hari Izin', value: '$sisaIzin'),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReportRow extends StatelessWidget {
  final String label;
  final String value;
  const _ReportRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 12))),
        const Text(':  ', style: const TextStyle(fontSize: 12)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
      ],
    );
  }
}

class _BigSectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitleTop;
  final String subtitleBottom;

  const _BigSectionCard._({
    required this.icon,
    required this.title,
    required this.subtitleTop,
    required this.subtitleBottom,
  });

  const factory _BigSectionCard.clock({
    required String title,
    required String subtitleTop,
    required String subtitleBottom,
  }) = _BigSectionCard._clock;

  const factory _BigSectionCard.calendar({
    required String title,
    required String subtitleTop,
    required String subtitleBottom,
  }) = _BigSectionCard._calendar;

  const _BigSectionCard._clock({
    required String title,
    required String subtitleTop,
    required String subtitleBottom,
  }) : this._(
          icon: Icons.access_time_filled_rounded,
          title: title,
          subtitleTop: subtitleTop,
          subtitleBottom: subtitleBottom,
        );

  const _BigSectionCard._calendar({
    required String title,
    required String subtitleTop,
    required String subtitleBottom,
  }) : this._(
          icon: Icons.calendar_month_rounded,
          title: title,
          subtitleTop: subtitleTop,
          subtitleBottom: subtitleBottom,
        );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(icon, size: 44, color: Colors.black87),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black)),
                  const SizedBox(height: 6),
                  Text(subtitleTop, style: const TextStyle(fontSize: 12, color: _HomePageState.kPrimary)),
                  const SizedBox(height: 2),
                  Text(subtitleBottom, style: const TextStyle(fontSize: 12, color: _HomePageState.kTextMuted)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black26),
          ],
        ),
      ),
    );
  }
}
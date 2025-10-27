// lib/pages/home.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:absensibi/pages/calendar.dart';
import 'package:absensibi/pages/permit.dart';
import 'package:absensibi/pages/permithistory.dart';   // <-- history
import 'package:absensibi/pages/qr.dart';
import 'package:absensibi/pages/settings.dart';
import 'package:absensibi/pages/profile.dart';
import 'package:absensibi/low_spec_animation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Colors
  static const Color kPrimary = Colors.purple;
  static const Color kChipRed = Color.fromARGB(235, 255, 2, 2);
  static const Color kLightGrey = Color(0xFFF4F4F6);
  static const Color kTextMuted = Color(0xFF8C8C96);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage('assets/images/sample_profile.jpg'), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 8),
              // isolate repaints for big, mostly-static sections
              const RepaintBoundary(
                child: _HeaderCard(
                  primary: kPrimary,
                  chipRed: kChipRed,
                ),
              ),
              const SizedBox(height: 14),
              const RepaintBoundary(child: _AttendanceReportCard(primary: kPrimary)),
              const SizedBox(height: 10),
              const RepaintBoundary(child: _TeacherTile()),
              const SizedBox(height: 10),

              // ---- Make "Riwayat Izin" tappable -> PermitHistoryPage
              RepaintBoundary(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.push(
                    context,
                    LowSpecPageRoute(builder: (_) => const PermitHistoryPage()),
                  ),
                  child: const _BigSectionCard.clock(
                    title: 'Riwayat Izin',
                    subtitleTop: 'SISA IZIN 6/7',
                    subtitleBottom: 'Semester Ganjil 25/26',
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Kehadiran (kept as a plain card)
              const RepaintBoundary(
                child: _BigSectionCard.calendar(
                  title: 'Riwayat Kehadiran',
                  subtitleTop: '13 August 2025',
                  subtitleBottom: 'Semester Ganjil 25/26',
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _navBar(context),
    );
  }

  // --- Bottom Nav ---
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
            onTap: () {
              if (_currentIndex != 0) {
                setState(() => _currentIndex = 0);
                Navigator.pushReplacement(
                  context,
                  LowSpecPageRoute(builder: (_) => const HomePage()),
                );
              }
            },
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
        colorFilter: ColorFilter.mode(active ? _HomePageState.kPrimary : Colors.grey, BlendMode.srcIn),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final Color primary;
  final Color chipRed;

  const _HeaderCard({required this.primary, required this.chipRed});

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
                  const CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage('assets/images/sample_profile.jpg'),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Selamat Pagi!', style: TextStyle(fontSize: 12, color: _HomePageState.kTextMuted)),
                        SizedBox(height: 2),
                        Text('Rizq Dzaki Samudera',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black)),
                        SizedBox(height: 2),
                        Text('XII RPL', style: TextStyle(fontSize: 12, color: _HomePageState.kTextMuted)),
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
                  const Text(
                    'Rabu, 17 Agustus 2025',
                    style: TextStyle(fontSize: 10, color: _HomePageState.kTextMuted),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _HomePageState.kLightGrey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('08:00',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16, letterSpacing: 0.5, color: Colors.black)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('Telat', style: TextStyle(fontSize: 11, color: chipRed, fontWeight: FontWeight.w600)),
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
  final Color primary;
  const _AttendanceReportCard({required this.primary});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: primary.withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
        ),
        child: const DefaultTextStyle(
          style: TextStyle(color: Colors.white, height: 1.4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Laporan Kehadiran', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              SizedBox(height: 8),
              _ReportRow(label: 'Hari Dihadiri', value: '44'),
              _ReportRow(label: 'Hari Izin', value: '5'),
              _ReportRow(label: 'Hari Telat', value: '9'),
              _ReportRow(label: 'Sisa Hari Izin', value: '7'),
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
        const Text(':  ', style: TextStyle(fontSize: 12)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
      ],
    );
  }
}

class _TeacherTile extends StatelessWidget {
  const _TeacherTile();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFEFF3FF)),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.person, color: _HomePageState.kPrimary),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rizam Nuruzzaman, M.Pd.',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black)),
                  SizedBox(height: 2),
                  Text('Produk Kreatif dan Kewirausahaan 2',
                      style: TextStyle(fontSize: 11, color: _HomePageState.kTextMuted)),
                  SizedBox(height: 2),
                  Text('Semester GANJIL 25/26 · Ruangan A9',
                      style: TextStyle(fontSize: 11, color: _HomePageState.kTextMuted)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F7FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('10:06', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ],
            )
          ],
        ),
      ),
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

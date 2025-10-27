import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:absensibi/pages/home.dart';
import 'package:absensibi/pages/calendar.dart';
import 'package:absensibi/pages/permit.dart';
import 'package:absensibi/pages/qr.dart';
import 'package:absensibi/pages/profile.dart';
import 'package:absensibi/pages/login.dart';            // <-- make sure this path/class matches your project
import 'package:absensibi/low_spec_animation.dart';     // LowSpecPageRoute

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const Color kPrimary = Colors.purple;

  void _logoutLocal() {
    // (Optional) Clear local state here: SharedPreferences, caches, etc.
    // final prefs = await SharedPreferences.getInstance(); await prefs.clear();

    // Go straight to Login and clear the back stack
    Navigator.of(context).pushAndRemoveUntil(
      LowSpecPageRoute(builder: (_) => const LandingPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimary,
        leading: const BackButton(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Setelan',
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
            _SettingTile(
              label: 'Profile',
              icon: Icons.person_rounded,
              onTap: () => Navigator.push(
                context,
                LowSpecPageRoute(builder: (_) => const ProfilePage()),
              ),
            ),
            const SizedBox(height: 10),
            _SettingTile(
              label: 'Logout',
              icon: Icons.logout_rounded,
              onTap: _logoutLocal, // direct to login.dart (local only)
            ),
          ],
        ),
      ),
      bottomNavigationBar: _navBar(context),
    );
  }

  static Container _navBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () => Navigator.push(context, LowSpecPageRoute(builder: (_) => const HomePage())),
            child: SvgPicture.asset(
              'assets/svg/home.svg', width: 26, height: 26,
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(context, LowSpecPageRoute(builder: (_) => const CalendarPage())),
            child: SvgPicture.asset(
              'assets/svg/calendar.svg', width: 26, height: 26,
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(context, LowSpecPageRoute(builder: (_) => const QRPage())),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(shape: BoxShape.circle, color: kPrimary),
              child: SvgPicture.asset(
                'assets/svg/qr.svg', width: 26, height: 26,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(context, LowSpecPageRoute(builder: (_) => const PermitPage())),
            child: SvgPicture.asset(
              'assets/svg/permit.svg', width: 26, height: 26,
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
          ),
          GestureDetector(
            onTap: () {}, // currently on Settings
            child: SvgPicture.asset(
              'assets/svg/settings.svg', width: 26, height: 26,
              colorFilter: const ColorFilter.mode(kPrimary, BlendMode.srcIn),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- Components ----------------

class _SettingTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _SettingTile({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // tuned for light background
    const Color tileColor = Colors.white;             // card bg
    const Color chipColor = Color(0xFFE9E9EE);        // subtle chip bg

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: tileColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: chipColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.black54, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

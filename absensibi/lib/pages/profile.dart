// lib/pages/profile.dart
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // ---- Palette
  static const kPrimary = Colors.purple;
  static const kBg = Color(0xFFF4F4F6);
  static const kTextMuted = Color(0xFF6F6F78);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            children: [
              const SizedBox(height: 8),
              // Avatar with gradient ring
              const _GradientAvatar(size: 120),
              const SizedBox(height: 12),

              // Name
              const Text(
                'Rizq Dzaki Samudera',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              const SizedBox(height: 18),

              // Cards
              const _NameCard(
                name: 'Rizq Dzaki Samudera',
                classLabel: 'XII RPL',
              ),
              const SizedBox(height: 12),
              const _FieldCard(
                title: 'NIS',
                value: '23173602',
                icon: Icons.badge_rounded,
              ),
              const SizedBox(height: 12),
              const _FieldCard(
                title: 'Password',
                value: '••••••••••••••••',
                icon: Icons.lock_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===================================================================
// Widgets
// ===================================================================

class _GradientAvatar extends StatelessWidget {
  final double size;
  const _GradientAvatar({required this.size});

  @override
  Widget build(BuildContext context) {
    // If you have an asset like assets/images/avatar.png, replace the Icon below with that Image.
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFFF6A3D), Color(0xFFFF3366)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6))],
      ),
      child: Center(
        child: ClipOval(
          child: Container(
            width: size * 0.86,
            height: size * 0.86,
            color: Colors.white.withOpacity(0.06),
            alignment: Alignment.center,
            // Replace this Icon with your asset if available:
            child: const Icon(Icons.person, size: 56, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _NameCard extends StatelessWidget {
  final String name;
  final String classLabel;
  const _NameCard({required this.name, required this.classLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF1E9FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.badge_rounded, color: ProfilePage.kPrimary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.black,
                    )),
                const SizedBox(height: 4),
                Text(
                  classLabel,
                  style: const TextStyle(fontSize: 12, color: ProfilePage.kTextMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  const _FieldCard({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: Colors.black54),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    )),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

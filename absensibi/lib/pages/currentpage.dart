import 'package:flutter/material.dart';
import 'package:absensibi/pages/bottomnavbar.dart';
import 'package:absensibi/pages/home.dart';
import 'package:absensibi/pages/qr.dart';
import 'package:absensibi/pages/calendar.dart';
import 'package:absensibi/pages/permit.dart';
import 'package:absensibi/pages/settings.dart';
// import 'package:absensibi/low_spec_animation.dart';

class CurrentPage extends StatefulWidget {
  const CurrentPage({super.key});

  @override
  State<CurrentPage> createState() => _CurrentPageState();
}

class _CurrentPageState extends State<CurrentPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    CalendarPage(),
    QRPage(),
    PermitPage(),
    SettingsPage(),
  ];

  // 👉 Di sini kita kontrol tombol back HP
  Future<bool> _onWillPop() async {
    // Kalau mau back-nya bener2 MATI:
    return false;

    // Atau kalau mau: back pertama balik ke tab 0, baru kalau sudah di tab 0 tetap ignore:
    /*
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false; // jangan pop route
    }
    return false; // tetap ignore exit
    */
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,   // <-- ini yang matiin / custom back
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;   // ganti page TANPA Navigator.push
            });
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:absensibi/pages/bottomnavbar.dart';
import 'package:absensibi/pages/home.dart';
import 'package:absensibi/pages/qr.dart';
import 'package:absensibi/pages/calendar.dart';
import 'package:absensibi/pages/permit.dart';
import 'package:absensibi/pages/settings.dart';
import 'package:absensibi/low_spec_animation.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

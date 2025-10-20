import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:absensibi/pages/calendar.dart';
import 'package:absensibi/pages/permit.dart';
import 'package:absensibi/pages/qr.dart';
import 'package:absensibi/pages/settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [_profileSec(), _laporanKehadiranSec()],
        ),

        bottomNavigationBar: _navBar(context),
      ),
    );
  }

  static Container _navBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
            child: SvgPicture.asset(
              'assets/svg/home.svg',
              width: 26,
              height: 26,
              colorFilter: ColorFilter.mode(Colors.purple, BlendMode.srcIn),
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CalendarPage()),
              );
            },
            child: SvgPicture.asset(
              'assets/svg/calendar.svg',
              width: 26,
              height: 26,
              colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QRPage()),
              );
            },
            child: Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple,
              ),
              child: SvgPicture.asset(
                'assets/svg/qr.svg',
                width: 26,
                height: 26,
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PermitPage()),
              );
            },
            child: SvgPicture.asset(
              'assets/svg/permit.svg',
              width: 26,
              height: 26,
              colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
            child: SvgPicture.asset(
              'assets/svg/settings.svg',
              width: 26,
              height: 26,
              colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
          ),
        ],
      ),
    );
  }

  Container _profileSec() {
    return Container(
      width: double.infinity,
      height: 120.0,
      margin: const EdgeInsets.only(left: 20.0, right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.deepPurple,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 35, backgroundColor: Colors.green),
              const SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Selamat Pagi!'),
                  Text('Mohammad Aqil Athvihaz'),
                  Text('XII RPL'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container _laporanKehadiranSec() {
    return Container(
      width: double.infinity,
      height: 120.0,
      margin: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.deepPurple,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('LAPORAN KEHADIRAN')],
      ),
    );
  }
}

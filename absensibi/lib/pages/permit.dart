import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:absensibi/pages/home.dart';
import 'package:absensibi/pages/calendar.dart';
import 'package:absensibi/pages/qr.dart';
import 'package:absensibi/pages/settings.dart';

class PermitPage extends StatefulWidget {
  const PermitPage({super.key});

  @override
  State<PermitPage> createState() => _PermitPageState();
}

class _PermitPageState extends State<PermitPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Izin",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 40),
          ],
        ),
      ),
      bottomNavigationBar: _navBar(context),
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
              colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
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
              colorFilter: ColorFilter.mode(Colors.purple, BlendMode.srcIn),
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
}

import 'package:flutter/material.dart';
import 'pages/login.dart';

// tambahin dua import ini
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init data locale untuk Bahasa Indonesia
  await initializeDateFormatting('id_ID', null);
  Intl.defaultLocale = 'id_ID'; // optional, tapi enak biar default Indo

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Absensi BI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 0, 166),
          brightness: Brightness.light,
        ),
      ),
      home: const LandingPage(),
    );
  }
}

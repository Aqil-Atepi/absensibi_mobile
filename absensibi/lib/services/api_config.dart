// lib/services/api_config.dart
class ApiConfig {
  // Untuk Android emulator (backend di host yang sama):
  // gunakan 10.0.2.2
  // Untuk HP fisik: ganti dengan IP PC, misal 192.168.1.16
  //static const String baseUrl = 'http://10.0.2.2/backend/api';
 static const String baseUrl = 'http://192.168.1.16/backend/api';

  // Endpoints
  static const String login = '$baseUrl/auth/login.php';
  static const String logout = '$baseUrl/auth/logout.php';

  static const String checkin = '$baseUrl/absensi/checkin.php';

  static const String laporanKehadiran = '$baseUrl/laporan/kehadiran.php';
  static const String riwayatKehadiran = '$baseUrl/laporan/riwayat.php';

  static const String kalenderData = '$baseUrl/kalender/data.php';

  static const String izinSubmit = '$baseUrl/izin/submit.php';
  static const String izinHistory = '$baseUrl/izin/history.php';
  static const String izinDetail = '$baseUrl/izin/detail.php';

  static const String profileGet = '$baseUrl/profile/get.php';
  static const String profileUpdate = '$baseUrl/profile/update.php';
  static const String changePassword = '$baseUrl/profile/change-password.php';

  static const String qrGenerate = '$baseUrl/qr/generate.php';
  static const String qrValidate = '$baseUrl/qr/validate.php';

  static const String jadwalGet = '$baseUrl/jadwal/get.php';
  static const String jadwalToday = '$baseUrl/jadwal/today.php';
  static const String eventUpcoming = '$baseUrl/event/upcoming.php';

  // Headers
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
}

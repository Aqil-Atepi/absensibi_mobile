import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:absensibi/pages/home.dart';
import 'package:absensibi/pages/permit.dart';
import 'package:absensibi/pages/qr.dart';
import 'package:absensibi/pages/settings.dart';

// --- Shared look & feel ---
const kPrimary = Colors.purple;
const kBg = Color(0xFFF0F2F6); // keep as-is; change to 0xFFF4F4F6 if you prefer

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  int _month = DateTime.now().month; // 1..12
  int _year = DateTime.now().year;

  DateTime get _visibleMonth => DateTime(_year, _month, 1);

  final Map<int, Color> _markers = const {
    1: Color(0xFF2AAE4A),
    2: Color(0xFFE35151),
    3: Color(0xFF6B35E0),
  };

  static const List<String> _monthNames = [
    'January','February','March','April','May','June',
    'July','August','September','October','November','December'
  ];
  static final List<int> _years =
      List<int>.generate(2100 - 2020 + 1, (i) => 2020 + i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimary,                     // ⬅️ purple top bar
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Kalendar',
          style: TextStyle(
            color: Colors.white,                       // white title
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white), // white icons
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              _MonthCard(
                month: _visibleMonth,
                markers: _markers,
                monthNames: _monthNames,
                years: _years,
                selectedMonth: _month,
                selectedYear: _year,
                onChangedMonth: (m) => setState(() => _month = m),
                onChangedYear: (y) => setState(() => _year = y),
              ),
            ],
          ),
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
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HomePage())),
            child: SvgPicture.asset(
              'assets/svg/home.svg', width: 26, height: 26,
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: SvgPicture.asset(
              'assets/svg/calendar.svg', width: 26, height: 26,
              colorFilter: const ColorFilter.mode(kPrimary, BlendMode.srcIn), // active
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QRPage())),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                shape: BoxShape.circle, color: kPrimary,
                boxShadow: [BoxShadow(color: Color(0x33000000), blurRadius: 8)],
              ),
              child: SvgPicture.asset(
                'assets/svg/qr.svg', width: 26, height: 26,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PermitPage())),
            child: SvgPicture.asset(
              'assets/svg/permit.svg', width: 26, height: 26,
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())),
            child: SvgPicture.asset(
              'assets/svg/settings.svg', width: 26, height: 26,
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
          ),
        ],
      ),
    );
  }
}

// ===================================================================
// Month Card with Month + Year Dropdowns
// ===================================================================

class _MonthCard extends StatelessWidget {
  final DateTime month;
  final Map<int, Color> markers;
  final List<String> monthNames;
  final List<int> years;
  final int selectedMonth;
  final int selectedYear;
  final ValueChanged<int> onChangedMonth;
  final ValueChanged<int> onChangedYear;

  const _MonthCard({
    required this.month,
    required this.markers,
    required this.monthNames,
    required this.years,
    required this.selectedMonth,
    required this.selectedYear,
    required this.onChangedMonth,
    required this.onChangedYear,
  });

  @override
  Widget build(BuildContext context) {
    final first = DateTime(month.year, month.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final leading = (first.weekday + 6) % 7; // Monday-first offset
    final List<int?> cells = List<int?>.filled(42, null);
    for (int i = 0; i < daysInMonth; i++) {
      cells[leading + i] = i + 1;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 3))],
        ),
        child: Column(
          children: [
            // Month + Year dropdowns
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _DropdownShell(
                  child: DropdownButton<int>(
                    value: selectedMonth,
                    items: List.generate(
                      12,
                      (i) => DropdownMenuItem(
                        value: i + 1,
                        child: Text(monthNames[i]),
                      ),
                    ),
                    onChanged: (v) => v != null ? onChangedMonth(v) : null,
                    underline: const SizedBox.shrink(),
                    isDense: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                ),
                const SizedBox(width: 8),
                _DropdownShell(
                  child: DropdownButton<int>(
                    value: selectedYear,
                    items: years.map((y) => DropdownMenuItem<int>(value: y, child: Text('$y'))).toList(),
                    onChanged: (v) => v != null ? onChangedYear(v) : null,
                    underline: const SizedBox.shrink(),
                    isDense: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Weekdays
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _Dow('M'), _Dow('T'), _Dow('W'), _Dow('T'), _Dow('F'), _Dow('S'), _Dow('S'),
              ],
            ),
            const SizedBox(height: 8),
            // Days grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cells.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (_, i) {
                final day = cells[i];
                if (day == null) return const SizedBox.shrink();

                final markColor = markers[day];
                if (markColor != null) {
                  return AspectRatio(
                    aspectRatio: 1,
                    child: Center(
                      child: Container(
                        width: 28, height: 28,
                        decoration: BoxDecoration(color: markColor, shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: Text(
                          '$day',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                      ),
                    ),
                  );
                }
                return AspectRatio(
                  aspectRatio: 1,
                  child: Center(
                    child: Text('$day', style: const TextStyle(fontSize: 13, color: Colors.black87)),
                  ),
                );
              },
            ),
            const SizedBox(height: 6),
            // Drag handle
            Container(
              width: 48, height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E6EA),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DropdownShell extends StatelessWidget {
  final Widget child;
  const _DropdownShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}

class _Dow extends StatelessWidget {
  final String label;
  const _Dow(this.label);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.black87)),
      ),
    );
  }
}

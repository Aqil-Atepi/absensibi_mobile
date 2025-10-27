import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final List<String> _icons = [
    'assets/svg/home.svg',
    'assets/svg/calendar.svg',
    'assets/svg/qr.svg',
    'assets/svg/permit.svg',
    'assets/svg/settings.svg',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_icons.length, (index) {
          final isSelected = widget.currentIndex == index;
          final isCenter = index == 2;

          return GestureDetector(
            onTap: () => widget.onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(isCenter ? 14 : 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCenter
                    ? Colors.purple
                    : isSelected
                        ? Colors.purple.withOpacity(0.1)
                        : Colors.transparent,
              ),
              child: SvgPicture.asset(
                _icons[index],
                width: 26,
                height: 26,
                colorFilter: ColorFilter.mode(
                  isCenter
                      ? Colors.white
                      : isSelected
                          ? Colors.purple
                          : Colors.grey,
                  BlendMode.srcIn,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
